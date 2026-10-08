package ly.manara.khutwa.ui.components

import androidx.compose.animation.core.animateFloat
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue

/** Brand doodles (SVGs in the doodles folder). Strokes are drawn like a pen; fills fade in after. */
object Doodles {
    val UNDERLINE = DoodleSpec(240.0f, 24.0f, 5.0f, listOf(
        DoodlePart("M6 13.9C15 13 41 9 60.2 8.7C79.3 8.3 101.1 12 121 12C140.9 12 161 8.6 179.9 8.8C198.7 9 225.2 12.5 234.3 13.2", fill = false, color = null),
        DoodlePart("M29.3 19C42.7 18.8 81.5 18 110 17.9C138.6 17.9 185.5 18.5 200.6 18.6", fill = false, color = null),
    ))
    val SPARKLES = DoodleSpec(120.0f, 120.0f, 3.5f, listOf(
        DoodlePart("M18.1 70.1C26.7 70.2 61.1 70.3 69.7 70.3", fill = false, color = null),
        DoodlePart("M44 43.7C44 52.4 43.9 87.5 43.9 96.3", fill = false, color = null),
        DoodlePart("M28.1 54.3C33.3 59.4 54.1 80.2 59.3 85.4", fill = false, color = null),
        DoodlePart("M59.6 54.5C54.4 59.7 33.8 80.6 28.7 85.9", fill = false, color = null),
        DoodlePart("M77.6 34.3C82.3 34.3 101.1 34.2 105.8 34.2", fill = false, color = null),
        DoodlePart("M92.3 20C92.2 24.6 91.9 43.3 91.9 47.9", fill = false, color = null),
        DoodlePart("M83.6 25.7C86.5 28.5 98 39.6 100.8 42.4", fill = false, color = null),
        DoodlePart("M100.4 25.8C97.6 28.5 86.4 39.3 83.6 42", fill = false, color = null),
        DoodlePart("M87.2 96.4C90.1 96.3 101.8 95.8 104.7 95.7", fill = false, color = null),
        DoodlePart("M96.2 87.1C96.2 90 96.3 101.9 96.3 104.9", fill = false, color = null),
        DoodlePart("M90.2 90.2C92 92.1 99.3 99.7 101.1 101.6", fill = false, color = null),
        DoodlePart("M100.9 90.5C99.2 92.3 92.2 99.5 90.4 101.3", fill = false, color = null),
    ))
    val SQUIGGLE = DoodleSpec(240.0f, 40.0f, 4.0f, listOf(
        DoodlePart("M8 10C10.7 13.3 18.7 30 24 30C29.3 30 34.7 10 40 10C45.3 10 50.7 30 56 30C61.3 30 66.7 10 72 10C77.3 10 82.7 30 88 30C93.3 30 98.7 10 104 10C109.3 10 114.7 30 120 30C125.3 30 130.7 10 136 10C141.3 10 146.7 30 152 30C157.3 30 162.7 10 168 10C173.3 10 178.7 30 184 30C189.3 30 194.7 10 200 10C205.3 10 210.7 30 216 30C221.3 30 229.3 13.3 232 10", fill = false, color = null),
    ))
    val TICK = DoodleSpec(120.0f, 120.0f, 9.0f, listOf(
        DoodlePart("M23.2 64.5C27.9 69.4 38.8 99.9 51.5 93.8C64.2 87.8 91.5 39.1 99.6 28.1", fill = false, color = null),
    ))
    val EXCLAIM = DoodleSpec(60.0f, 120.0f, 9.0f, listOf(
        DoodlePart("M29.6 14C29.9 20.1 31.5 39.5 31.5 50.5C31.5 61.5 29.9 75.2 29.6 80.1", fill = false, color = null),
        DoodlePart("M36.8 104C37 105.6 37.1 108.1 36.2 109.2C35.2 110.2 32.7 110.1 31.1 110.2C29.5 110.4 27.7 110.8 26.4 110.2C25.2 109.5 23.9 107.8 23.5 106.4C23 105 23.3 103.2 23.7 101.7C24.2 100.2 24.9 98.1 26.2 97.4C27.4 96.6 29.8 96.7 31.2 97.1C32.7 97.5 34 98.7 34.9 99.9C35.8 101 36.6 102.4 36.8 104Z", fill = true, color = null),
    ))
    val HEART_OUTLINE = DoodleSpec(120.0f, 120.0f, 7.0f, listOf(
        DoodlePart("M120 196C70 156 36 126 36 88c0-30 22-46 44-46 18 0 32 10 40 27 8-17 22-27 40-27 22 0 44 16 44 46 0 38-34 68-84 108z", fill = false, color = null),
    ))
    val ARROW_DOWN = DoodleSpec(80.0f, 140.0f, 3.5f, listOf(
        DoodlePart("M34 12C36 18.3 45.7 37 46 50C46.3 63 36.7 77.7 36 90C35.3 102.3 41 118.3 42 124", fill = false, color = null),
        DoodlePart("M23.2 103.3C26.4 107.2 35.8 125.9 42 126.4C48.2 126.9 57.3 109.7 60.3 106.3", fill = false, color = null),
    ))
    val STEP_1 = DoodleSpec(120.0f, 120.0f, 3.5f, listOf(
        DoodlePart("M103.5 54.4C105.7 63.8 101.7 77.4 97.5 85.8C93.3 94.2 85.8 101.6 78.4 104.7C71 107.9 61.1 107.6 53 104.6C45 101.6 34.7 94.9 30.2 86.6C25.7 78.4 25.2 65.5 25.8 55.2C26.4 45 28.1 30.7 33.8 25C39.6 19.3 51.9 20.3 60.3 21.1C68.7 21.8 77.2 24 84.4 29.5C91.6 35.1 101.4 45 103.5 54.4Z", fill = true, color = 0xFFF0B594, dx = 0f, dy = 0f),
        DoodlePart("M96.6 52.2C97.8 62.1 95.2 72.5 91.8 81C88.4 89.5 83.1 98.7 75.9 103.1C68.7 107.5 56.1 111.1 48.6 107.4C41.1 103.7 35.6 90.3 30.9 81C26.2 71.7 19.9 60.9 20.4 51.7C20.9 42.6 28 32.3 34.1 26.3C40.2 20.3 48.7 16.4 57.1 15.6C65.5 14.9 77.9 15.5 84.5 21.6C91.1 27.7 95.4 42.3 96.6 52.2Z", fill = false, color = null, dx = 0f, dy = 0f),
        DoodlePart("M5.7 -23.4Q5.3 -23.2 5 -23.1Q4.6 -23.1 4.2 -23.1Q3.6 -23.1 3 -23.6Q2.4 -24.1 2.1 -24.9Q1.9 -25.7 1.9 -26.3Q1.9 -27 2.2 -27.5Q2.5 -27.9 3 -28.2Q5.4 -29.4 7.6 -30.9Q9.9 -32.5 11.9 -34.2Q14 -36 15.5 -37.9Q15.9 -38.4 16.3 -38.6Q16.7 -38.7 17.2 -38.7Q18.1 -38.7 18.8 -38.4Q19.6 -38.1 20.1 -37.6Q20.6 -37.1 20.6 -36.4Q20.6 -36.1 20.4 -35.6Q20.3 -35.2 20.2 -34.7Q19.1 -30.9 18.3 -26.8Q17.5 -22.8 17.1 -18.4Q16.7 -14.1 16.7 -9.4Q16.7 -6.8 16.7 -5Q16.8 -3.3 16.9 -1.8Q16.9 -1.2 16.6 -0.7Q16.3 -0.1 15.7 0.2Q15 0.6 14 0.6Q12.7 0.6 12 -0.1Q11.3 -0.8 11.1 -1.9Q10.9 -3 10.9 -4.2Q10.9 -8.3 11 -11.9Q11.2 -15.6 11.5 -18.9Q11.8 -22.2 12.4 -25.6Q13 -28.9 14 -32.5L15.5 -30.5Q13.2 -28.2 10.9 -26.6Q8.5 -24.9 5.7 -23.4Z", fill = true, color = null, dx = 48.5f, dy = 78f),
    ))
    val STEP_2 = DoodleSpec(120.0f, 120.0f, 3.5f, listOf(
        DoodlePart("M95.9 68.8C94.2 79.1 93.9 92.6 88.1 99.5C82.4 106.5 70 110.7 61.6 110.5C53.1 110.4 43.1 105.3 37.5 98.8C31.9 92.3 29.4 81.3 28 71.6C26.7 61.9 25.6 49.2 29.4 40.5C33.2 31.8 43 22.9 50.9 19.4C58.9 16 69.3 17 77.2 20.1C85.1 23.1 95.3 29.7 98.4 37.8C101.5 45.9 97.6 58.5 95.9 68.8Z", fill = true, color = 0xFFF4D67C, dx = 0f, dy = 0f),
        DoodlePart("M99.1 66.9C97.6 76.5 90.4 88 83.7 94.4C76.9 100.8 66.8 105 58.7 105.1C50.5 105.2 40.7 101.3 34.9 95.2C29 89.2 25.6 78.8 23.7 68.9C21.8 59 19.2 43.6 23.5 35.6C27.7 27.6 40.7 24 49.1 20.9C57.6 17.7 67.1 13.9 74.4 16.5C81.7 19.1 88.8 28.1 93 36.5C97.1 44.9 100.7 57.3 99.1 66.9Z", fill = false, color = null, dx = 0f, dy = 0f),
        DoodlePart("M3.1 -27.7Q3.3 -29.8 4.5 -31.8Q5.6 -33.7 7.5 -35.2Q9.3 -36.8 11.7 -37.6Q14 -38.5 16.6 -38.5Q19.3 -38.5 21.8 -37.6Q24.2 -36.8 26.2 -35.2Q28.1 -33.6 29.2 -31.3Q30.4 -29.1 30.4 -26.2Q30.4 -23.2 29.2 -20.4Q28 -17.7 26 -15.1Q24 -12.6 21.5 -10.3Q19.1 -8.1 16.4 -6.2Q18.5 -6.2 20.4 -6.2Q22.2 -6.1 23.9 -5.9Q25.5 -5.7 27.1 -5.5Q28.6 -5.2 30.1 -5Q31.4 -4.7 32.1 -4Q32.8 -3.2 32.6 -2Q32.5 -0.6 31.5 0.1Q30.5 0.7 29.3 0.5Q26.8 0.1 23.4 -0.5Q20 -1 16.1 -1Q14.9 -1.1 13.6 -1Q12.2 -0.9 11.2 -0.7Q10.2 -0.6 9.6 -0.5Q8.9 0.2 8.2 0.5Q7.5 0.8 6.7 0.8Q5.7 0.8 5 0.1Q4.2 -0.5 4.1 -1.4Q4 -2.2 4.2 -3Q4.5 -3.8 5.4 -4.2Q8.8 -6.4 12.2 -8.9Q15.7 -11.5 18.4 -14.3Q21.2 -17.2 22.9 -20Q24.6 -22.8 24.6 -25.5Q24.6 -27.8 23.6 -29.6Q22.7 -31.4 20.8 -32.4Q19 -33.4 16.5 -33.4Q14.7 -33.4 13 -32.6Q11.4 -31.9 10.1 -30.5Q8.8 -29.1 8.4 -27.2Q8.2 -26.4 7.6 -25.9Q7 -25.4 5.8 -25.4Q4.5 -25.4 3.8 -26Q3.1 -26.6 3.1 -27.7Z", fill = true, color = null, dx = 42.3f, dy = 78f),
    ))
    val STEP_3 = DoodleSpec(120.0f, 120.0f, 3.5f, listOf(
        DoodlePart("M100.1 59.1C100.7 68.6 96.7 78.6 92.5 87.3C88.3 95.9 82.6 107.8 75.2 110.9C67.7 114 55.4 110.8 47.8 106C40.2 101.1 32.9 91 29.8 82C26.7 73 27.7 62 29.2 52.1C30.6 42.3 32.4 28.7 38.4 22.8C44.3 16.9 56.4 15.5 64.8 16.7C73.3 17.9 83.3 23 89.2 30.1C95.1 37.2 99.6 49.6 100.1 59.1Z", fill = true, color = 0xFF9DD99D, dx = 0f, dy = 0f),
        DoodlePart("M96.9 56.1C97.7 66.4 96.8 78.8 92.5 86.8C88.3 94.8 79 101.6 71.2 104C63.4 106.3 52.8 105.1 45.5 100.9C38.2 96.7 31.7 87.8 27.2 78.8C22.7 69.7 16.4 55.5 18.4 46.6C20.3 37.8 31.7 30.8 39 25.7C46.2 20.5 53.7 15.8 61.8 15.7C69.9 15.7 81.7 18.7 87.6 25.4C93.4 32.1 96 45.9 96.9 56.1Z", fill = false, color = null, dx = 0f, dy = 0f),
        DoodlePart("M6.3 -28.7Q5.8 -28.7 5.2 -29Q4.5 -29.2 4.1 -29.9Q3.7 -30.5 3.7 -31.5Q3.7 -32.2 4.2 -33Q4.7 -33.8 5.4 -34.5Q8 -37.1 10.4 -38Q12.9 -38.9 15.3 -38.9Q18.1 -38.9 20.2 -37.8Q22.4 -36.8 23.9 -35.1Q25.4 -33.4 26.1 -31.2Q26.9 -29.2 26.9 -27.1Q26.9 -25 26 -23.1Q25.1 -21.2 23.5 -19.9Q25.9 -18.9 27.4 -17.4Q28.9 -15.9 29.6 -14Q30.2 -12.1 30.2 -10Q30.2 -7.2 28.9 -4.8Q27.5 -2.3 24.6 -0.8Q21.7 0.7 17.2 0.7Q15.1 0.7 12.8 0.2Q10.5 -0.3 8.3 -1.4Q6.2 -2.5 4.4 -4.2Q4 -4.7 3.8 -5.2Q3.6 -5.6 3.6 -6.2Q3.6 -6.8 3.9 -7.5Q4.3 -8.1 4.9 -8.5Q5.6 -9 6.2 -9Q7.7 -9 9.3 -7.1Q9.8 -6.7 11 -6Q12.1 -5.4 13.8 -4.9Q15.4 -4.4 17.2 -4.4Q19.8 -4.4 21.4 -5.3Q22.9 -6.2 23.6 -7.7Q24.2 -9.2 24.2 -10.7Q24.2 -13 22.8 -14.7Q21.4 -16.4 18.9 -16.8Q17.6 -16.2 16.2 -16Q14.8 -15.7 13.4 -15.7Q12.2 -15.7 11.4 -15.8Q10.3 -16 9.7 -16.6Q9 -17.2 9 -18Q9 -19.1 9.8 -19.8Q10.5 -20.5 11.7 -20.9Q13.2 -21.5 15 -21.6Q16.7 -21.8 18.6 -21.6Q20 -22.4 20.6 -23.8Q21.2 -25.2 21.2 -26.8Q21.2 -28 20.9 -29.2Q20.5 -30.5 19.7 -31.5Q18.9 -32.6 17.6 -33.2Q16.4 -33.8 14.9 -33.8Q13 -33.8 11.4 -32.7Q9.8 -31.7 8.5 -30Q8.1 -29.5 7.5 -29.1Q6.9 -28.7 6.3 -28.7Z", fill = true, color = null, dx = 43.5f, dy = 78f),
    ))
}

