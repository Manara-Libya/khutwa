package ly.manara.khutwa.data

/**
 * The same unmistakable phrases as backend/runtime/risk_keywords.txt, checked on the phone before
 * anything is sent. A hit opens the urgent screen at once, even offline. Everyday idioms are never
 * in this list («نموت من الضحك» must not match).
 */
object RiskKeywords {
    private val PHRASES = listOf(
        "انتحار", "ننتحر", "نقتل روحي", "نقتل في روحي", "نأذي روحي", "ناذي روحي", "نجرح روحي", "نجرح في روحي",
        "نشنق روحي", "إنهاء حياتي", "انهاء حياتي", "نخلص من حياتي", "ما عادش نبي نعيش", "ما عاد نبي نعيش",
        "nentaher", "ntaher", "n9atel rou7i", "n9tel rou7i", "n9atel rou7", "ma 3adech nbi n3ich", "ma3adech nbi n3ich",
        "kill myself", "suicide",
    )

    fun matches(text: String): Boolean {
        val low = text.lowercase()
        return PHRASES.any { it in low }
    }
}
