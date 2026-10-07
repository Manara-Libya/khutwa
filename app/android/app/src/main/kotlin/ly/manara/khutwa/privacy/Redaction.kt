package ly.manara.khutwa.privacy   // plain Kotlin, no Android imports, so JUnit can test it

// Interface agreed in #53:
// https://github.com/Manara-Libya/khutwa/issues/53#issuecomment-6036338554
// Do not change it here without updating that comment and the Dart mirror in
// lib/features/privacy/domain/.

enum class IdentifierType(val placeholder: String) {
    NAME("[اسم]"),      // person names and nicknames, Arabic or Arabizi
    PLACE("[مكان]"),    // cities, towns, universities, workplaces
    PHONE("[رقم]"),     // Libyan phone numbers (+218 / 09x), any digits incl. ٠-٩
    EMAIL("[بريد]"),
    NUMBER("[رقم]"),    // other runs of 6+ digits (IDs, student numbers)
    HIDDEN("[مخفي]"),   // a word the user tapped in the privacy panel
}

data class Span(
    val start: Int,              // inclusive index into RedactionResult.original
    val end: Int,                // exclusive
    val type: IdentifierType,
) {
    val replacement: String get() = type.placeholder
}

data class RedactionResult(
    val original: String,        // what the user typed: stays on the phone, never sent
    val spans: List<Span>,       // sorted by start, non-overlapping
) {
    /**
     * The placeholder sent for each span. Names and places are numbered by first appearance
     * («[اسم1]», «[مكان2]») and the same word always gets the same number, so the AI can refer to a
     * person and [restore] can put the real name back. Other types keep their plain placeholder.
     */
    val placeholders: List<String> get() {
        val numbers = mutableMapOf<String, Int>()
        val counts = mutableMapOf<IdentifierType, Int>()
        return spans.map { s ->
            if (s.type != IdentifierType.NAME && s.type != IdentifierType.PLACE) return@map s.replacement
            val key = s.type.name + original.substring(s.start, s.end).trim().lowercase()
            val n = numbers.getOrPut(key) { (counts[s.type] ?: 0).plus(1).also { counts[s.type] = it } }
            s.replacement.dropLast(1) + n + "]"
        }
    }

    /** The ONLY text that may leave the phone. */
    val redacted: String get() = buildString {
        var i = 0
        for ((s, placeholder) in spans.zip(placeholders)) { append(original, i, s.start); append(placeholder); i = s.end }
        append(original, i, original.length)
    }

    /**
     * Puts the real names and places back into text the AI wrote (reflection, draft message).
     * Runs on the phone only; the result is never sent. Numbers, emails and hidden words are never put back.
     * A bare «[اسم]» or «[مكان]» is restored only when the message has exactly one name or place.
     */
    fun restore(aiText: String): String {
        val words = mutableMapOf<String, String>()
        for ((s, placeholder) in spans.zip(placeholders)) {
            if (s.type == IdentifierType.NAME || s.type == IdentifierType.PLACE) {
                words.getOrPut(placeholder) { original.substring(s.start, s.end) }
            }
        }
        return RESTORABLE.replace(aiText) { m ->
            val digits = m.groupValues[2].map { if (it in '٠'..'٩') '0' + (it - '٠') else it }.joinToString("")
            val base = "[" + m.groupValues[1]
            val key = if (digits.isEmpty()) words.keys.singleOrNull { it.startsWith(base) } else "$base$digits]"
            key?.let(words::get) ?: m.value
        }
    }

    private companion object {
        val RESTORABLE = Regex("""\[(اسم|مكان)\s*([0-9٠-٩]*)\]""")
    }
}

interface Redactor {
    /** Automatic pass: patterns + Libyan name/place lists + kin phrases. Must run in < 50 ms for 2,000 chars. */
    fun redact(text: String): RedactionResult

    /** Tap-to-hide in the privacy panel: tapping a visible word adds a HIDDEN span;
     *  tapping a removed part removes its span (restores the original text). */
    fun toggle(result: RedactionResult, start: Int, end: Int): RedactionResult
}

/** One-tap "delete everything": plan, drafts, any cached text and preferences. */
interface LocalDataWiper {
    suspend fun deleteEverything()
}
