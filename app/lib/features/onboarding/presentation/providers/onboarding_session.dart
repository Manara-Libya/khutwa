import '../../domain/entities/user_profile.dart';

/// Actions available while onboarding. Controllers and tests depend on this
/// interface rather than on the Riverpod notifier.
abstract interface class OnboardingSession {
  void setAgeConfirmed(bool value);
  void setUnderstandsLimits(bool value);
  void setAcceptedTerms(bool value);
  void setNickname(String nickname);
  void selectAge(AgeGroup age);
  void selectPersonality(Personality personality);
  void selectSupportStyle(SupportStyle style);

  /// Saves the profile built during onboarding.
  Future<void> complete();
}
