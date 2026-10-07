import '../../../../../app/l10n/l10n.dart';
import '../../../../../core/validation/string_validator.dart';

abstract final class ConversationValidators {
  /// The backend's `MAX_TEXT_CHARS`.
  static const maxLength = 2000;

  /// Empty input is not an error (send stays disabled); too long is.
  static StringValidator message(AppLocalizations l10n) =>
      (value) =>
          value.trim().length > maxLength ? l10n.chatTooLong(maxLength) : null;
}
