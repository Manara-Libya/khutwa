import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../chat/domain/entities/reflection.dart';
import '../../domain/repositories/support_repository.dart';
import 'draft_notifier.dart';
import 'suggestions_notifier.dart';
import 'suggestions_state.dart';

/// Bound to a concrete implementation in `app/bootstrap.dart`.
final supportRepositoryProvider = Provider<SupportRepository>(
  (ref) => throw UnimplementedError(
    'Override supportRepositoryProvider in bootstrap',
  ),
);

final suggestionsProvider = NotifierProvider.autoDispose
    .family<SuggestionsNotifier, SuggestionsState, Reflection>(
      SuggestionsNotifier.new,
    );

final draftProvider = NotifierProvider.autoDispose<DraftNotifier, DraftStatus>(
  DraftNotifier.new,
);
