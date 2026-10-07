import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/support/presentation/screens/draft/draft_controller.dart';
import 'package:khutwa_app/features/support/presentation/providers/draft_session.dart';

class _FakeDraftSession implements DraftSession {
  String? copied;

  @override
  Future<void> copy(String text) async => copied = text;
}

void main() {
  late _FakeDraftSession session;
  late DraftController controller;

  setUp(() {
    session = _FakeDraftSession();
    controller = DraftController(session: session, original: 'Hello');
  });

  tearDown(() => controller.dispose());

  test('starts with the original draft', () {
    expect(controller.text.text, 'Hello');
  });

  test('copies the edited text, not the original', () async {
    controller.text.text = 'Hello, edited';
    await controller.copy();
    expect(session.copied, 'Hello, edited');
  });

  test('reset restores the original draft', () {
    controller.text.text = 'changed';
    controller.reset();
    expect(controller.text.text, 'Hello');
  });
}
