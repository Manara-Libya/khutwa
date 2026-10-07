import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/privacy/domain/entities/redaction_result.dart';
import 'package:khutwa_app/features/privacy/presentation/screens/privacy_panel/widgets/redaction_segments.dart';

void main() {
  String describe(RedactionResult r) => segmentsOf(r)
      .map(
        (s) => switch (s) {
          RemovedSegment() => '[${r.original.substring(s.start, s.end)}]',
          WordSegment() => r.original.substring(s.start, s.end),
          GapSegment() => '_',
        },
      )
      .join('|');

  test('splits Arabic, Arabizi and punctuation into words and gaps', () {
    expect(
      describe(const RedactionResult('rani ta3bana، برشا!', [])),
      'rani|_|ta3bana|_|برشا|_',
    );
  });

  test('removed spans become one segment, words around them stay tappable', () {
    expect(
      describe(
        const RedactionResult('انا سلمى من سبها', [
          Span(4, 8, IdentifierType.name),
        ]),
      ),
      'انا|_|[سلمى]|_|من|_|سبها',
    );
  });

  test('segments cover the whole text with no gaps or overlaps', () {
    const r = RedactionResult('a, b  c', [Span(3, 4, IdentifierType.hidden)]);
    final segments = segmentsOf(r);
    expect(segments.first.start, 0);
    expect(segments.last.end, r.original.length);
    for (var i = 1; i < segments.length; i++) {
      expect(segments[i].start, segments[i - 1].end);
    }
  });
}
