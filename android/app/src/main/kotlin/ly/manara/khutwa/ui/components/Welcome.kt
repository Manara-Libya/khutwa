package ly.manara.khutwa.ui.components

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.ui.unit.dp
import androidx.compose.ui.Alignment
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.absoluteOffset
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.PathMeasure
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.graphics.drawscope.scale
import androidx.compose.ui.graphics.drawscope.translate
import androidx.compose.ui.graphics.vector.PathParser
import kotlinx.coroutines.launch
import ly.manara.khutwa.ui.theme.Kh

/**
 * The "listen" illustration (illustrations/listen.svg), drawn from its layers so it can move and follow the theme.
 * Entrance (once): the big bubble grows in while its outline draws, the small green bubble pops in, the dots land.
 * Then it stays hand-drawn: the pen lines "boil" (redrawn a little differently a few times a second, like
 * frame-by-frame doodle animation), the brand sparkles are drawn, left, and lifted off again, the dots "type".
 */
@Composable
fun WelcomeIllustration(modifier: Modifier = Modifier) {
    val c = Kh.colors
    val p = remember { LAYERS.map { PathParser().parsePathString(it).toPath() } }
    val outlineLen = remember { PathMeasure().apply { setPath(p[1], false) }.length }
    val smallLen = remember { PathMeasure().apply { setPath(p[3], false) }.length }
    val calm = ly.manara.khutwa.ui.components.Prefs.calmMotion
    var played by rememberSaveable { mutableStateOf(calm) }
    val big = remember { Animatable(if (played) 1f else 0f) }
    val draw = remember { Animatable(if (played) 1f else 0f) }
    val small = remember { Animatable(if (played) 1f else 0f) }
    val dots = remember { Animatable(if (played) 1f else 0f) }
    LaunchedEffect(Unit) {
        if (played) return@LaunchedEffect
        kotlinx.coroutines.delay(320)  // let the screen finish sliding in first
        launch { big.animateTo(1f, spring(dampingRatio = 0.7f, stiffness = 260f)) }
        launch { draw.animateTo(1f, tween(1100, easing = KhMotion.EmphasizedDecelerate)) }
        launch { kotlinx.coroutines.delay(380); small.animateTo(1f, spring(dampingRatio = 0.45f, stiffness = 320f)) }
        launch { kotlinx.coroutines.delay(820); dots.animateTo(1f, tween(420, easing = KhMotion.EmphasizedDecelerate)) }
        kotlinx.coroutines.delay(1900); played = true
    }
    val t by rememberInfiniteTransition(label = "welcome").animateFloat(0f, 1f,
        infiniteRepeatable(tween(2400, easing = LinearEasing)), label = "t")
    // three hand-redrawn versions of each outline, cycled at about 7 frames a second
    val boiled = remember { listOf(1, 3).associateWith { i -> (0..2).map { boil(p[i], it) } } }
    val frame by rememberInfiniteTransition(label = "boil").animateFloat(0f, 3f,
        infiniteRepeatable(tween(420, easing = LinearEasing)), label = "frame")
    // calm motion: the drawing stays still (no boil, no typing dots, no bob)
    val tt = if (calm) 0f else t
    val ff = if (calm) 0f else frame
    val stroke = Stroke(width = 3.6f, cap = StrokeCap.Round, join = StrokeJoin.Round)
    Box(modifier) {
    Canvas(Modifier.matchParentSize()) {
        val s = minOf(size.width, size.height) / 240f
        translate((size.width - 240f * s) / 2f, (size.height - 240f * s) / 2f) {
            scale(s, s, pivot = Offset.Zero) {
                // big bubble: grows from its tail, outline traces itself
                scale(0.35f + 0.65f * big.value, pivot = Offset(60f, 150f)) {
                    drawPath(p[0], c.greenSoft, alpha = big.value.coerceIn(0f, 1f))
                    val f = ff.toInt().coerceAtMost(2)
                    if (draw.value >= 1f) drawPath(boiled.getValue(1)[f], c.ink, style = stroke)
                    else {
                        val seg = Path(); PathMeasure().apply { setPath(p[1], false); getSegment(0f, outlineLen * draw.value, seg, true) }
                        drawPath(seg, c.ink, style = stroke)
                    }
                    // dots: land, then type in a soft wave
                    for (i in 0..2) {
                        val land = ((dots.value - i * 0.18f) / 0.64f).coerceIn(0f, 1f)
                        val wave = ((tt * 3f - i * 0.45f) % 3f + 3f) % 3f
                        val lift = if (!calm && dots.value >= 1f && wave < 1f) kotlin.math.sin(wave * Math.PI).toFloat() * 5f else 0f
                        translate(0f, (1f - land) * 10f - lift) { drawPath(p[4 + i], c.ink, alpha = land) }
                    }
                }
                // small bubble: pops in with a bounce, then bobs
                val bob = kotlin.math.sin(tt * 2f * Math.PI).toFloat()
                translate(0f, bob * 2.6f * small.value) {
                    rotate(bob * 1.6f, pivot = Offset(180f, 160f)) {
                        scale(small.value, pivot = Offset(180f, 160f)) {
                            drawPath(p[2], c.green)
                            if (small.value >= 1f && small.isRunning.not()) drawPath(boiled.getValue(3)[(ff.toInt() + 1) % 3], c.ink, style = stroke)
                            else {
                                val seg2 = Path(); PathMeasure().apply { setPath(p[3], false); getSegment(0f, smallLen * small.value.coerceIn(0f, 1f), seg2, true) }
                                drawPath(seg2, c.ink, style = stroke)
                            }
                        }
                    }
                }
            }
        }
    }
    // the brand sparkles: drawn by the pen once the bubbles have landed, left a while, lifted off, drawn again
    DoodleCycle(Doodles.SPARKLES, c.ink, Modifier.align(androidx.compose.ui.AbsoluteAlignment.TopRight).absoluteOffset(x = 18.dp, y = (-2).dp).size(44.dp),
        delayMillis = if (played) 0 else 1700, periodMillis = 4600, mirrorInRtl = false)
    }
}

