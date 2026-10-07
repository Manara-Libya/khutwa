import '../../../../../app/l10n/l10n.dart';
import '../../../../../core/validation/string_validator.dart';

abstract final class NicknameValidators {
  static const maxLength = 30;

  /// Returns a validator whose messages are in [l10n]'s language.
  static StringValidator nickname(AppLocalizations l10n) => (value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return l10n.nicknameRequired;
    if (trimmed.length > maxLength) return l10n.nicknameTooLong(maxLength);
    return null;
  };
}
