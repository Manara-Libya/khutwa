import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/chat/data/repositories/mock_chat_repository.dart';
import 'package:khutwa_app/features/chat/domain/entities/a2ui_surface.dart';
import 'package:khutwa_app/features/chat/domain/entities/chat_message.dart';
import 'package:khutwa_app/features/chat/domain/entities/reflection.dart';
import 'package:khutwa_app/features/chat/domain/repositories/home_repository.dart';
import 'package:khutwa_app/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:khutwa_app/features/onboarding/data/repositories/in_memory_profile_repository.dart';
import 'package:khutwa_app/features/onboarding/domain/entities/user_profile.dart';
import 'package:khutwa_app/features/onboarding/presentation/providers/onboarding_repository_provider.dart';

class _FakeReflectionRepository implements ReflectionRepository {
  List<String>? received;

  @override
  Future<Reflection> reflect(List<String> answers) async {
    received = answers;
    return const Reflection(topic: 'study', feeling: Feeling.stressed);
  }
}

void main() {
  late _FakeReflectionRepository reflections;
  late ProviderContainer container;

  setUp(() async {
    reflections = _FakeReflectionRepository();
    final profiles = InMemoryProfileRepository();
    await profiles.save(
      const UserProfile(nickname: 'Sara', personality: Personality.direct),
    );
    container = ProviderContainer.test(
      overrides: [
        profileRepositoryProvider.overrideWithValue(profiles),
        reflectionRepositoryProvider.overrideWithValue(reflections),
        chatAiRepositoryProvider.overrideWithValue(MockChatRepository()),
        chatReplyDelayProvider.overrideWithValue(Duration.zero),
      ],
    );
  });

  test(
    'asking for help shows AI text and help cards, not the script',
    () async {
      await container
          .read(chatProvider.notifier)
          .sendMessage('أحتاج إلى مساعدة');

      final messages = container.read(chatProvider).messages;
      expect(messages[messages.length - 2], isA<AiTextMessage>());
      expect(messages.last, isA<AiSurfaceMessage>());
      expect(container.read(chatProvider).isTyping, isFalse);

      // The help request does not count as a scripted answer.
      await container.read(chatProvider.notifier).sendMessage('study');
      final last = container.read(chatProvider).messages.last as BotMessage;
      expect(last.step, 1);
    },
  );

  test('choosing a card marks it and adds the AI follow-up once', () async {
    final session = container.read(chatProvider.notifier);
    await session.sendMessage('I need help');
    final surface =
        container.read(chatProvider).messages.last as AiSurfaceMessage;

    await session.chooseAiAction(surface, const A2uiAction('calming_exercise'));
    var messages = container.read(chatProvider).messages;
    final chosen = messages.whereType<AiSurfaceMessage>().single;
    expect(chosen.chosenAction, 'calming_exercise');
    expect(messages.last, isA<AiTextMessage>());

    // A second tap on the same (already chosen) surface is ignored.
    final count = messages.length;
    await session.chooseAiAction(chosen, const A2uiAction('urgent_help'));
    messages = container.read(chatProvider).messages;
    expect(messages, hasLength(count));
  });

  test('starts with the first scripted line, using the saved profile', () {
    final state = container.read(chatProvider);
    expect(state.nickname, 'Sara');
    expect(state.personality, Personality.direct);
    expect(state.messages.single, isA<BotMessage>());
  });

  test('replies to each answer, then reflects on the third', () async {
    final session = container.read(chatProvider.notifier);
    await session.sendMessage('study');
    await session.sendMessage('games');

    var messages = container.read(chatProvider).messages;
    expect(messages.last, isA<BotMessage>());
    expect((messages.last as BotMessage).answer, 'games');

    await session.sendMessage('exams stress me');

    messages = container.read(chatProvider).messages;
    expect(messages.last, isA<ReflectionMessage>());
    expect(reflections.received, ['study', 'games', 'exams stress me']);
    expect(container.read(chatProvider).isTyping, isFalse);
  });

  test('ignores blank messages', () async {
    await container.read(chatProvider.notifier).sendMessage('   ');
    expect(container.read(chatProvider).messages, hasLength(1));
  });
}
