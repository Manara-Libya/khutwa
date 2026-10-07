import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/onboarding/presentation/screens/nickname/nickname_controller.dart';
import 'package:khutwa_app/features/onboarding/presentation/providers/onboarding_session.dart';

class _FakeOnboardingSession implements OnboardingSession {
  String? nickname;

  @override
  void setNickname(String value) => nickname = value;

  @override
  void noSuchMethod(Invocation invocation) {}
}

void main() {
  late _FakeOnboardingSession session;
  late NicknameController controller;

  setUp(() {
    session = _FakeOnboardingSession();
    controller = NicknameController(
      session: session,
      validator: (v) => v.isEmpty ? 'required' : null,
    );
  });

  tearDown(() => controller.dispose());

  test('submits the trimmed nickname to the session', () {
    controller.text.text = '  Ali  ';
    expect(controller.submit(), isTrue);
    expect(session.nickname, 'Ali');
    expect(controller.error.value, isNull);
  });

  test('keeps invalid input out of the session and exposes the error', () {
    controller.text.text = '   ';
    expect(controller.submit(), isFalse);
    expect(session.nickname, isNull);
    expect(controller.error.value, 'required');
  });

  test('hasInput ignores whitespace', () {
    controller.text.text = '  ';
    expect(controller.hasInput, isFalse);
    controller.text.text = 'x';
    expect(controller.hasInput, isTrue);
  });
}
