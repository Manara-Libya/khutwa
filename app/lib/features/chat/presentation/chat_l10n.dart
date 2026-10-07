import '../../../app/l10n/l10n.dart';
import '../../onboarding/domain/entities/user_profile.dart';
import '../domain/entities/chat_message.dart';
import '../domain/entities/reflection.dart';

extension ChatL10n on AppLocalizations {
  String botLine(BotMessage message, String name, Personality personality) {
    final warm = personality == Personality.warm;
    return switch (message.step) {
      0 => warm ? chatWarm1(name) : chatDirect1(name),
      1 => warm ? chatWarm2(message.answer) : chatDirect2(message.answer),
      2 => warm ? chatWarm3(message.answer) : chatDirect3,
      _ => chatFallback,
    };
  }

  String feeling(Feeling feeling) => switch (feeling) {
    Feeling.stressed => feelingStressed,
    Feeling.anxious => feelingAnxious,
    Feeling.sad => feelingSad,
    Feeling.angry => feelingAngry,
    Feeling.lonely => feelingLonely,
    Feeling.unclear => feelingUnclear,
  };

  String reflection(Reflection reflection) =>
      reflectionBody(reflection.topic, feeling(reflection.feeling));
}
