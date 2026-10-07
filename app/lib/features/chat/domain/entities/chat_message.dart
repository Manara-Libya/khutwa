import 'a2ui_surface.dart';
import 'reflection.dart';

/// A chat entry. Bot lines store their script step (and the answer they
/// react to) rather than text, so the UI can render them in any language.
sealed class ChatMessage {
  const ChatMessage();
}

class UserMessage extends ChatMessage {
  const UserMessage(this.text);

  final String text;
}

class BotMessage extends ChatMessage {
  const BotMessage({required this.step, this.answer = ''});

  final int step;
  final String answer;
}

class ReflectionMessage extends ChatMessage {
  const ReflectionMessage(this.reflection);

  final Reflection reflection;
}

/// Free text written by the AI (already in the user's language).
class AiTextMessage extends ChatMessage {
  const AiTextMessage(this.text);

  final String text;
}

/// An interactive A2UI surface sent by the AI.
class AiSurfaceMessage extends ChatMessage {
  const AiSurfaceMessage(this.surface, {this.chosenAction});

  final A2uiSurface surface;

  /// The action the user picked on this surface, once they have.
  final String? chosenAction;

  AiSurfaceMessage choose(String action) =>
      AiSurfaceMessage(surface, chosenAction: action);
}
