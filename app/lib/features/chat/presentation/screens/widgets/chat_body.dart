import 'package:flutter/material.dart';

import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_typing_indicator.dart';
import '../../../../onboarding/domain/entities/user_profile.dart';
import '../../../domain/entities/a2ui_surface.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/reflection.dart';
import '../../chat_l10n.dart';
import 'a2ui_surface_view.dart';
import 'chat_bot_message.dart';
import 'chat_reflection_card.dart';
import 'chat_user_bubble.dart';

/// Chat Body widget rendering the list of messages and typing indicator.
class ChatBody extends StatelessWidget {
  const ChatBody({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.isTyping,
    required this.nickname,
    required this.personality,
    required this.onListen,
    required this.onSeeSuggestions,
    required this.onAiAction,
  });

  final ScrollController scrollController;
  final List<ChatMessage> messages;
  final bool isTyping;
  final String nickname;
  final Personality personality;
  final VoidCallback onListen;
  final ValueChanged<Reflection> onSeeSuggestions;
  final void Function(AiSurfaceMessage message, A2uiAction action) onAiAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == messages.length) return const AppTypingIndicator();
        return switch (messages[i]) {
          UserMessage(:final text) => ChatUserBubble(text: text),
          final BotMessage m => ChatBotMessage(
            text: l10n.botLine(m, nickname, personality),
            onListen: onListen,
          ),
          ReflectionMessage(:final reflection) => ChatReflectionCard(
            text: l10n.reflection(reflection),
            onSeeSuggestions: () => onSeeSuggestions(reflection),
          ),
          AiTextMessage(:final text) => ChatBotMessage(
            text: text,
            onListen: onListen,
          ),
          final AiSurfaceMessage m => A2uiSurfaceView(
            surface: m.surface,
            chosenAction: m.chosenAction,
            onAction: (action) => onAiAction(m, action),
          ),
        };
      },
    );
  }
}
