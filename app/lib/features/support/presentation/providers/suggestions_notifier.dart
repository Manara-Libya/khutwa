import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../chat/domain/entities/reflection.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../onboarding/presentation/providers/onboarding_repository_provider.dart';
import '../../domain/entities/suggestion_kind.dart';
import 'support_repository_provider.dart';
import 'suggestions_session.dart';
import 'suggestions_state.dart';

class SuggestionsNotifier extends Notifier<SuggestionsState>
    implements SuggestionsSession {
  SuggestionsNotifier(this.reflection);

  final Reflection reflection;

  @override
  SuggestionsState build() {
    final profile =
        ref.read(profileRepositoryProvider).read() ?? const UserProfile();
    return SuggestionsState(
      reflection: reflection,
      suggestions: ref
          .read(supportRepositoryProvider)
          .suggestionsFor(reflection, profile),
    );
  }

  @override
  void select(SuggestionKind kind) => state = state.copyWith(selected: kind);

  @override
  void toggleWhy(SuggestionKind kind) => state = state.copyWith(
    expanded: state.expanded.contains(kind)
        ? ({...state.expanded}..remove(kind))
        : {...state.expanded, kind},
  );
}
