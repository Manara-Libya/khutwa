package ly.manara.khutwa.privacy

/**
 * Redaction across a whole conversation. The redactor numbers names per message, so «أحمد» in the first
 * message and «سند» in the second would both become [اسم1]. Here each name or place keeps one number for
 * the whole chat, so the history the server sees stays consistent and the drafts get the right name back.
 *
 * The mapping lives only in memory on the phone and is dropped with the conversation.
 */
class ConversationPrivacy(private val redactor: Redactor = LibyanRedactor()) {
    private val numbers = mutableMapOf<String, String>()   // type + word -> placeholder
    private val words = mutableMapOf<String, String>()     // placeholder -> the word as the user wrote it
    private val counts = mutableMapOf<IdentifierType, Int>()

    /** The only text that may leave the phone for this message. */
    fun redact(text: String): String {
        val result = redactor.redact(text)
        return buildString {
            var i = 0
            for (s in result.spans) {
                append(text, i, s.start)
                append(placeholderFor(s, text.substring(s.start, s.end)))
                i = s.end
            }
            append(text, i, text.length)
        }
    }

    private fun placeholderFor(span: Span, word: String): String {
        if (span.type != IdentifierType.NAME && span.type != IdentifierType.PLACE) return span.replacement
        val key = span.type.name + word.trim().lowercase()
        return numbers.getOrPut(key) {
            val n = (counts[span.type] ?: 0) + 1
            counts[span.type] = n
            span.replacement.dropLast(1) + n + "]"
        }.also { words.getOrPut(it) { word } }
    }

    /** Puts real names back into what the AI wrote. On the phone only; never sent. */
    fun restore(aiText: String): String = RESTORABLE.replace(aiText) { m ->
        val digits = m.groupValues[2].map { if (it in '٠'..'٩') '0' + (it - '٠') else it }.joinToString("")
        val base = "[" + m.groupValues[1]
        val key = if (digits.isEmpty()) words.keys.singleOrNull { it.startsWith(base) } else "$base$digits]"
        key?.let(words::get) ?: m.value
    }

    fun clear() {
        numbers.clear(); words.clear(); counts.clear()
    }

    private companion object {
        val RESTORABLE = Regex("""\[(اسم|مكان)\s*([0-9٠-٩]*)\]""")
    }
}
