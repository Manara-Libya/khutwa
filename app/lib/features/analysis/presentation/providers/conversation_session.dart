/// Actions in the conversation. Controllers and tests depend on this
/// interface rather than on the Riverpod notifier.
abstract interface class ConversationSession {
  /// Redacts [text] on the device, then sends only the redacted text.
  Future<void> send(String text);

  /// Sends the last redacted text again after a failure.
  Future<void> retry();
}
