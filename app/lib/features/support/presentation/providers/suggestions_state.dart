import '../../../chat/domain/entities/reflection.dart';
import '../../domain/entities/suggestion_kind.dart';

class SuggestionsState {
  const SuggestionsState({
    required this.reflection,
    required this.suggestions,
    this.selected,
    this.expanded = const {},
  });

  final Reflection reflection;
  final List<SuggestionKind> suggestions;
  final SuggestionKind? selected;

  /// Suggestions whose "why" explanation is open.
  final Set<SuggestionKind> expanded;

  SuggestionsState copyWith({
    SuggestionKind? selected,
    Set<SuggestionKind>? expanded,
  }) => SuggestionsState(
    reflection: reflection,
    suggestions: suggestions,
    selected: selected ?? this.selected,
    expanded: expanded ?? this.expanded,
  );
}
