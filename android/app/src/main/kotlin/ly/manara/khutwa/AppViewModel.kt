package ly.manara.khutwa

import ly.manara.khutwa.ui.components.t
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import ly.manara.khutwa.data.A2ui
import ly.manara.khutwa.data.Analysis
import ly.manara.khutwa.data.ChatStore
import ly.manara.khutwa.data.SavedChat
import ly.manara.khutwa.data.SavedLine
import ly.manara.khutwa.data.KhutwaApi
import ly.manara.khutwa.data.Option
import ly.manara.khutwa.data.RiskKeywords
import ly.manara.khutwa.data.Texts
import ly.manara.khutwa.data.Turn
import ly.manara.khutwa.privacy.ConversationPrivacy
import ly.manara.khutwa.ui.components.Prefs
import org.json.JSONArray

sealed interface Screen {
    data object Consent : Screen
    data object Chat : Screen
    /** [auto]: opened because of what the user wrote (shows the extra intro line). */
    data class Urgent(val auto: Boolean, val returnTo: Screen) : Screen
    data class Settings(val returnTo: Screen) : Screen
    data class History(val returnTo: Screen) : Screen
}

/**
 * One item in the conversation. [reveal]: a new Khutwa reply shown word by word (already checked by the server).
 * [surface]: inline A2UI support options, with real names already restored.
 */
data class Line(
    val mine: Boolean,
    val text: String,
    val id: Long = nextLineId++,
    val reveal: Boolean = false,
    val surface: A2ui.Surface? = null,
    /** A placeholder while the support options load. */
    val loadingSurface: Boolean = false,
    /** For the user's lines: exactly what left the phone (redacted), or null when nothing was sent. */
    val sent: String? = null,
    /** The user's line stayed on the phone (the offline risk check opened the urgent screen instead). */
    val stayedOnPhone: Boolean = false,
    /** For Khutwa's replies: the reply as the server wrote it (placeholders), kept to continue a saved chat. */
    val wire: String? = null,
    /** For a server options surface: its A2UI messages (placeholders), kept to show it again in a saved chat. */
    val a2ui: String? = null,
)

private var nextLineId = 0L

data class UiState(
    val screen: Screen = Screen.Consent,
    val lines: List<Line> = listOf(Line(mine = false, text = Texts.GREETING)),
    val waiting: Boolean = false,
    val failed: Boolean = false,
    val supportReady: Boolean = false,
    /** Saved chats, newest first (only when the user turned saved chats on). */
    val savedChats: List<SavedChat> = emptyList(),
    /** The notes Khutwa keeps across chats, with real names (on the phone only). */
    val memory: String = "",
    /** The saved chat this conversation is, if any. */
    val chatId: Long? = null,
)

/**
 * By default everything lives in memory and disappears with the app: no accounts, no storage, no logs.
 * Users who turn on saved chats get them kept in [store], encrypted on the phone, with short notes across chats.
 * Only redacted text reaches [KhutwaApi]; real names come back only on the phone.
 */
