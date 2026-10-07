import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/analysis_repository.dart';
import 'conversation_notifier.dart';
import 'conversation_state.dart';
import 'message_draft_notifier.dart';

/// Bound in `app/bootstrap.dart`: the live API when configured, else a mock.
final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) =>
      throw UnimplementedError('Bind analysisRepositoryProvider in bootstrap'),
);

final conversationProvider =
    NotifierProvider.autoDispose<ConversationNotifier, ConversationState>(
      ConversationNotifier.new,
    );

final messageDraftProvider =
    NotifierProvider.autoDispose<MessageDraftNotifier, bool>(
      MessageDraftNotifier.new,
    );
