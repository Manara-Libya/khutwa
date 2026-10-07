import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/analysis/presentation/providers/conversation_session.dart';
import 'package:khutwa_app/features/analysis/presentation/screens/conversation/conversation_controller.dart';

class _FakeSession implements ConversationSession {
  final sent = <String>[];

  @override
  Future<void> send(String text) async => sent.add(text);

  @override
  Future<void> retry() async {}
}

void main() {
  late _FakeSession session;
  late ConversationController controller;

  setUp(() {
    session = _FakeSession();
    controller = ConversationController(
      session: session,
      validator: (v) => v.length > 12 ? 'too long' : null,
    );
  });

  tearDown(() => controller.dispose());

  test('sends trimmed text and clears the field', () {
    controller.text.text = '  rani ta3ban  ';
    controller.send();
    expect(session.sent, ['rani ta3ban']);
    expect(controller.text.text, isEmpty);
  });

  test('ignores empty input', () {
    controller.text.text = '   ';
    controller.send();
    expect(session.sent, isEmpty);
    expect(controller.error.value, isNull);
  });

  test('keeps invalid input and exposes the error', () {
    controller.text.text = 'way too long text';
    controller.send();
    expect(session.sent, isEmpty);
    expect(controller.text.text, 'way too long text');
    expect(controller.error.value, 'too long');
  });
}
