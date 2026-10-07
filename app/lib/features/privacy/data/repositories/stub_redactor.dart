import '../../domain/entities/redaction_result.dart';
import '../../domain/repositories/redactor.dart';

/// Dart copy of the Kotlin `StubRedactor` (#53): finds nothing automatically,
/// but tap-to-hide works. Used in tests and on platforms without the channel.
class StubRedactor implements Redactor {
  const StubRedactor();

  @override
  Future<RedactionResult> redact(String text) async =>
      RedactionResult(text, const []);

  @override
  Future<RedactionResult> toggle(
    RedactionResult result,
    int start,
    int end,
  ) async => toggleSpans(result, start, end);

  /// Shared toggle rule: remove any span overlapping [start, end), or add a
  /// HIDDEN span when nothing overlaps.
  static RedactionResult toggleSpans(
    RedactionResult result,
    int start,
    int end,
  ) {
    bool overlaps(Span s) => s.start < end && start < s.end;
    final spans = result.spans.any(overlaps)
        ? result.spans.where((s) => !overlaps(s)).toList()
        : ([...result.spans, Span(start, end, IdentifierType.hidden)]
            ..sort((a, b) => a.start.compareTo(b.start)));
    return RedactionResult(result.original, spans);
  }
}
