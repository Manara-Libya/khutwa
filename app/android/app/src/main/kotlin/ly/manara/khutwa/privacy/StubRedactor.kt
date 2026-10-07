package ly.manara.khutwa.privacy

/**
 * Placeholder until Anas's real redactor (#58) lands, as allowed in #53:
 * the automatic pass finds nothing, but tap-to-hide works.
 *
 * To switch, change the one line in MainActivity that creates the redactor.
 */
class StubRedactor : Redactor {
    override fun redact(text: String): RedactionResult = RedactionResult(text, emptyList())

    override fun toggle(result: RedactionResult, start: Int, end: Int): RedactionResult {
        val overlapping = result.spans.filter { it.start < end && start < it.end }
        val spans = if (overlapping.isNotEmpty()) {
            result.spans - overlapping.toSet()
        } else {
            (result.spans + Span(start, end, IdentifierType.HIDDEN)).sortedBy { it.start }
        }
        return result.copy(spans = spans)
    }
}
