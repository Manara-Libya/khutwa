abstract final class AppRoutes {
  // The flow: consent → chat → suggestions → draft.
  static const consent = '/';
  static const chat = '/chat';
  static const supportOptions = '/suggestions';
  static const messageDraft = '/draft';

  /// Outside the flow: opened by 🆘 or `urgent: true`.
  static const urgent = '/urgent';
}
