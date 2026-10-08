package ly.manara.khutwa.privacy   // plain Kotlin, no Android imports, so JUnit can test it

/**
 * On-device redaction for Libyan Arabic, Arabizi and English (#58). Built from Anas's first version.
 *
 * Finds, in this priority order when matches overlap:
 * 1. emails, then Libyan phone numbers (+218 / 00218 / 09x, spaces or dashes, Arabic or Western digits),
 *    then any other run of 6+ digits;
 * 2. names and places from [LibyanLexicon], with attached prefixes (و ف ب ل ك: «بسبها», «وأحمد»);
 * 3. the word after a kinship word or title («خوي سند», "khoya sanad", «الدكتور ...»), and the word after
 *    «جامعة», «مستشفى»... as a place; social handles (@name).
 *
 * Matching runs on a normalised copy of the text with the same length (alef/hamza forms, final ة/ه and ى/ي
 * unified, Arabic-Indic digits to 0-9, Latin lowercased), so span indices always point into the original.
 * Anything missed can still be hidden with a tap ([toggle]).
 */
class LibyanRedactor : Redactor {

    override fun redact(text: String): RedactionResult {
        val norm = normalize(text)
        val found = mutableListOf<Candidate>()

        fun addAll(regex: Regex, type: IdentifierType, priority: Int, group: Int = 0) {
            for (m in regex.findAll(norm)) {
                val g = m.groups[group] ?: continue
                found += Candidate(g.range.first, g.range.last + 1, type, priority)
            }
        }
        addAll(EMAIL, IdentifierType.EMAIL, 0)
        PHONES.forEach { addAll(it, IdentifierType.PHONE, 1) }
        addAll(LONG_NUMBER, IdentifierType.NUMBER, 2)
        addAll(ARABIC_NAMES, IdentifierType.NAME, 3, group = 1)
        addAll(LATIN_NAMES, IdentifierType.NAME, 3, group = 1)
        addAll(ARABIC_PLACES, IdentifierType.PLACE, 3, group = 1)
        addAll(LATIN_PLACES, IdentifierType.PLACE, 3, group = 1)
        addAll(HANDLE, IdentifierType.NAME, 0)
        for ((regex, type) in listOf(KIN to IdentifierType.NAME, PLACE_MARKERS to IdentifierType.PLACE)) {
            for (m in regex.findAll(norm)) {
                val word = m.groups[2] ?: continue
                if (looksLikeName(word.value)) found += Candidate(word.range.first, word.range.last + 1, type, 4)
            }
        }

        // Keep the strongest match where matches overlap, then sort by position.
        val kept = mutableListOf<Candidate>()
        for (c in found.sortedWith(compareBy({ it.priority }, { -(it.end - it.start) }))) {
            if (kept.none { it.start < c.end && c.start < it.end }) kept += c
        }
        return RedactionResult(text, kept.sortedBy { it.start }.map { Span(it.start, it.end, it.type) })
    }

    override fun toggle(result: RedactionResult, start: Int, end: Int): RedactionResult {
        if (start < 0 || end > result.original.length || start >= end) return result
        val overlapping = result.spans.filter { it.start < end && start < it.end }
        val spans = if (overlapping.isNotEmpty()) {
            result.spans - overlapping.toSet()
        } else {
            (result.spans + Span(start, end, IdentifierType.HIDDEN)).sortedBy { it.start }
        }
        return result.copy(spans = spans)
    }

    private data class Candidate(val start: Int, val end: Int, val type: IdentifierType, val priority: Int)

