package ly.manara.khutwa.ui.components

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.CubicBezierEasing
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.animation.fadeIn
import androidx.compose.animation.scaleIn
import androidx.compose.animation.slideInVertically
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.unit.IntOffset
import kotlinx.coroutines.delay

/** Material 3 motion: emphasized easing curves and the springs used across the app. */
object KhMotion {
    val EmphasizedDecelerate = CubicBezierEasing(0.05f, 0.7f, 0.1f, 1f)
    val EmphasizedAccelerate = CubicBezierEasing(0.3f, 0f, 0.8f, 0.15f)
    fun <T> gentle() = spring<T>(dampingRatio = 0.82f, stiffness = Spring.StiffnessMediumLow)
    fun <T> snappy() = spring<T>(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessMedium)
    val gentleOffset = spring(dampingRatio = 0.82f, stiffness = Spring.StiffnessMediumLow, visibilityThreshold = IntOffset(1, 1))
}

/**
 * New content arrives once: a short fade, a small rise and a slight scale, on a gentle spring.
 * Keyed so an item that was already shown never animates again (scrolling back does not replay it).
 * System "remove animations" settings are respected by Compose's animation clock.
 */
@Composable
fun Appear(key: Any, delayMillis: Long = 0, content: @Composable () -> Unit) {
    if (Prefs.calmMotion) { content(); return }
    var shown by rememberSaveable(key) { mutableStateOf(false) }
    LaunchedEffect(key) {
        if (!shown) {
            if (delayMillis > 0) delay(delayMillis)
            shown = true
        }
    }
    AnimatedVisibility(
        visible = shown,
        enter = fadeIn(KhMotion.gentle()) +
            slideInVertically(KhMotion.gentleOffset) { it / 5 } +
            scaleIn(KhMotion.gentle(), initialScale = 0.96f),
    ) { content() }
}
