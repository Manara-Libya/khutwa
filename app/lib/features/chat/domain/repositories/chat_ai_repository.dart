import '../entities/a2ui_surface.dart';
import '../entities/ai_reply.dart';

abstract interface class ChatAiRepository {
  /// The AI's reply to [message], or null when the AI has nothing to add and
  /// the scripted conversation should continue.
  Future<AiReply?> reply(String message);

  /// Reports a tap on an A2UI button (`userAction`). Returns the AI's
  /// follow-up, or null if there is none.
  Future<AiReply?> handleAction(A2uiAction action);
}
