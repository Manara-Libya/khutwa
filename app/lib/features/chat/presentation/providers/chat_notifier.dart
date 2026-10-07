import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/domain/repositories/profile_repository.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../onboarding/presentation/providers/onboarding_repository_provider.dart';
import '../../domain/entities/a2ui_surface.dart';
import '../../domain/entities/ai_reply.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_ai_repository.dart';
import '../../domain/repositories/home_repository.dart';
import 'chat_repository_provider.dart';
import '../screens/chat_controller.dart';
import 'chat_state.dart';

class ChatNotifier extends Notifier<ChatState> implements ChatSession {
  ChatNotifier({this._profiles, this._reflections, this._ai, this._replyDelay});

  final ProfileRepository? _profiles;
  final ReflectionRepository? _reflections;
  final ChatAiRepository? _ai;
  final Duration? _replyDelay;

  ProfileRepository get profiles =>
      _profiles ?? ref.read(profileRepositoryProvider);
  ReflectionRepository get reflections =>
      _reflections ?? ref.read(reflectionRepositoryProvider);
  ChatAiRepository get ai => _ai ?? ref.read(chatAiRepositoryProvider);
  Duration get replyDelay => _replyDelay ?? ref.read(chatReplyDelayProvider);

  final List<String> _userAnswers = [];

  @override
  ChatState build() {
    final profile = profiles.read() ?? const UserProfile(nickname: 'Friend');
    return ChatState(
      nickname: profile.nickname,
      personality: profile.personality ?? Personality.warm,
      messages: const [BotMessage(step: 0)],
      isTyping: false,
    );
  }

  @override
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final updated = [...state.messages, UserMessage(trimmed)];
    state = state.copyWith(messages: updated, isTyping: true);

    if (replyDelay > Duration.zero) {
      await Future<void>.delayed(replyDelay);
    }
    if (!ref.mounted) return;

    // The AI answers first; with nothing to add, the scripted intro goes on.
    final aiReply = await ai.reply(trimmed);
    if (!ref.mounted) return;
    if (aiReply != null) {
      _addAiReply(aiReply);
      return;
    }

    _userAnswers.add(trimmed);
    final step = _userAnswers.length;
    if (step < 3) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          BotMessage(step: step, answer: trimmed),
        ],
        isTyping: false,
      );
    } else {
      final reflection = await reflections.reflect(_userAnswers);
      state = state.copyWith(
        messages: [...state.messages, ReflectionMessage(reflection)],
        isTyping: false,
      );
    }
  }

  @override
  Future<void> chooseAiAction(
    AiSurfaceMessage message,
    A2uiAction action,
  ) async {
    // Only the first choice on a surface counts.
    if (message.chosenAction != null) return;
    state = state.copyWith(
      messages: state.messages
          .map((m) => identical(m, message) ? message.choose(action.name) : m)
          .toList(),
    );
    final followUp = await ai.handleAction(action);
    if (!ref.mounted || followUp == null) return;
    _addAiReply(followUp);
  }

  void _addAiReply(AiReply reply) {
    state = state.copyWith(
      messages: [
        ...state.messages,
        if (reply.text case final text?) AiTextMessage(text),
        if (reply.surface case final surface?) AiSurfaceMessage(surface),
      ],
      isTyping: false,
    );
  }
}