/** One path of a doodle. [color] null: drawn in the colour passed to [Doodle] (ink or green, theme-aware). */
data class DoodlePart(val d: String, val fill: Boolean, val color: Long? = null, val dx: Float = 0f, val dy: Float = 0f)

data class DoodleSpec(val width: Float, val height: Float, val strokeWidth: Float, val parts: List<DoodlePart>)

private class Prepared(val spec: DoodleSpec) {
    val paths = spec.parts.map { part ->
        androidx.compose.ui.graphics.vector.PathParser().parsePathString(part.d).toPath().apply {
            if (part.dx != 0f || part.dy != 0f) translate(androidx.compose.ui.geometry.Offset(part.dx, part.dy))
        }
    }
    val lengths = paths.mapIndexed { i, p ->
        if (spec.parts[i].fill) 0f else androidx.compose.ui.graphics.PathMeasure().apply { setPath(p, false) }.length
    }
    val total = lengths.sum()
    val hasFills = spec.parts.any { it.fill }
}

/** Draws a doodle at [progress] (0..1): strokes trace along their paths, then fills fade in. */
private fun androidx.compose.ui.graphics.drawscope.DrawScope.drawDoodle(
    prep: Prepared, color: androidx.compose.ui.graphics.Color, progress: Float, flip: Boolean, alpha: Float = 1f,
    erased: Float = 0f,
) {
    val spec = prep.spec
    val s = minOf(size.width / spec.width, size.height / spec.height)
    val dx = (size.width - spec.width * s) / 2f
    val dy = (size.height - spec.height * s) / 2f
    val strokeEnd = if (prep.hasFills) 0.75f else 1f
    val drawnTo = (progress / strokeEnd).coerceIn(0f, 1f) * prep.total
    val erasedTo = erased.coerceIn(0f, 1f) * prep.total
    var at = 0f
    val fillAlpha = if (prep.hasFills) ((progress - 0.6f) / 0.4f).coerceIn(0f, 1f) else 0f
    val m = androidx.compose.ui.graphics.Matrix().apply {
        if (flip) { translate(size.width - dx, dy); scale(-s, s) } else { translate(dx, dy); scale(s, s) }
    }
    val measure = androidx.compose.ui.graphics.PathMeasure()
    val stroke = androidx.compose.ui.graphics.drawscope.Stroke(spec.strokeWidth * s,
        cap = androidx.compose.ui.graphics.StrokeCap.Round, join = androidx.compose.ui.graphics.StrokeJoin.Round)
    // fills first (behind the pen line), so blobs sit under their outlines
    prep.paths.forEachIndexed { i, p ->
        val part = spec.parts[i]
        if (!part.fill || fillAlpha <= 0f) return@forEachIndexed
        val path = androidx.compose.ui.graphics.Path().apply { addPath(p); transform(m) }
        drawPath(path, part.color?.let { androidx.compose.ui.graphics.Color(it) } ?: color, alpha = fillAlpha * alpha * (1f - erased))
    }
    prep.paths.forEachIndexed { i, p ->
        val part = spec.parts[i]
        if (part.fill) return@forEachIndexed
        val len = prep.lengths[i]
        val start = (erasedTo - at).coerceIn(0f, len)
        val end = (drawnTo - at).coerceIn(0f, len)
        at += len
        if (end <= start) return@forEachIndexed
        val seg = androidx.compose.ui.graphics.Path()
        measure.setPath(p, false)
        measure.getSegment(start, end, seg, true)
        seg.transform(m)
        drawPath(seg, part.color?.let { androidx.compose.ui.graphics.Color(it) } ?: color, style = stroke, alpha = alpha)
    }
}

