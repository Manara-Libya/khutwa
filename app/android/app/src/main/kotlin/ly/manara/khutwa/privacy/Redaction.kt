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
    /** The ONLY text that may leave the phone. */
    val redacted: String get() = buildString {
        var i = 0
        for (s in spans) { append(original, i, s.start); append(s.replacement); i = s.end }
        append(original, i, original.length)
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
