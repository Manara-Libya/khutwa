package ly.manara.khutwa

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import ly.manara.khutwa.data.A2ui
import ly.manara.khutwa.data.Analysis
import ly.manara.khutwa.data.KhutwaApi
import ly.manara.khutwa.data.Option
import ly.manara.khutwa.data.RiskKeywords
import ly.manara.khutwa.data.Texts
import ly.manara.khutwa.data.Turn
import ly.manara.khutwa.privacy.ConversationPrivacy

sealed interface Screen {
    data object Consent : Screen
    data object Chat : Screen
    /** [auto]: opened because of what the user wrote (shows the extra intro line). */
    data class Urgent(val auto: Boolean, val returnTo: Screen) : Screen
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
)

private var nextLineId = 0L

data class UiState(
    val screen: Screen = Screen.Consent,
    val lines: List<Line> = listOf(Line(mine = false, text = Texts.GREETING)),
    val waiting: Boolean = false,
    val failed: Boolean = false,
    val supportReady: Boolean = false,
)

/**
 * Everything lives in memory and disappears with the app: no accounts, no storage, no logs.
 * Only redacted text reaches [KhutwaApi]; real names come back only on the phone.
 */
class AppViewModel(
    private val api: KhutwaApi,
    private val privacy: ConversationPrivacy = ConversationPrivacy(),
) : ViewModel() {
    private val _state = MutableStateFlow(UiState())
    val state: StateFlow<UiState> = _state

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
        askedForHelp = message == Texts.WHO_TO_TALK_MESSAGE
        val redacted = privacy.redact(message)
        _state.update { it.copy(lines = it.lines + Line(true, message, sent = redacted), failed = false) }
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
        viewModelScope.launch {
            val result = runCatching { withContext(Dispatchers.IO) { api.analyze(redacted, sentHistory) } }
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
        _state.update {
            var lines = it.lines
            if (reply != null) lines = lines + Line(false, privacy.restore(reply), reveal = true)
            if (ready != null) lines = lines + Line(false, "", surface = ready)
            if (placeholder != null) lines = lines + placeholder
            it.copy(waiting = false, lines = lines, supportReady = it.supportReady || a.supportReady)
        }
        // Reply first: the options load right after, so the conversation never waits for them.
        if (placeholder != null) loadSupport(redacted, placeholder.id)
    }

    private fun loadSupport(redacted: String, placeholderId: Long) {
        val sentHistory = history.dropLast(if (history.lastOrNull()?.role == "assistant") 2 else 1)
        viewModelScope.launch {
            val surface = runCatching { withContext(Dispatchers.IO) { api.support(redacted, sentHistory) } }
                .getOrNull()?.let { A2ui.parse(it.a2ui, privacy::restore) }
                ?: A2ui.local(Texts.GENERIC_OPTIONS)
            _state.update { s ->
                s.copy(lines = s.lines.map { if (it.id == placeholderId) it.copy(loadingSurface = false, surface = surface) else it })
            }
        }
    }

    fun revealed(id: Long) = _state.update { s -> s.copy(lines = s.lines.map { if (it.id == id) it.copy(reveal = false) else it }) }

    fun askWhoToTalkTo() = send(Texts.WHO_TO_TALK_MESSAGE)

    fun openUrgent() = _state.update {
        val from = it.screen
        if (from is Screen.Urgent) it else it.copy(screen = Screen.Urgent(auto = false, returnTo = from))
    }

    /** Returns false when there is nowhere to go back to (the system then leaves the app). */
    fun back(): Boolean {
        val s = _state.value.screen
        val target = when (s) {
            is Screen.Urgent -> s.returnTo
            else -> return false
        }
        _state.update { it.copy(screen = target) }
        return true
    }

    fun newChat() {
        history.clear()
        privacy.clear()
        pending = null
        surfaceShown = false
        askedForHelp = false
        _state.value = UiState(screen = Screen.Chat)
    }
}