/**
 * Draws a brand doodle the way a pen would, once: strokes trace along their paths, then any fills fade in.
 * Mirrored in right-to-left layouts so the pen moves from right to left.
 * Decoration only: never a control, never the only carrier of meaning.
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
    val prep = androidx.compose.runtime.remember(spec) { Prepared(spec) }
    var done by androidx.compose.runtime.saveable.rememberSaveable(key) { androidx.compose.runtime.mutableStateOf(Prefs.calmMotion) }
    val progress = androidx.compose.runtime.remember(key) { androidx.compose.animation.core.Animatable(if (done) 1f else 0f) }
    androidx.compose.runtime.LaunchedEffect(key) {
        if (!done) {
            kotlinx.coroutines.delay(delayMillis)
            progress.animateTo(1f, androidx.compose.animation.core.tween(durationMillis, easing = KhMotion.EmphasizedDecelerate))
            done = true
        }
    }
    val flip = mirrorInRtl && androidx.compose.ui.platform.LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl
    androidx.compose.foundation.Canvas(modifier) { drawDoodle(prep, color, progress.value, flip) }
}

/**
 * A doodle that keeps drawing itself: the pen traces it, it rests a moment, fades, and starts again.
 * Used for "Khutwa is writing".
 */
@androidx.compose.runtime.Composable
fun DoodleLoop(spec: DoodleSpec, color: androidx.compose.ui.graphics.Color, modifier: androidx.compose.ui.Modifier, periodMillis: Int = 1500) {
    val prep = androidx.compose.runtime.remember(spec) { Prepared(spec) }
    val t by androidx.compose.animation.core.rememberInfiniteTransition(label = "doodle-loop").animateFloat(
        0f, 1f, androidx.compose.animation.core.infiniteRepeatable(
            androidx.compose.animation.core.tween(periodMillis, easing = androidx.compose.animation.core.LinearEasing)),
        label = "t",
    )
    val flip = androidx.compose.ui.platform.LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl
    val calm = Prefs.calmMotion
    androidx.compose.foundation.Canvas(modifier) {
        if (calm) { drawDoodle(prep, color, 1f, flip); return@Canvas }
        val draw = KhMotion.EmphasizedDecelerate.transform((t / 0.6f).coerceIn(0f, 1f))
        val fade = if (t > 0.8f) 1f - (t - 0.8f) / 0.2f else 1f
        drawDoodle(prep, color, draw, flip, alpha = fade)
    }
}

