abstract interface class PrivacyPanelSession {
  /// Hides the text in [start, end), or restores it if it is hidden.
  Future<void> toggle(int start, int end);
}
