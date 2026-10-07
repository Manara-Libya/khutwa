import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/chat/domain/entities/a2ui_surface.dart';
import 'package:khutwa_app/features/chat/domain/entities/chat_message.dart';
import 'package:khutwa_app/features/chat/presentation/screens/chat_controller.dart';

class _FakeChatSession implements ChatSession {
  final sent = <String>[];

  @override
  Future<void> sendMessage(String text) async => sent.add(text);

  @override
  Future<void> chooseAiAction(
    AiSurfaceMessage message,
    A2uiAction action,
  ) async {}
}

void main() {
  late _FakeChatSession session;
  late ChatController controller;

  setUp(() {
    session = _FakeChatSession();
    controller = ChatController(
      session: session,
      validator: (v) => v.length > 5 ? 'too long' : null,
    );
  });

  tearDown(() => controller.dispose());

  test('sends trimmed input and clears the field', () {
    controller.input.text = ' hi ';
    controller.send();
    expect(session.sent, ['hi']);
    expect(controller.input.text, isEmpty);
  });

  test('ignores empty input', () {
    controller.input.text = '   ';
    controller.send();
    expect(session.sent, isEmpty);
    expect(controller.error.value, isNull);
  });

  test('keeps invalid input and exposes the error', () {
    controller.input.text = 'way too long';
    controller.send();
    expect(session.sent, isEmpty);
    expect(controller.input.text, 'way too long');
    expect(controller.error.value, 'too long');
  });
}
