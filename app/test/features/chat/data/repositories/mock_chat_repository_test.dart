import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/chat/data/repositories/mock_chat_repository.dart';
import 'package:khutwa_app/features/chat/domain/entities/a2ui_surface.dart';

void main() {
  late MockChatRepository repository;

  setUp(() => repository = MockChatRepository());

  /// The action names of the cards' buttons, in order.
  List<String> actionsOf(A2uiSurface surface) {
    final root = surface[surface.rootId]! as A2uiColumn;
    return root.children.map((cardId) {
      final card = surface[cardId]! as A2uiCard;
      final column = surface[card.child]! as A2uiColumn;
      final button = column.children
          .map((id) => surface[id])
          .whereType<A2uiButton>()
          .single;
      return button.action.name;
    }).toList();
  }

  test(
    'asking for help returns help cards, specialist first and highlighted',
    () async {
      final reply = await repository.reply('أحتاج إلى مساعدة');

      expect(reply?.text, isNotEmpty);
      final surface = reply!.surface!;
      expect(actionsOf(surface), [
        'contact_specialist',
        'talk_trusted_adult',
        'calming_exercise',
        'urgent_help',
      ]);

      final cards = (surface[surface.rootId]! as A2uiColumn).children
          .map((id) => surface[id]! as A2uiCard)
          .toList();
      expect(cards.first.highlight, isTrue);
      expect(cards.skip(1).every((c) => !c.highlight), isTrue);
    },
  );

  test('matches spelling variants and English', () async {
    expect(await repository.reply('احتاج الي مساعدة'), isNotNull);
    expect(await repository.reply('I need help'), isNotNull);
  });

  test('replies in the language the user wrote in', () async {
    final reply = await repository.reply('I need help');
    expect(reply!.text, contains("I'm here"));
  });

  test('other messages return null so the script continues', () async {
    expect(await repository.reply('الدراسة'), isNull);
  });

  test('actions get a follow-up', () async {
    await repository.reply('أحتاج مساعدة');
    final followUp = await repository.handleAction(
      const A2uiAction('calming_exercise'),
    );
    expect(followUp?.text, contains('تنفّس'));
    expect(await repository.handleAction(const A2uiAction('unknown')), isNull);
  });
}
