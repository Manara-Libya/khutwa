import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/app/l10n/l10n.dart';
import 'package:khutwa_app/features/onboarding/presentation/screens/nickname/nickname_validators.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));
  final validate = NicknameValidators.nickname(l10n);

  test('rejects empty and whitespace-only nicknames', () {
    expect(validate(''), l10n.nicknameRequired);
    expect(validate('   '), l10n.nicknameRequired);
  });

  test('rejects nicknames over the max length', () {
    final tooLong = 'a' * (NicknameValidators.maxLength + 1);
    expect(
      validate(tooLong),
      l10n.nicknameTooLong(NicknameValidators.maxLength),
    );
  });

  test('accepts a normal nickname', () {
    expect(validate('أحمد'), isNull);
  });
}