/**
 * A doodle the pen keeps redrawing: it traces it, leaves it a while, then the pen goes back over it and lifts it
 * off stroke by stroke (the way it was drawn), and starts again. Starts after [delayMillis].
 */
@androidx.compose.runtime.Composable
fun DoodleCycle(
    spec: DoodleSpec,
    color: androidx.compose.ui.graphics.Color,
    modifier: androidx.compose.ui.Modifier,
    delayMillis: Long = 0,
    periodMillis: Int = 4200,
    mirrorInRtl: Boolean = true,
) {
    val prep = androidx.compose.runtime.remember(spec) { Prepared(spec) }
    val t = androidx.compose.runtime.remember { androidx.compose.animation.core.Animatable(0f) }
    val calm = Prefs.calmMotion
    androidx.compose.runtime.LaunchedEffect(calm) {
        if (calm) { t.snapTo(0.5f); return@LaunchedEffect }
        kotlinx.coroutines.delay(delayMillis)
        while (true) {
            t.snapTo(0f)
            t.animateTo(1f, androidx.compose.animation.core.tween(periodMillis, easing = androidx.compose.animation.core.LinearEasing))
        }
    }
    val flip = mirrorInRtl && androidx.compose.ui.platform.LocalLayoutDirection.current == androidx.compose.ui.unit.LayoutDirection.Rtl
    androidx.compose.foundation.Canvas(modifier) {
        val v = t.value
        val draw = KhMotion.EmphasizedDecelerate.transform((v / 0.28f).coerceIn(0f, 1f))
        val erase = KhMotion.EmphasizedDecelerate.transform(((v - 0.68f) / 0.24f).coerceIn(0f, 1f))
        drawDoodle(prep, color, draw, flip, erased = erase)
    }
}
