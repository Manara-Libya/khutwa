import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/chat_ai_repository.dart';
import '../../domain/repositories/home_repository.dart';
import 'chat_notifier.dart';
import 'chat_state.dart';

final reflectionRepositoryProvider = Provider<ReflectionRepository>(
  (ref) => throw UnimplementedError(
    'Bind reflectionRepositoryProvider in bootstrap',
  ),
);

/// The AI behind the chat. Bound in bootstrap (the mock, for now).
final chatAiRepositoryProvider = Provider<ChatAiRepository>(
  (ref) =>
      throw UnimplementedError('Bind chatAiRepositoryProvider in bootstrap'),
);

final chatReplyDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 1200),
);

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
