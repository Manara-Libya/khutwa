import '../../../../../app/l10n/l10n.dart';
import '../../../../../core/validation/string_validator.dart';

abstract final class WriteValidators {
  /// The backend's `MAX_TEXT_CHARS`.
  static const maxLength = 2000;

  /// Empty input is not an error (the button stays disabled); too long is.
  static StringValidator text(AppLocalizations l10n) =>
      (value) =>
          value.trim().length > maxLength ? l10n.chatTooLong(maxLength) : null;
}
