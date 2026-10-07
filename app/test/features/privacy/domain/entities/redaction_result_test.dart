import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/privacy/domain/entities/redaction_result.dart';

void main() {
  test('redacted matches the #53 example', () {
    const original = 'انا سلمى من سبها، خوي محمد ديما يتعارك، رقمي 0912345678';
    int at(String word) => original.indexOf(word);
    final result = RedactionResult(original, [
      Span(at('سلمى'), at('سلمى') + 4, IdentifierType.name),
      Span(at('سبها'), at('سبها') + 4, IdentifierType.place),
      Span(at('محمد'), at('محمد') + 4, IdentifierType.name),
      Span(at('0912345678'), original.length, IdentifierType.phone),
    ]);

    expect(
      result.redacted,
      'انا [اسم1] من [مكان1]، خوي [اسم2] ديما يتعارك، رقمي [رقم]',
    );
  });

  test('the same name gets the same number, and restore puts it back', () {
    const original = 'سند قالي ومحمد سمع، وسند ضحك، رقمي 0912345678';
    final result = RedactionResult(original, [
      const Span(0, 3, IdentifierType.name),
      Span(
        original.indexOf('محمد'),
        original.indexOf('محمد') + 4,
        IdentifierType.name,
      ),
      Span(
        original.lastIndexOf('سند'),
        original.lastIndexOf('سند') + 3,
        IdentifierType.name,
      ),
      Span(
        original.indexOf('0912345678'),
        original.length,
        IdentifierType.phone,
      ),
    ]);

    expect(result.redacted, '[اسم1] قالي و[اسم2] سمع، و[اسم1] ضحك، رقمي [رقم]');
    expect(
      result.restore('يا [اسم1] و[اسم ٢]، رقمي [رقم]'),
      'يا سند ومحمد، رقمي [رقم]',
    );
    expect(
      result.restore('يا [اسم]'),
      'يا [اسم]',
    ); // two names: ambiguous, kept
    expect(result.restore('يا [اسم9]'), 'يا [اسم9]'); // unknown number, kept
  });

  test('no spans leaves the text unchanged', () {
    expect(const RedactionResult('hello', []).redacted, 'hello');
  });

  test('placeholders and Kotlin names match the #53 enum', () {
    expect(IdentifierType.hidden.placeholder, '[مخفي]');
    expect(IdentifierType.email.placeholder, '[بريد]');
    expect(IdentifierType.name.kotlinName, 'NAME');
    expect(IdentifierType.fromKotlin('HIDDEN'), IdentifierType.hidden);
  });

  test('equality covers text and spans (used as a provider key)', () {
    const a = RedactionResult('x y', [Span(0, 1, IdentifierType.hidden)]);
    const b = RedactionResult('x y', [Span(0, 1, IdentifierType.hidden)]);
    const c = RedactionResult('x y', []);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(c));
  });
}
