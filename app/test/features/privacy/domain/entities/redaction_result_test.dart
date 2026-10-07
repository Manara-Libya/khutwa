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
      'انا [اسم] من [مكان]، خوي [اسم] ديما يتعارك، رقمي [رقم]',
    );
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
