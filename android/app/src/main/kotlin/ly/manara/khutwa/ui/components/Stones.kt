package ly.manara.khutwa.ui.components

import androidx.compose.foundation.Image
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import ly.manara.khutwa.R
import ly.manara.khutwa.ui.theme.Kh

/**
 * Khutwa stones: the brand's reassuring emoji. Khutwa may end a reply with one shortcode (:kh-listening:); the phone
 * shows it as a small sticker under the reply. These are for moments of warmth, not decoration, so the phone enforces
 * what the prompt asks: one at the very end at most, never two replies in a row, only known codes. kh-safe is left
 * out: «this stays private» would claim more than we can (the redacted text does reach the AI).
 */
object Stones {
    class Stone(val light: Int, val dark: Int, val alt: String)

    val ALL: Map<String, Stone> = mapOf(
        "kh-hug" to Stone(R.drawable.kh_stone_hug, R.drawable.kh_stone_hug_dark, "حضن"),
        "kh-here" to Stone(R.drawable.kh_stone_here, R.drawable.kh_stone_here_dark, "أنا هنا"),
        "kh-listening" to Stone(R.drawable.kh_stone_listening, R.drawable.kh_stone_listening_dark, "نسمع فيك"),
        "kh-heavy" to Stone(R.drawable.kh_stone_heavy, R.drawable.kh_stone_heavy_dark, "حمل ثقيل"),
        "kh-umbrella" to Stone(R.drawable.kh_stone_umbrella, R.drawable.kh_stone_umbrella_dark, "مش بروحك"),
        "kh-tears" to Stone(R.drawable.kh_stone_tears, R.drawable.kh_stone_tears_dark, "عادي تبكي"),
        "kh-breathe" to Stone(R.drawable.kh_stone_breathe, R.drawable.kh_stone_breathe_dark, "خوذ نفس"),
        "kh-tea" to Stone(R.drawable.kh_stone_tea, R.drawable.kh_stone_tea_dark, "خوذ وقتك"),
        "kh-heart" to Stone(R.drawable.kh_stone_heart, R.drawable.kh_stone_heart_dark, "هذا مهم"),
        "kh-thank-you" to Stone(R.drawable.kh_stone_thank_you, R.drawable.kh_stone_thank_you_dark, "شكراً إنك حكيتلي"),
        "kh-hope" to Stone(R.drawable.kh_stone_hope, R.drawable.kh_stone_hope_dark, "فيه طريق"),
        "kh-step" to Stone(R.drawable.kh_stone_step, R.drawable.kh_stone_step_dark, "خطوة وحدة"),
        "kh-well-done" to Stone(R.drawable.kh_stone_well_done, R.drawable.kh_stone_well_done_dark, "هذي شجاعة"),
        "kh-rest" to Stone(R.drawable.kh_stone_rest, R.drawable.kh_stone_rest_dark, "ارتاح توا"),
        "kh-sprout" to Stone(R.drawable.kh_stone_sprout, R.drawable.kh_stone_sprout_dark, "تقدّم صغير"),
    )

    private val ANY_CODE = Regex(""":kh-[a-z-]+:""")
    private val TRAILING = Regex("""\s*:(kh-[a-z-]+):\s*$""")

    /** The reply without any shortcode, and the stone it ends with, if it is a known one. */
    fun split(text: String): Pair<String, Stone?> {
        val code = TRAILING.find(text)?.groupValues?.get(1)
        val body = ANY_CODE.replace(text, "").replace(Regex("""[ \t]{2,}"""), " ").trim()
        return body to code?.let(ALL::get)
    }

    fun hasStone(text: String): Boolean = split(text).second != null

    /** The same reply with every shortcode removed (used when the previous reply already had a stone). */
    fun strip(text: String): String = split(text).first
}

@Composable
fun StoneEmoji(stone: Stones.Stone, modifier: Modifier = Modifier) {
    Image(painterResource(if (Kh.colors.isDark) stone.dark else stone.light), contentDescription = null,
        modifier = modifier.semantics { contentDescription = stone.alt })
}
