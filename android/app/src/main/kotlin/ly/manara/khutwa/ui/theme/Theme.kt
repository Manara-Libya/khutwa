package ly.manara.khutwa.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import ly.manara.khutwa.R

/** Colours from the Khutwa design system (tokens/tokens.json), one set per theme. */
@Immutable
data class KhutwaColors(
    val paper: Color,
    val paperRaised: Color,
    val paperSunk: Color,
    val ink: Color,
    val inkMuted: Color,
    val line: Color,
    val border: Color,
    val green: Color,
    val onGreen: Color,
    val greenSoft: Color,
    val greenDeep: Color,
    val clay: Color,
    val claySoft: Color,
    val sun: Color,
    val sunSoft: Color,
    val urgent: Color,
    val onUrgent: Color,
    val shadow: Color,
    val isDark: Boolean,
)

val LightColors = KhutwaColors(
    paper = Color(0xFFF4F1EA), paperRaised = Color(0xFFFCFAF5), paperSunk = Color(0xFFEAE6DB),
    ink = Color(0xFF1F2A1D), inkMuted = Color(0xFF56624F), line = Color(0xFFDAD5C8), border = Color(0xFF757E6B),
    green = Color(0xFF9DD99D), onGreen = Color(0xFF1F2A1D), greenSoft = Color(0xFFDDF0D9), greenDeep = Color(0xFF2A6A37),
    clay = Color(0xFFF0B594), claySoft = Color(0xFFFAE6D8), sun = Color(0xFFF4D67C), sunSoft = Color(0xFFFBF0CC),
    urgent = Color(0xFFB4432B), onUrgent = Color(0xFFFFFFFF), shadow = Color(0xFF1F2A1D), isDark = false,
)

val DarkColors = KhutwaColors(
    paper = Color(0xFF151B14), paperRaised = Color(0xFF1E261C), paperSunk = Color(0xFF0F140E),
    ink = Color(0xFFEEF1E6), inkMuted = Color(0xFFA9B3A2), line = Color(0xFF2E382B), border = Color(0xFF7C8672),
    green = Color(0xFF9DD99D), onGreen = Color(0xFF1F2A1D), greenSoft = Color(0xFF263A26), greenDeep = Color(0xFF9DD99D),
    clay = Color(0xFFE9A882), claySoft = Color(0xFF3A2A20), sun = Color(0xFFEBCB6B), sunSoft = Color(0xFF3A3319),
    urgent = Color(0xFFF29A7E), onUrgent = Color(0xFF1F1410), shadow = Color(0xFF0A0D09), isDark = true,
)

val Display = FontFamily(
    Font(R.font.baloobhaijaan2_semibold, FontWeight.SemiBold),
    Font(R.font.baloobhaijaan2_bold, FontWeight.Bold),
)
val Body = FontFamily(
    Font(R.font.ibmplexsansarabic_regular, FontWeight.Normal),
    Font(R.font.ibmplexsansarabic_medium, FontWeight.Medium),
    Font(R.font.ibmplexsansarabic_semibold, FontWeight.SemiBold),
)

/** The type scale used across the app (display = Baloo Bhaijaan 2, text = IBM Plex Sans Arabic). */
object KhType {
    val title = TextStyle(fontFamily = Display, fontWeight = FontWeight.Bold, fontSize = 28.sp, lineHeight = 38.sp)
    val heading = TextStyle(fontFamily = Display, fontWeight = FontWeight.SemiBold, fontSize = 21.sp, lineHeight = 30.sp)
    val button = TextStyle(fontFamily = Display, fontWeight = FontWeight.SemiBold, fontSize = 17.sp, lineHeight = 24.sp)
    val bubble = TextStyle(fontFamily = Body, fontWeight = FontWeight.Normal, fontSize = 17.sp, lineHeight = 29.sp)
    val body = TextStyle(fontFamily = Body, fontWeight = FontWeight.Normal, fontSize = 16.sp, lineHeight = 26.sp)
    val bodyStrong = TextStyle(fontFamily = Body, fontWeight = FontWeight.Medium, fontSize = 16.sp, lineHeight = 26.sp)
    val small = TextStyle(fontFamily = Body, fontWeight = FontWeight.Normal, fontSize = 13.sp, lineHeight = 19.sp)
    val label = TextStyle(fontFamily = Body, fontWeight = FontWeight.Medium, fontSize = 14.sp, lineHeight = 20.sp)
}

/** Hand-drawn shapes: the corners are deliberately uneven, as in the brand stylesheet. */
object KhShapes {
    val pill = RoundedCornerShape(topStart = 28.dp, topEnd = 24.dp, bottomEnd = 30.dp, bottomStart = 22.dp)
    val card = RoundedCornerShape(topStart = 26.dp, topEnd = 22.dp, bottomEnd = 28.dp, bottomStart = 24.dp)
    val field = RoundedCornerShape(topStart = 16.dp, topEnd = 18.dp, bottomEnd = 16.dp, bottomStart = 14.dp)
    val bubbleBot = RoundedCornerShape(topStart = 22.dp, topEnd = 24.dp, bottomEnd = 24.dp, bottomStart = 8.dp)
    val bubbleMe = RoundedCornerShape(topStart = 24.dp, topEnd = 22.dp, bottomEnd = 8.dp, bottomStart = 24.dp)
    val panel = RoundedCornerShape(32.dp)
    val chip = RoundedCornerShape(999.dp)
}

val LocalKhutwaColors = staticCompositionLocalOf { LightColors }

object Kh {
    val colors: KhutwaColors
        @Composable get() = LocalKhutwaColors.current
}

@Composable
fun KhutwaTheme(dark: Boolean = isSystemInDarkTheme(), content: @Composable () -> Unit) {
    val c = if (dark) DarkColors else LightColors
    val material = if (dark) {
        darkColorScheme(primary = c.green, onPrimary = c.onGreen, background = c.paper, surface = c.paperRaised,
            onBackground = c.ink, onSurface = c.ink, error = c.urgent)
    } else {
        lightColorScheme(primary = c.greenDeep, onPrimary = Color.White, background = c.paper, surface = c.paperRaised,
            onBackground = c.ink, onSurface = c.ink, error = c.urgent)
    }
    CompositionLocalProvider(LocalKhutwaColors provides c) {
        MaterialTheme(colorScheme = material, content = content)
    }
}
