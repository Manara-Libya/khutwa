import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/onboarding/data/repositories/in_memory_profile_repository.dart';
import 'package:khutwa_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:khutwa_app/features/onboarding/presentation/providers/onboarding_repository_provider.dart';

void main() {
  late InMemoryProfileRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = InMemoryProfileRepository();
    container = ProviderContainer.test(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
    );
  });

  test('consent is complete only when all three boxes are checked', () {
    final session = container.read(onboardingProvider.notifier);
    session.setAgeConfirmed(true);
    session.setUnderstandsLimits(true);
    expect(container.read(onboardingProvider).consent.isComplete, isFalse);

    session.setAcceptedTerms(true);
    expect(container.read(onboardingProvider).consent.isComplete, isTrue);
  });

  test('complete saves the profile built during onboarding', () async {
    final session = container.read(onboardingProvider.notifier)
      ..setNickname('Sara')
      ..selectAge(AgeGroup.teen)
      ..selectPersonality(Personality.direct)
      ..selectSupportStyle(SupportStyle.guided);
    expect(repository.read(), isNull);

    await session.complete();

    final saved = repository.read()!;
    expect(saved.nickname, 'Sara');
    expect(saved.ageGroup, AgeGroup.teen);
    expect(saved.personality, Personality.direct);
    expect(saved.supportStyle, SupportStyle.guided);
  });

  test('personality defaults to warm when skipped', () {
    expect(
      container.read(onboardingProvider).profile.effectivePersonality,
      Personality.warm,
    );
  });
}