class AppViewModel(
    private val api: KhutwaApi,
    private val privacy: ConversationPrivacy = ConversationPrivacy(),
    private val store: ChatStore? = null,
) : ViewModel() {
    private val _state = MutableStateFlow(UiState())
    val state: StateFlow<UiState> = _state

    /** Store writes run one at a time, in order, off the main thread. */
    private val io = Dispatchers.IO.limitedParallelism(1)
    private var memoryJob: Job? = null

    init {
        if (store != null) viewModelScope.launch {
            withContext(io) { store.load() }
            _state.update { it.copy(savedChats = store.chats, memory = store.memory) }
        }
    }

    /** The conversation as the server sees it: redacted user turns and Khutwa's replies with placeholders. */
    private val history = mutableListOf<Turn>()
    private var pending: String? = null   // redacted text waiting for a retry
    private var surfaceShown = false
    private var askedForHelp = false

    fun acceptConsent() = _state.update { it.copy(screen = Screen.Chat) }

    fun send(text: String) {
        val message = text.trim()
        if (message.isEmpty() || _state.value.waiting) return
        // Unmistakable risk wording: straight to the fixed urgent screen, nothing is sent (works offline).
        if (RiskKeywords.matches(message)) {
            _state.update { it.copy(lines = it.lines + Line(true, message, stayedOnPhone = true), failed = false,
                screen = Screen.Urgent(auto = true, returnTo = Screen.Chat)) }
            return
        }
        askedForHelp = message == t(Texts.WHO_TO_TALK_MESSAGE)
        val redacted = privacy.redact(message)
        _state.update { it.copy(lines = it.lines + Line(true, message, sent = redacted), failed = false) }
        persist()
        pending = redacted
        ask(redacted)
    }

    fun retry() {
        val redacted = pending ?: return
        _state.update { it.copy(failed = false) }
        ask(redacted)
    }

    private fun ask(redacted: String) {
        _state.update { it.copy(waiting = true) }
        val sentHistory = history.toList()
        val memory = memoryToSend()
        viewModelScope.launch {
            val result = runCatching { withContext(Dispatchers.IO) { api.analyze(redacted, sentHistory, memory) } }
            pending = if (result.isSuccess) null else redacted
            result.fold(onSuccess = { handle(redacted, it) }, onFailure = {
                _state.update { it.copy(waiting = false, failed = true) }
            })
        }
    }

    private fun handle(redacted: String, a: Analysis) {
        history += Turn("user", redacted)
        if (a.urgent) {
            // No AI text is ever shown with an urgent result.
            _state.update { it.copy(waiting = false, screen = Screen.Urgent(auto = true, returnTo = Screen.Chat)) }
            return
        }
        val reply = a.reflection
        if (reply != null) history += Turn("assistant", reply)
        // The support options appear inline once, when Khutwa has listened enough, and again whenever the user asks.
        val wantSurface = a.supportReady && (!surfaceShown || askedForHelp)
        val ready = if (!wantSurface) null else A2ui.parse(a.a2ui, privacy::restore)
            ?: a.suggestions.takeIf { it.isNotEmpty() }?.let { s ->
                A2ui.local(s.map { Option(it.type, privacy.restore(it.why), privacy.restore(it.draft)) })
            }
        if (wantSurface) surfaceShown = true
        val placeholder = if (wantSurface && ready == null) Line(false, "", loadingSurface = true) else null
        val readyJson = if (ready != null && a.a2ui.length() > 0) a.a2ui.toString() else null
        _state.update {
            var lines = it.lines
            if (reply != null) lines = lines + Line(false, privacy.restore(reply), reveal = true, wire = reply)
            if (ready != null) lines = lines + Line(false, "", surface = ready, a2ui = readyJson)
            if (placeholder != null) lines = lines + placeholder
            it.copy(waiting = false, lines = lines, supportReady = it.supportReady || a.supportReady)
        }
        persist()
        if (reply != null) updateMemory()
        // Reply first: the options load right after, so the conversation never waits for them.
        if (placeholder != null) loadSupport(redacted, placeholder.id)
    }

    private fun loadSupport(redacted: String, placeholderId: Long) {
        val sentHistory = history.dropLast(if (history.lastOrNull()?.role == "assistant") 2 else 1)
        val memory = memoryToSend()
        viewModelScope.launch {
            val result = runCatching { withContext(Dispatchers.IO) { api.support(redacted, sentHistory, memory) } }.getOrNull()
            val parsed = result?.let { A2ui.parse(it.a2ui, privacy::restore) }
            val surface = parsed ?: A2ui.local(Texts.GENERIC_OPTIONS)
            val json = if (parsed != null) result.a2ui.toString() else null
            _state.update { s ->
                s.copy(lines = s.lines.map { if (it.id == placeholderId) it.copy(loadingSurface = false, surface = surface, a2ui = json) else it })
            }
            persist()
        }
    }

    fun revealed(id: Long) = _state.update { s -> s.copy(lines = s.lines.map { if (it.id == id) it.copy(reveal = false) else it }) }

    fun askWhoToTalkTo() = send(t(Texts.WHO_TO_TALK_MESSAGE))

    fun openUrgent() = _state.update {
        val from = it.screen
        if (from is Screen.Urgent) it else it.copy(screen = Screen.Urgent(auto = false, returnTo = from))
    }

    /** Returns false when there is nowhere to go back to (the system then leaves the app). */
    fun back(): Boolean {
        val s = _state.value.screen
        val target = when (s) {
            is Screen.Urgent -> s.returnTo
            is Screen.Settings -> s.returnTo
            is Screen.History -> s.returnTo
            else -> return false
        }
        _state.update { it.copy(screen = target) }
        return true
    }

    fun openSettings() = _state.update { if (it.screen is Screen.Settings) it else it.copy(screen = Screen.Settings(returnTo = it.screen)) }

    fun openHistory() = _state.update { if (it.screen is Screen.History) it else it.copy(screen = Screen.History(returnTo = it.screen)) }

    /** Starts a fresh conversation. A saved chat stays in the saved list. */
    fun newChat() {
        history.clear()
        privacy.clear()
        pending = null
        surfaceShown = false
        askedForHelp = false
        _state.update { UiState(screen = Screen.Chat, savedChats = it.savedChats, memory = it.memory) }
    }

    /** Settings' "erase this chat now": also removes it from the saved chats. */
    fun eraseCurrent() {
        _state.value.chatId?.let { deleteChat(it) }
        newChat()
    }

    // --- saved chats (only when the user turned them on) ---

    /** Reopens a saved chat where it was left, with its placeholders, so it can be continued. */
    fun openChat(id: Long) {
        val chat = store?.chats?.firstOrNull { it.id == id } ?: return
        history.clear()
        privacy.restoreFrom(chat.names)
        pending = null
        askedForHelp = false
        val lines = listOf(Line(mine = false, text = Texts.GREETING)) + chat.lines.mapNotNull { l ->
            if (l.a2ui != null) A2ui.parse(runCatching { JSONArray(l.a2ui) }.getOrDefault(JSONArray()), privacy::restore)
                ?.let { Line(false, "", surface = it, a2ui = l.a2ui) }
            else Line(l.mine, l.text, sent = if (l.mine) l.wire else null, wire = if (l.mine) null else l.wire)
        }
        chat.lines.forEach { l -> if (l.a2ui == null && l.wire != null) history += Turn(if (l.mine) "user" else "assistant", l.wire) }
        surfaceShown = lines.any { it.surface != null }
        _state.update { UiState(screen = Screen.Chat, lines = lines, supportReady = surfaceShown, chatId = id,
            savedChats = it.savedChats, memory = it.memory) }
    }

    fun deleteChat(id: Long) {
        val s = store ?: return
        viewModelScope.launch {
            withContext(io) { s.delete(id) }
            _state.update { it.copy(savedChats = s.chats, chatId = it.chatId.takeIf { c -> c != id }) }
        }
    }

    /** Deletes every saved chat and the notes; saving stays on for what comes next. */
    fun deleteAllChats() {
        val s = store ?: return
        viewModelScope.launch {
            withContext(io) { s.clear() }
            _state.update { it.copy(savedChats = emptyList(), memory = "", chatId = null) }
            persist()
        }
    }

    fun setKeepHistory(on: Boolean) {
        Prefs.keepHistory = on
        if (on) { persist(); return }
        // Turning it off deletes everything that was saved, the notes and the key.
        memoryJob?.cancel()
        val s = store ?: return
        viewModelScope.launch {
            withContext(io) { s.clear() }
            _state.update { it.copy(savedChats = emptyList(), memory = "", chatId = null) }
        }
    }

    fun setUseMemory(on: Boolean) {
        Prefs.useMemory = on
        if (!on) clearMemory() else updateMemory()
    }

    fun clearMemory() {
        memoryJob?.cancel()
        val s = store ?: return
        viewModelScope.launch {
            withContext(io) { s.setMemory("") }
            _state.update { it.copy(memory = "") }
        }
    }

    /** Saves the current chat when the user turned saved chats on and has written something. */
    private fun persist() {
        val s = store ?: return
        if (!Prefs.keepHistory) return
        val st = _state.value
        val lines = st.lines.drop(1).mapNotNull { l ->
            when {
                l.loadingSurface -> null
                l.surface != null -> l.a2ui?.let { SavedLine(false, "", a2ui = it) }
                else -> SavedLine(l.mine, l.text, wire = if (l.mine) l.sent else l.wire)
            }
        }
        if (lines.none { it.mine }) return
        val now = System.currentTimeMillis()
        val id = st.chatId ?: now
        val started = st.savedChats.firstOrNull { it.id == id }?.startedAt ?: now
        val chat = SavedChat(id, started, now, lines, privacy.snapshot())
        if (st.chatId == null) _state.update { it.copy(chatId = id) }
        viewModelScope.launch {
            withContext(io) { s.put(chat) }
            _state.update { it.copy(savedChats = s.chats) }
        }
    }

    /** The notes, redacted with this chat's placeholders, when the user keeps them; null otherwise. */
    private fun memoryToSend(): String? {
        val m = store?.memory
        if (!Prefs.keepHistory || !Prefs.useMemory || m.isNullOrBlank()) return null
        return privacy.redact(m)
    }

    /** Updates the notes from this conversation in the background; on any failure the old notes stay. */
    private fun updateMemory() {
        val s = store ?: return
        if (!Prefs.keepHistory || !Prefs.useMemory || history.isEmpty()) return
        val turns = history.toList()
        val memory = memoryToSend()
        val names = ConversationPrivacy().apply { restoreFrom(privacy.snapshot()) }
        memoryJob?.cancel()
        memoryJob = viewModelScope.launch {
            val updated = runCatching { withContext(Dispatchers.IO) { api.remember(turns, memory) } }.getOrNull() ?: return@launch
            if (!Prefs.keepHistory || !Prefs.useMemory) return@launch
            val restored = names.restore(updated).trim()
            withContext(io) { s.setMemory(restored) }
            _state.update { it.copy(memory = restored) }
        }
    }
}
