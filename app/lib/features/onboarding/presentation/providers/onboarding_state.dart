import '../../domain/entities/consent.dart';
import '../../domain/entities/user_profile.dart';

class OnboardingState {
  const OnboardingState({
    this.profile = const UserProfile(),
    this.consent = const Consent(),
  });

  final UserProfile profile;
  final Consent consent;

  OnboardingState copyWith({UserProfile? profile, Consent? consent}) =>
      OnboardingState(
        profile: profile ?? this.profile,
        consent: consent ?? this.consent,
      );
}
