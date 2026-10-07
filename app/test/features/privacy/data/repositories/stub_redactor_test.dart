import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/privacy/data/repositories/stub_redactor.dart';
import 'package:khutwa_app/features/privacy/domain/entities/redaction_result.dart';

void main() {
  const redactor = StubRedactor();

  test('redact finds nothing (stub allowed by #53)', () async {
    final result = await redactor.redact('انا سلمى');
    expect(result.spans, isEmpty);
    expect(result.redacted, 'انا سلمى');
  });

  test('toggle hides a visible word, then restores it', () async {
    final start = await redactor.redact('انا سلمى من سبها');
    final hidden = await redactor.toggle(start, 4, 8);
    expect(hidden.redacted, 'انا [مخفي] من سبها');

    final restored = await redactor.toggle(hidden, 4, 8);
    expect(restored.redacted, 'انا سلمى من سبها');
  });

  test('toggling an automatic span restores it; spans stay sorted', () async {
    const auto = RedactionResult('a b c', [Span(4, 5, IdentifierType.name)]);
    final withHidden = await redactor.toggle(auto, 0, 1);
    expect(withHidden.spans.map((s) => s.start), [0, 4]);

    final restored = await redactor.toggle(withHidden, 4, 5);
    expect(restored.redacted, '[مخفي] b c');
  });
}
