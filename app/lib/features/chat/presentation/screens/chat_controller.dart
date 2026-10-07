import 'package:flutter/material.dart';

import '../../domain/entities/a2ui_surface.dart';
import '../../domain/entities/chat_message.dart';

abstract interface class ChatSession {
  Future<void> sendMessage(String text);

  /// Records the user's tap on an AI surface button and adds the AI's
  /// follow-up, if any.
  Future<void> chooseAiAction(AiSurfaceMessage message, A2uiAction action);
}

class ChatController {
  ChatController({required this.session, required this.validator});

  final ChatSession session;
  final String? Function(String) validator;

  final TextEditingController input = TextEditingController();
  final ValueNotifier<String?> error = ValueNotifier(null);

  void send() {
    final text = input.text;
    final err = validator(text);
    error.value = err;
    if (err != null) return;

    final trimmed = text.trim();
    if (trimmed.isNotEmpty) {
      session.sendMessage(trimmed);
      input.clear();
    }
  }

  void dispose() {
    input.dispose();
    error.dispose();
  }
}
