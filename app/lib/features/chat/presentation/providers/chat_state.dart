import '../../../onboarding/domain/entities/user_profile.dart';
import '../../domain/entities/chat_message.dart';

class ChatState {
  const ChatState({
    required this.nickname,
    required this.personality,
    required this.messages,
    required this.isTyping,
  });

  final String nickname;
  final Personality personality;
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatState copyWith({
    String? nickname,
    Personality? personality,
    List<ChatMessage>? messages,
    bool? isTyping,
  }) => ChatState(
    nickname: nickname ?? this.nickname,
    personality: personality ?? this.personality,
    messages: messages ?? this.messages,
    isTyping: isTyping ?? this.isTyping,
  );
}