/** The same line redrawn by hand: resampled along its length and nudged sideways by a smooth wobble per [seed]. */
private fun boil(path: Path, seed: Int): Path {
    val m = PathMeasure().apply { setPath(path, false) }
    val len = m.length
    val out = Path()
    var d = 0f
    while (d <= len) {
        val pos = m.getPosition(d); val tan = m.getTangent(d)
        val w = 1.5f * (kotlin.math.sin(d * 0.07f + seed * 2.1f) * 0.6f + kotlin.math.sin(d * 0.19f + seed * 4.7f) * 0.4f)
        val x = pos.x - tan.y * w; val y = pos.y + tan.x * w
        if (d == 0f) out.moveTo(x, y) else out.lineTo(x, y)
        d += 2.5f
    }
    return out
}

private val LAYERS = listOf(
    "M34 74C36.7 62.3 40.3 50.7 52 44C63.7 37.3 87 33.7 104 34C121 34.3 143 38.3 154 46C165 53.7 168.3 68.3 170 80C171.7 91.7 169 106 164 116C159 126 151.7 135 140 140C128.3 145 104.7 145 94 146C83.3 147 84.3 141 76 146C67.7 151 48 176.7 44 176C40 175.3 53.3 152.3 52 142C50.7 131.7 39 125.3 36 114C33 102.7 31.3 85.7 34 74Z",
    "M29.1 70.8C31.7 59.1 36.8 46.2 48.6 39.4C60.4 32.6 83 29.3 100 29.9C116.9 30.4 139.5 35.2 150.4 42.7C161.2 50.2 163.3 63.3 165 74.9C166.8 86.4 165.5 101.8 160.8 111.8C156.1 121.8 148.5 129.7 136.6 134.8C124.8 139.9 100.7 141.2 89.9 142.5C79 143.9 79.5 138.3 71.3 143.1C63.2 147.8 45 171.7 41 170.9C36.9 170 48.2 148.3 46.9 138.1C45.5 127.9 36 120.9 33.1 109.7C30.1 98.5 26.5 82.6 29.1 70.8Z",
    "M220 124.8C218.3 117.6 216.1 110.3 208.8 106.2C201.6 102.1 187.1 99.8 176.6 100C166.1 100.2 152.4 102.7 145.6 107.4C138.8 112.2 136.7 121.3 135.7 128.5C134.6 135.8 136.3 144.6 139.4 150.8C142.5 157 147 162.6 154.3 165.7C161.5 168.8 176.2 168.8 182.8 169.4C189.4 170.1 188.8 166.3 194 169.4C199.1 172.5 211.3 188.5 213.8 188C216.3 187.6 208 173.4 208.8 167C209.7 160.6 216.9 156.6 218.8 149.6C220.6 142.6 221.7 132 220 124.8Z",
    "M217.1 121.9C215.3 114.5 211.1 105.4 203.8 101.2C196.5 97 183.7 96.3 173.4 96.6C163.1 96.9 148.9 98.3 142 103C135.1 107.7 133 117.6 131.9 124.8C130.9 131.9 132.6 139.9 135.6 146C138.6 152.1 142.8 158 150.1 161.5C157.4 164.9 172.5 165.9 179.3 166.6C186.2 167.3 186 162.7 191 165.5C196.1 168.4 207.6 184.1 209.7 183.5C211.8 182.9 202.9 168.2 203.7 161.8C204.6 155.4 212.4 151.8 214.7 145.2C216.9 138.5 218.9 129.2 217.1 121.9Z",
    "M82 86C81.9 87.2 80.8 88.4 80 89.3C79.1 90.3 78.1 91.3 77 91.5C75.9 91.7 74.4 91.1 73.4 90.5C72.4 89.9 71.5 89 71 87.8C70.4 86.7 69.5 84.8 69.9 83.8C70.4 82.8 72.4 82.2 73.5 81.7C74.7 81.2 75.7 80.9 76.9 81C78 81.1 79.5 81.5 80.4 82.3C81.2 83.1 82 84.8 82 86Z",
    "M104.1 86C104.2 87.1 103.1 88.8 102.3 89.6C101.4 90.4 100 90.7 98.9 90.9C97.7 91.1 96.2 91.4 95.2 90.9C94.2 90.4 93.2 89 92.8 87.9C92.3 86.8 92.1 85.1 92.6 84C93 83 94.3 82.1 95.4 81.5C96.5 80.9 97.9 80.2 99 80.4C100.1 80.6 101 81.9 101.8 82.8C102.7 83.7 104.1 84.9 104.1 86Z",
    "M124.2 86C124 87.3 124.9 88.7 124.4 89.7C123.8 90.6 122.2 91.4 121 91.6C119.8 91.8 118.2 91.5 117.2 90.9C116.1 90.3 114.9 89.1 114.6 88C114.3 86.9 114.8 85.4 115.3 84.3C115.8 83.2 116.4 82.1 117.4 81.4C118.3 80.8 119.7 80.3 121 80.4C122.3 80.4 124.5 80.8 125 81.8C125.6 82.7 124.3 84.7 124.2 86Z",
)
