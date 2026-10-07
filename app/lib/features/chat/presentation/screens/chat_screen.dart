import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../domain/entities/a2ui_surface.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/reflection.dart';
import 'widgets/chat_widgets.dart';

/// Pure UI Chat Screen composing [ChatTopBar], [ChatBody], and [ChatInputComposer].
class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.nickname,
    required this.personality,
    required this.messages,
    required this.isTyping,
    required this.inputController,
    required this.inputError,
    required this.scrollController,
    required this.onSend,
    required this.onVoice,
    required this.onListen,
    required this.onSeeSuggestions,
    required this.onUrgentHelp,
    required this.onAiAction,
  });

  final String nickname;
  final Personality personality;
  final List<ChatMessage> messages;
  final bool isTyping;
  final TextEditingController inputController;
  final ValueListenable<String?> inputError;
  final ScrollController scrollController;
  final VoidCallback onSend;
  final VoidCallback onVoice;
  final VoidCallback onListen;
  final ValueChanged<Reflection> onSeeSuggestions;
  final VoidCallback onUrgentHelp;
  final void Function(AiSurfaceMessage message, A2uiAction action) onAiAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [context.colors.primary, AppColors.chatGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 30.0),
                ChatTopBar(onUrgentPressed: onUrgentHelp),
                SizedBox(height: 40.0),

                Expanded(
                  child: ChatBody(
                    scrollController: scrollController,
                    messages: messages,
                    isTyping: isTyping,
                    nickname: nickname,
                    personality: personality,
                    onListen: onListen,
                    onSeeSuggestions: onSeeSuggestions,
                    onAiAction: onAiAction,
                  ),
                ),

                ChatInputComposer(
                  controller: inputController,
                  error: inputError,
                  onSend: onSend,
                  onVoice: onVoice,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
