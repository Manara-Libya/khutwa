package ly.manara.khutwa.ui.components

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf

/**
 * How the app looks and moves, and whether the user chose to save their chats. Only these choices are kept here
 * (never backed up, never sent). Saved chats themselves live encrypted in [ly.manara.khutwa.data.ChatStore].
 */
object Prefs {
    enum class Theme { System, Light, Dark }

    private var sp: SharedPreferences? = null
    private val _theme = mutableStateOf(Theme.System)
    private val _textScale = mutableFloatStateOf(1f)
    private val _calmMotion = mutableStateOf(false)
    private val _haptics = mutableStateOf(true)
    private val _instantReplies = mutableStateOf(false)
    private val _keepHistory = mutableStateOf(false)
    private val _useMemory = mutableStateOf(true)

    var theme: Theme
        get() = _theme.value
        set(v) { _theme.value = v; sp?.edit()?.putString("theme", v.name)?.apply() }
    /** Multiplies the phone's own font size, so it adds to the system setting rather than replacing it. */
    var textScale: Float
        get() = _textScale.floatValue
        set(v) { _textScale.floatValue = v; sp?.edit()?.putFloat("textScale", v)?.apply() }
    /** Doodles appear already drawn and nothing loops. Defaults on when the phone's animations are switched off. */
    var calmMotion: Boolean
        get() = _calmMotion.value
        set(v) { _calmMotion.value = v; sp?.edit()?.putBoolean("calmMotion", v)?.apply() }
    var haptics: Boolean
        get() = _haptics.value
        set(v) { _haptics.value = v; sp?.edit()?.putBoolean("haptics", v)?.apply() }
    /** Replies appear whole instead of word by word. */
    var instantReplies: Boolean
        get() = _instantReplies.value
        set(v) { _instantReplies.value = v; sp?.edit()?.putBoolean("instantReplies", v)?.apply() }

    /** Off by default: chats are saved on the phone only when the user turns this on. */
    var keepHistory: Boolean
        get() = _keepHistory.value
        set(v) { _keepHistory.value = v; sp?.edit()?.putBoolean("keepHistory", v)?.apply() }
    /** With saved chats on: Khutwa keeps short notes across chats. */
    var useMemory: Boolean
        get() = _useMemory.value
        set(v) { _useMemory.value = v; sp?.edit()?.putBoolean("useMemory", v)?.apply() }

    fun load(context: Context) {
        val p = context.getSharedPreferences("khutwa_display", Context.MODE_PRIVATE)
        val systemAnimationsOff = android.provider.Settings.Global.getFloat(
            context.contentResolver, android.provider.Settings.Global.ANIMATOR_DURATION_SCALE, 1f) == 0f
        _theme.value = runCatching { Theme.valueOf(p.getString("theme", null) ?: "System") }.getOrDefault(Theme.System)
        _textScale.floatValue = p.getFloat("textScale", 1f)
        _calmMotion.value = p.getBoolean("calmMotion", systemAnimationsOff)
        _haptics.value = p.getBoolean("haptics", true)
        _instantReplies.value = p.getBoolean("instantReplies", false)
        _keepHistory.value = p.getBoolean("keepHistory", false)
        _useMemory.value = p.getBoolean("useMemory", true)
        sp = p
    }
}
