import '../../../chat/domain/entities/reflection.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../entities/suggestion_kind.dart';

abstract interface class SupportRepository {
  /// Suggestions for [reflection], most relevant first.
  List<SuggestionKind> suggestionsFor(
    Reflection reflection,
    UserProfile profile,
  );
}
