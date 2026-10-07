import '../../../chat/domain/entities/reflection.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../domain/entities/suggestion_kind.dart';
import '../../domain/repositories/support_repository.dart';

/// Picks three suggestions: always a trusted adult, then one matched to the
/// feeling, then one matched to the user's preferred support style.
class RuleBasedSupportRepository implements SupportRepository {
  const RuleBasedSupportRepository();

  @override
  List<SuggestionKind> suggestionsFor(
    Reflection reflection,
    UserProfile profile,
  ) => [
    SuggestionKind.trustedAdult,
    switch (reflection.feeling) {
      Feeling.stressed || Feeling.anxious => SuggestionKind.counselor,
      Feeling.sad ||
      Feeling.lonely ||
      Feeling.angry ||
      Feeling.unclear => SuggestionKind.friend,
    },
    profile.supportStyle == SupportStyle.guided
        ? SuggestionKind.specialist
        : SuggestionKind.selfNote,
  ];
}