    private companion object {
        const val LETTER = "\\p{L}\\p{N}\\p{M}"
        const val BEFORE = "(?<![$LETTER])"
        const val AFTER = "(?![$LETTER])"
        const val SEP = "[\\s.\\-]?"

        val STOPWORDS = LibyanLexicon.stopwords.map(::normalize).toSet()
        val KIN_WORDS = (LibyanLexicon.arabicKin + LibyanLexicon.latinKin).map(::normalize).toSet()

        val EMAIL = Regex("[a-z0-9._%+\\-]+@[a-z0-9.\\-]+\\.[a-z]{2,}")
        val PHONES = listOf(
            Regex("(?:\\+|00)\\s?218$SEP\\(?0?\\)?$SEP(?:9[1-6]|2[1-9]|[3-8]\\d)$SEP\\d{3}$SEP\\d{3,4}(?!\\d)"),
            Regex("(?<![\\d+])0?9[1-6]$SEP\\d{3}$SEP\\d{4}(?!\\d)"),
            Regex("(?<![\\d+])0[2-8]\\d$SEP\\d{3}$SEP\\d{3,4}(?!\\d)"),
            Regex("(?<![$LETTER])09[1-6][\\dx]{7}(?![$LETTER])"),   // masked, as in Appendix A: 091xxxxxxx
        )
        val LONG_NUMBER = Regex("(?<!\\d)\\d{6,}(?!\\d)")
        val HANDLE = Regex("(?<![\\w@])@[a-z0-9_.]{3,}")

        val ARABIC_NAMES = Regex(
            "$BEFORE(?![بلك]عمر$AFTER)(?:[وفبلك]{1,2})?(" +   // «بعمر 20 سنة» is "at age 20", not Omar
                alternation(LibyanLexicon.arabicNames) + "|عبد\\s?(?:ال)?(?:" +
                alternation(LibyanLexicon.arabicAbdSuffixes) + "))$AFTER",
        )
        val LATIN_NAMES = Regex(
            "$BEFORE(" + alternation(LibyanLexicon.latinNames) + "|abd[\\s\\-]?(?:[aeu]l?[\\s\\-]?)?(?:" +
                alternation(LibyanLexicon.latinAbdSuffixes) + "))$AFTER",
        )
        val ARABIC_PLACES = Regex("$BEFORE(?:[وفبلك]{1,2})?(" + alternation(LibyanLexicon.arabicPlaces) + ")$AFTER")
        val LATIN_PLACES = Regex("$BEFORE(" + alternation(LibyanLexicon.latinPlaces) + ")$AFTER")
        val KIN = Regex(
            "$BEFORE(?:[وف]|w)?(" + alternation(LibyanLexicon.arabicKin + LibyanLexicon.latinKin) +
                ")\\s+([$LETTER]+)",
        )
        val PLACE_MARKERS = Regex(
            "$BEFORE(?:[وفبل])?(" + alternation(LibyanLexicon.arabicPlaceMarkers + LibyanLexicon.latinPlaceMarkers) +
                ")\\s+([$LETTER]+)",
        )

        /** Same length as the input, so indices match the original text. */
        fun normalize(text: String): String = buildString(text.length) {
            for (c in text) append(
                when (c) {
                    'أ', 'إ', 'آ', 'ٱ' -> 'ا'
                    'ة' -> 'ه'
                    'ى' -> 'ي'
                    in '٠'..'٩' -> '0' + (c - '٠')
                    in '۰'..'۹' -> '0' + (c - '۰')
                    else -> c.lowercaseChar()
                },
            )
        }

        /** Longest first, so «عبدالله» wins over a shorter entry; spaces inside entries allow a space or dash. */
        fun alternation(words: List<String>): String = words.map(::normalize).distinct()
            .sortedByDescending { it.length }
            .joinToString("|") { w -> w.split(' ').joinToString("[\\s\\-]+") }

        /** The word after a kinship word is a name unless it's a common word or looks like a verb. */
        fun looksLikeName(word: String): Boolean {
            val bare = if (word.startsWith("و") || word.startsWith("w")) word.drop(1) else word
            if (word in STOPWORDS || bare in STOPWORDS || word in KIN_WORDS || bare in KIN_WORDS) return false
            if (word.all { it.isDigit() }) return false
            val first = word.first()
            if (first in "يتن" || word.startsWith("بي") || word.startsWith("بن")) return false   // يزعق، بيجي
            if (word.startsWith("ما") && word.endsWith("ش")) return false   // ماقالش
            if (first in "ytn" && word.length > 1 && word[1] !in "aeiou") return false   // Arabizi verbs: y3ayto, nbi
            return word.length >= 2
        }
    }
}
