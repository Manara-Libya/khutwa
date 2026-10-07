import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/chat/domain/entities/reflection.dart';
import 'package:khutwa_app/features/onboarding/data/repositories/in_memory_profile_repository.dart';
import 'package:khutwa_app/features/onboarding/presentation/providers/onboarding_repository_provider.dart';
import 'package:khutwa_app/features/support/data/repositories/rule_based_support_repository.dart';
import 'package:khutwa_app/features/support/domain/entities/suggestion_kind.dart';
import 'package:khutwa_app/features/support/presentation/providers/support_repository_provider.dart';

void main() {
  const reflection = Reflection(topic: 'study', feeling: Feeling.anxious);
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          InMemoryProfileRepository(),
        ),
        supportRepositoryProvider.overrideWithValue(
          const RuleBasedSupportRepository(),
        ),
      ],
    );
  });

  test('loads suggestions for the reflection with nothing selected', () {
    final state = container.read(suggestionsProvider(reflection));
    expect(state.suggestions.first, SuggestionKind.trustedAdult);
    expect(state.selected, isNull);
    expect(state.expanded, isEmpty);
  });

  test('select and toggleWhy update the state', () {
    final provider = suggestionsProvider(reflection);
    container.listen(provider, (_, _) {});
    final session = container.read(provider.notifier);

    session.select(SuggestionKind.counselor);
    session.toggleWhy(SuggestionKind.counselor);
    expect(container.read(provider).selected, SuggestionKind.counselor);
    expect(container.read(provider).expanded, {SuggestionKind.counselor});

    session.toggleWhy(SuggestionKind.counselor);
    expect(container.read(provider).expanded, isEmpty);
  });
}
