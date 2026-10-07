import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_profile.dart';
import 'onboarding_repository_provider.dart';
import 'onboarding_session.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends Notifier<OnboardingState>
    implements OnboardingSession {
  @override
  OnboardingState build() => const OnboardingState();

  @override
  void setAgeConfirmed(bool value) => state = state.copyWith(
    consent: state.consent.copyWith(ageConfirmed: value),
  );

  @override
  void setUnderstandsLimits(bool value) => state = state.copyWith(
    consent: state.consent.copyWith(understandsLimits: value),
  );

  @override
  void setAcceptedTerms(bool value) => state = state.copyWith(
    consent: state.consent.copyWith(acceptedTerms: value),
  );

  @override
  void setNickname(String nickname) => state = state.copyWith(
    profile: state.profile.copyWith(nickname: nickname),
  );

  @override
  void selectAge(AgeGroup age) =>
      state = state.copyWith(profile: state.profile.copyWith(ageGroup: age));

  @override
  void selectPersonality(Personality personality) => state = state.copyWith(
    profile: state.profile.copyWith(personality: personality),
  );

  @override
  void selectSupportStyle(SupportStyle style) => state = state.copyWith(
    profile: state.profile.copyWith(supportStyle: style),
  );

  @override
  Future<void> complete() =>
      ref.read(profileRepositoryProvider).save(state.profile);
}
