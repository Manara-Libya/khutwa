import '../../../../app/l10n/app_localizations.dart';

String? validateChatMessage(
  String value,
  AppLocalizations l10n, {
  int max = 280,
}) {
  final trimmed = value.trim();
  if (trimmed.length > max) return l10n.chatTooLong(max);
  return null;
}
