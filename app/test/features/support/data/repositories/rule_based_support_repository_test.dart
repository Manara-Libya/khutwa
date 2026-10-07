import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/chat/domain/entities/reflection.dart';
import 'package:khutwa_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:khutwa_app/features/support/data/repositories/rule_based_support_repository.dart';
import 'package:khutwa_app/features/support/domain/entities/suggestion_kind.dart';

void main() {
  const repository = RuleBasedSupportRepository();

  test('stress with guided support: adult, counselor, specialist', () {
    expect(
      repository.suggestionsFor(
        const Reflection(topic: 'x', feeling: Feeling.stressed),
        const UserProfile(supportStyle: SupportStyle.guided),
      ),
      [
        SuggestionKind.trustedAdult,
        SuggestionKind.counselor,
        SuggestionKind.specialist,
      ],
    );
  });

  test('loneliness with self-care: adult, friend, note to self', () {
    expect(
      repository.suggestionsFor(
        const Reflection(topic: 'x', feeling: Feeling.lonely),
        const UserProfile(supportStyle: SupportStyle.selfCare),
      ),
      [
        SuggestionKind.trustedAdult,
        SuggestionKind.friend,
        SuggestionKind.selfNote,
      ],
    );
  });
}
