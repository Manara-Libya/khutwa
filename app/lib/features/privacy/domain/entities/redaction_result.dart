/// Dart mirror of the Kotlin redaction interface agreed in #53
/// (android/app/src/main/kotlin/ly/manara/khutwa/privacy/Redaction.kt).
/// Keep the two in sync.
library;

enum IdentifierType {
  name('[اسم]'),
  place('[مكان]'),
  phone('[رقم]'),
  email('[بريد]'),
  number('[رقم]'),
  hidden('[مخفي]');

  const IdentifierType(this.placeholder);

  final String placeholder;

  /// The Kotlin enum constant name, used on the platform channel.
  // `EnumName(this)`: the constant `name` above shadows `Enum.name`.
  String get kotlinName => EnumName(this).name.toUpperCase();

  static IdentifierType fromKotlin(String value) =>
      values.firstWhere((t) => t.kotlinName == value);
}

class Span {
  const Span(this.start, this.end, this.type);

  /// Inclusive UTF-16 index into [RedactionResult.original].
  final int start;

  /// Exclusive.
  final int end;
  final IdentifierType type;

  String get replacement => type.placeholder;

  @override
  bool operator ==(Object other) =>
      other is Span &&
      other.start == start &&
      other.end == end &&
      other.type == type;

  @override
  int get hashCode => Object.hash(start, end, type);
}

class RedactionResult {
  const RedactionResult(this.original, this.spans);

  /// What the user typed. Stays on the phone, never sent.
  final String original;

  /// Sorted by start, non-overlapping.
  final List<Span> spans;

  /// The placeholder sent for each span. Names and places are numbered by
  /// first appearance («[اسم1]», «[مكان2]») and the same word always gets the
  /// same number, so the AI can refer to a person and [restore] can put the
  /// real name back. Other types keep their plain placeholder.
  List<String> get placeholders {
    final numbers = <String, int>{};
    final counts = <IdentifierType, int>{};
    final out = <String>[];
    for (final s in spans) {
      if (s.type != IdentifierType.name && s.type != IdentifierType.place) {
        out.add(s.replacement);
        continue;
      }
      final word = original.substring(s.start, s.end).trim().toLowerCase();
      final n = numbers.putIfAbsent(
        '${s.type.kotlinName}$word',
        () => counts[s.type] = (counts[s.type] ?? 0) + 1,
      );
      out.add('${s.replacement.substring(0, s.replacement.length - 1)}$n]');
    }
    return out;
  }

  /// The ONLY text that may leave the phone.
  String get redacted {
    final out = StringBuffer();
    final placeholders = this.placeholders;
    var i = 0;
    for (var k = 0; k < spans.length; k++) {
      out
        ..write(original.substring(i, spans[k].start))
        ..write(placeholders[k]);
      i = spans[k].end;
    }
    out.write(original.substring(i));
    return out.toString();
  }

  /// Puts the real names and places back into text the AI wrote (reflection,
  /// draft message). Runs on the phone only; the result is never sent.
  /// Numbers, emails and hidden words are never put back. A bare «[اسم]» or
  /// «[مكان]» is restored only when the message has exactly one of them.
  String restore(String aiText) {
    final words = <String, String>{};
    final placeholders = this.placeholders;
    for (var k = 0; k < spans.length; k++) {
      final s = spans[k];
      if (s.type == IdentifierType.name || s.type == IdentifierType.place) {
        words.putIfAbsent(
          placeholders[k],
          () => original.substring(s.start, s.end),
        );
      }
    }
    return aiText.replaceAllMapped(_restorable, (m) {
      final digits = m[2]!.replaceAllMapped(
        RegExp('[٠-٩]'),
        (d) => '${d[0]!.codeUnitAt(0) - 0x0660}',
      );
      final base = '[${m[1]}';
      final String? key;
      if (digits.isEmpty) {
        final matches = words.keys.where((w) => w.startsWith(base)).toList();
        key = matches.length == 1 ? matches.single : null;
      } else {
        key = '$base$digits]';
      }
      return (key == null ? null : words[key]) ?? m[0]!;
    });
  }

  static final _restorable = RegExp(r'\[(اسم|مكان)\s*([0-9٠-٩]*)\]');

  @override
  bool operator ==(Object other) =>
      other is RedactionResult &&
      other.original == original &&
      _listEquals(other.spans, spans);

  @override
  int get hashCode => Object.hash(original, Object.hashAll(spans));

  static bool _listEquals(List<Span> a, List<Span> b) =>
      a.length == b.length &&
      Iterable<int>.generate(a.length).every((i) => a[i] == b[i]);
}
