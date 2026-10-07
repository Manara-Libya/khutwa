import '../../../../domain/entities/redaction_result.dart';

/// A piece of the original text, as the privacy panel shows it.
sealed class RedactionSegment {
  const RedactionSegment(this.start, this.end);

  final int start;
  final int end;
}

/// A removed part (a [Span]); tapping it restores the text.
class RemovedSegment extends RedactionSegment {
  const RemovedSegment(super.start, super.end, this.type);

  final IdentifierType type;
}

/// A visible word; tapping it hides it.
class WordSegment extends RedactionSegment {
  const WordSegment(super.start, super.end);
}

/// Spaces and punctuation between words.
class GapSegment extends RedactionSegment {
  const GapSegment(super.start, super.end);
}

/// Words are runs of letters/digits in any script (Arabic, Arabizi, Latin).
final _word = RegExp(r'[^\s.,!?;:()"«»،؛؟\-]+');

/// Splits [result.original] into removed parts, words and gaps, in order.
List<RedactionSegment> segmentsOf(RedactionResult result) {
  final text = result.original;
  final segments = <RedactionSegment>[];

  void addVisible(int from, int to) {
    var i = from;
    for (final match in _word.allMatches(text.substring(from, to))) {
      final start = from + match.start, end = from + match.end;
      if (start > i) segments.add(GapSegment(i, start));
      segments.add(WordSegment(start, end));
      i = end;
    }
    if (i < to) segments.add(GapSegment(i, to));
  }

  var cursor = 0;
  for (final span in result.spans) {
    addVisible(cursor, span.start);
    segments.add(RemovedSegment(span.start, span.end, span.type));
    cursor = span.end;
  }
  addVisible(cursor, text.length);
  return segments;
}
