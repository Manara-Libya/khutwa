package ly.manara.khutwa.ui.components

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf

/**
 * How the app looks and moves. Only these display choices are kept on the phone (never backed up, never sent);
 * the conversation and how the user is addressed are never stored.
 */
object Prefs {
    enum class Theme { System, Light, Dark }

    private var sp: SharedPreferences? = null
    private val _theme = mutableStateOf(Theme.System)
    private val _textScale = mutableFloatStateOf(1f)
    private val _calmMotion = mutableStateOf(false)
    private val _haptics = mutableStateOf(true)
    private val _instantReplies = mutableStateOf(false)

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

    fun load(context: Context) {
        val p = context.getSharedPreferences("khutwa_display", Context.MODE_PRIVATE)
        val systemAnimationsOff = android.provider.Settings.Global.getFloat(
            context.contentResolver, android.provider.Settings.Global.ANIMATOR_DURATION_SCALE, 1f) == 0f
        _theme.value = runCatching { Theme.valueOf(p.getString("theme", null) ?: "System") }.getOrDefault(Theme.System)
        _textScale.floatValue = p.getFloat("textScale", 1f)
        _calmMotion.value = p.getBoolean("calmMotion", systemAnimationsOff)
        _haptics.value = p.getBoolean("haptics", true)
        _instantReplies.value = p.getBoolean("instantReplies", false)
        sp = p
    }
}
