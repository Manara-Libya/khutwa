import '../../domain/entities/suggestion_kind.dart';

abstract interface class SuggestionsSession {
  void select(SuggestionKind kind);

  /// Shows or hides the "why this suggestion" explanation for [kind].
  void toggleWhy(SuggestionKind kind);
}
