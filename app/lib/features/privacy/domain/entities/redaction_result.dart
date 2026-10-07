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

  /// The ONLY text that may leave the phone.
  String get redacted {
    final out = StringBuffer();
    var i = 0;
    for (final s in spans) {
      out
        ..write(original.substring(i, s.start))
        ..write(s.replacement);
      i = s.end;
    }
    out.write(original.substring(i));
    return out.toString();
  }

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
