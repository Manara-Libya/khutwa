abstract final class AppRoutes {
  static const welcome = '/';
  static const consent = '/consent';

  // Demo path (#54): write → privacy panel → reflection → options → draft.
  static const write = '/write';
  static const privacyPanel = '/privacy';
  static const reflection = '/reflection';
  static const supportOptions = '/support-options';
  static const messageDraft = '/message-draft';

  // #55
  static const plan = '/plan';
  static const urgent = '/urgent';

  // Earlier onboarding/chat screens, not on the demo path.
  static const nickname = '/nickname';
  static const age = '/age';
  static const persona = '/persona';
  static const supportPreference = '/support-preference';
  static const chat = '/chat';
  static const suggestions = '/suggestions';
  static const draft = '/suggestions/draft';
}
