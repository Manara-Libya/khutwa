package ly.manara.khutwa.ui.components

import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue

/** Brand doodles (SVGs in the doodles folder): path data and viewBox, drawn stroke by stroke by [Doodle]. */
object Doodles {
    val UNDERLINE = DoodleSpec(
        width = 240.0f, height = 24.0f, strokeWidth = 5.0f,
        paths = listOf(
            "M6 13.9C15 13 41 9 60.2 8.7C79.3 8.3 101.1 12 121 12C140.9 12 161 8.6 179.9 8.8C198.7 9 225.2 12.5 234.3 13.2",
            "M29.3 19C42.7 18.8 81.5 18 110 17.9C138.6 17.9 185.5 18.5 200.6 18.6",
        ),
    )
    val SPARKLES = DoodleSpec(
        width = 120.0f, height = 120.0f, strokeWidth = 3.5f,
        paths = listOf(
            "M18.1 70.1C26.7 70.2 61.1 70.3 69.7 70.3",
            "M44 43.7C44 52.4 43.9 87.5 43.9 96.3",
            "M28.1 54.3C33.3 59.4 54.1 80.2 59.3 85.4",
            "M59.6 54.5C54.4 59.7 33.8 80.6 28.7 85.9",
            "M77.6 34.3C82.3 34.3 101.1 34.2 105.8 34.2",
            "M92.3 20C92.2 24.6 91.9 43.3 91.9 47.9",
            "M83.6 25.7C86.5 28.5 98 39.6 100.8 42.4",
            "M100.4 25.8C97.6 28.5 86.4 39.3 83.6 42",
            "M87.2 96.4C90.1 96.3 101.8 95.8 104.7 95.7",
            "M96.2 87.1C96.2 90 96.3 101.9 96.3 104.9",
            "M90.2 90.2C92 92.1 99.3 99.7 101.1 101.6",
            "M100.9 90.5C99.2 92.3 92.2 99.5 90.4 101.3",
        ),
    )
    val SQUIGGLE = DoodleSpec(
        width = 240.0f, height = 40.0f, strokeWidth = 4.0f,
        paths = listOf(
            "M8 10C10.7 13.3 18.7 30 24 30C29.3 30 34.7 10 40 10C45.3 10 50.7 30 56 30C61.3 30 66.7 10 72 10C77.3 10 82.7 30 88 30C93.3 30 98.7 10 104 10C109.3 10 114.7 30 120 30C125.3 30 130.7 10 136 10C141.3 10 146.7 30 152 30C157.3 30 162.7 10 168 10C173.3 10 178.7 30 184 30C189.3 30 194.7 10 200 10C205.3 10 210.7 30 216 30C221.3 30 229.3 13.3 232 10",
        ),
    )
    val UNDERLINE_DOUBLE = DoodleSpec(
        width = 240.0f, height = 30.0f, strokeWidth = 3.5f,
        paths = listOf(
            "M9.2 9.7C27.8 9.1 83.8 6.2 120.9 6.3C158 6.4 213.4 9.7 231.9 10.4",
            "M20.8 20.3C37.5 19.9 88.9 17.7 121.1 18C153.2 18.3 198.3 21.6 213.8 22.3",
        ),
    )
}

data class DoodleSpec(val width: Float, val height: Float, val strokeWidth: Float, val paths: List<String>)

/**
 * Draws a brand doodle the way a pen would: stroke after stroke, along each path, once.
 * In right-to-left layouts the drawing is mirrored so the pen moves from right to left.
 * Decoration only: one or two per screen, never a control, never the only carrier of meaning.
 */
@androidx.compose.runtime.Composable
fun Doodle(
    spec: DoodleSpec,
    color: androidx.compose.ui.graphics.Color,
    modifier: androidx.compose.ui.Modifier,
    key: Any,
    delayMillis: Long = 0,
    durationMillis: Int = 650,
    mirrorInRtl: Boolean = true,
) {
    val paths = androidx.compose.runtime.remember(spec) {
        spec.paths.map { androidx.compose.ui.graphics.vector.PathParser().parsePathString(it).toPath() }
    }
    val lengths = androidx.compose.runtime.remember(paths) {
        paths.map { p -> androidx.compose.ui.graphics.PathMeasure().apply { setPath(p, false) }.length }
    }
    var done by androidx.compose.runtime.saveable.rememberSaveable(key) { androidx.compose.runtime.mutableStateOf(false) }
    val progress = androidx.compose.runtime.remember(key) { androidx.compose.animation.core.Animatable(if (done) 1f else 0f) }
    androidx.compose.runtime.LaunchedEffect(key) {
        if (!done) {
            kotlinx.coroutines.delay(delayMillis)
            progress.animateTo(1f, androidx.compose.animation.core.tween(durationMillis, easing = KhMotion.EmphasizedDecelerate))
            done = true
        }
    }
    val rtl = androidx.compose.ui.platform.LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl
    androidx.compose.foundation.Canvas(modifier) {
        val s = minOf(size.width / spec.width, size.height / spec.height)
        val dx = (size.width - spec.width * s) / 2f
        val dy = (size.height - spec.height * s) / 2f
        val flip = rtl && mirrorInRtl
        val total = lengths.sum()
        var drawn = progress.value * total
        val measure = androidx.compose.ui.graphics.PathMeasure()
        val stroke = androidx.compose.ui.graphics.drawscope.Stroke(
            width = spec.strokeWidth * s,
            cap = androidx.compose.ui.graphics.StrokeCap.Round,
            join = androidx.compose.ui.graphics.StrokeJoin.Round,
        )
        paths.forEachIndexed { i, p ->
            if (drawn <= 0f) return@forEachIndexed
            val part = minOf(drawn, lengths[i]); drawn -= lengths[i]
            val seg = androidx.compose.ui.graphics.Path()
            measure.setPath(p, false)
            measure.getSegment(0f, part, seg, true)
            // map doodle units onto the canvas (mirrored for right-to-left)
            val m = androidx.compose.ui.graphics.Matrix().apply {
                if (flip) { translate(size.width - dx, dy); scale(-s, s) } else { translate(dx, dy); scale(s, s) }
            }
            seg.transform(m)
            drawPath(seg, color, style = stroke)
        }
    }
}
