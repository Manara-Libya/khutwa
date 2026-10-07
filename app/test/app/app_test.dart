import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/app/app.dart';
import 'package:khutwa_app/app/bootstrap.dart';
import 'package:khutwa_app/core/platform/clipboard_service.dart';
import 'package:khutwa_app/core/platform/phone_dialer.dart';
import 'package:khutwa_app/core/platform/platform_providers.dart';
import 'package:khutwa_app/features/analysis/data/repositories/mock_analysis_repository.dart';
import 'package:khutwa_app/features/analysis/domain/entities/analysis_result.dart';
import 'package:khutwa_app/features/analysis/domain/repositories/analysis_repository.dart';
import 'package:khutwa_app/features/privacy/domain/entities/redaction_result.dart';
import 'package:khutwa_app/features/urgent_help/presentation/screens/urgent_help/widgets/urgent_button.dart';

class _FakeClipboard implements ClipboardService {
  String? text;

  @override
  Future<void> copy(String value) async => text = value;
}

class _FakeDialer implements PhoneDialer {
  String? dialed;

  @override
  Future<bool> dial(String number) async {
    dialed = number;
    return true;
  }
}

/// The offline mock API, recording exactly what the app sends.
class _RecordingAnalysisRepository implements AnalysisRepository {
  _RecordingAnalysisRepository(this.delay);

  final Duration delay;
  final sent = <RedactionResult>[];

  @override
  Future<AnalysisResult> analyze(RedactionResult redaction) {
    sent.add(redaction);
    return MockAnalysisRepository(delay: delay).analyze(redaction);
  }
}

void main() {
  late _FakeClipboard clipboard;
  late _FakeDialer dialer;
  late _RecordingAnalysisRepository api;

  Future<void> pumpApp(
    WidgetTester tester, {
    Locale locale = const Locale('ar'),
    Duration apiDelay = Duration.zero,
    bool showDemoContacts = false,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.localesTestValue = [locale];
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    clipboard = _FakeClipboard();
    dialer = _FakeDialer();
    api = _RecordingAnalysisRepository(apiDelay);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...appOverrides(
            useKotlinRedactor: false,
            analysisRepository: api,
            showDemoContacts: showDemoContacts,
          ),
          phoneDialerProvider.overrideWithValue(dialer),
          clipboardServiceProvider.overrideWithValue(clipboard),
        ],
        child: const KhutwaApp(useGoogleFonts: false),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectUrgentButton() =>
      expect(find.byType(UrgentButton), findsOneWidget);

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Scrolls the current screen's list until [finder] is built and visible.
  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find.byType(Scrollable).first,
      );

  /// Turns on the consent switch and continues to the chat.
  Future<void> agree(WidgetTester tester) async {
    // The switch is below the fold: scroll the consent list to it first.
    await tester.scrollUntilVisible(
      find.byType(Switch),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tapAndSettle(tester, find.byType(Switch));
    await tapAndSettle(tester, find.text('أوافق، نبدأ'));
  }

  Future<void> sendChat(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byTooltip('إرسال'));
  }

  testWidgets('consent → chat → suggestions → draft', (tester) async {
    await pumpApp(tester);
    expect(
      Directionality.of(tester.element(find.text('التزامنا معاك.'))),
      TextDirection.rtl,
    );
    expect(find.text('أنا ذكاء اصطناعي، مش إنسان.'), findsOneWidget);
    expectUrgentButton();

    // Consent: the button does nothing until the switch is on.
    await tester.tap(find.text('أوافق، نبدأ'));
    await tester.pumpAndSettle();
    expect(find.text('التزامنا معاك.'), findsOneWidget);
    await agree(tester);

    // Chat: nothing is sent until the user sends.
    expect(find.text('خلينا نبدأ ببساطة.'), findsOneWidget);
    expectUrgentButton();
    expect(api.sent, isEmpty);
    await sendChat(tester, 'انا دايما مضغوطة من الامتحانات');

    expect(api.sent.single.redacted, 'انا دايما مضغوطة من الامتحانات');
    expect(find.textContaining('شايل حمل كبير'), findsOneWidget);

    // Suggestions: Arabic labels and the "why" line; the user taps one.
    await tapAndSettle(tester, find.text('اعرض لي خيارات الدعم'));
    expect(find.text('أخصائي'), findsOneWidget);
    expect(find.text('صديق تثق فيه'), findsOneWidget);
    expectUrgentButton();
    await tapAndSettle(tester, find.text('أخصائي'));

    // Draft: editable, copyable, and never sent by the app.
    expect(find.text('مسودتك'), findsOneWidget);
    expect(find.text('انت اللي تبعتها'), findsOneWidget);
    expect(find.byIcon(Icons.send_rounded), findsNothing);
    expectUrgentButton();
    await tester.enterText(find.byType(TextField), 'رسالتي المعدّلة');
    await tapAndSettle(tester, find.text('نسخ الرسالة'));
    expect(clipboard.text, 'رسالتي المعدّلة');
    expect(find.text('تم النسخ'), findsOneWidget);
  });

  testWidgets('Question chips show while the API works', (tester) async {
    await pumpApp(tester, apiDelay: const Duration(seconds: 3));
    await agree(tester);
    await tester.enterText(find.byType(TextField), 'تعبانة من الدراسة');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('إرسال'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('شن أكثر حاجة تتعبك هالأيام؟'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.textContaining('شايل حمل كبير'), findsOneWidget);
  });

  testWidgets('urgent: true goes to the urgent screen and shows no AI text', (
    tester,
  ) async {
    await pumpApp(tester);
    await agree(tester);
    await sendChat(tester, 'خلاص نبي نموت');

    expect(find.text('سلامتك أهم حاجة توا'), findsOneWidget);
    expect(find.textContaining('قول لحد قريب منك توا'), findsOneWidget);
    expect(find.text('اعرض لي خيارات الدعم'), findsNothing);

    // Back lands on a fresh chat: no AI text can be reached.
    await tapAndSettle(tester, find.byTooltip('رجوع'));
    expect(find.text('خلينا نبدأ ببساطة.'), findsOneWidget);
    expect(find.textContaining('شايل حمل كبير'), findsNothing);
  });

  testWidgets('🆘 opens the urgent screen; no unverified numbers are shown', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.byType(UrgentButton));

    expect(find.text('سلامتك أهم حاجة توا'), findsOneWidget);
    await scrollTo(tester, find.textContaining('ما قدرناش نتأكد من أي رقم'));
    expect(find.textContaining('ما قدرناش نتأكد من أي رقم'), findsOneWidget);
    expect(find.byIcon(Icons.call_rounded), findsNothing);

    // Tapping 🆘 again on the urgent screen doesn't stack another copy.
    await tapAndSettle(tester, find.byType(UrgentButton));
    await tapAndSettle(tester, find.byTooltip('رجوع'));
    expect(find.text('التزامنا معاك.'), findsOneWidget);
  });

  testWidgets('Demo builds list labelled demo numbers; Call opens the dialer', (
    tester,
  ) async {
    await pumpApp(tester, showDemoContacts: true);
    await tapAndSettle(tester, find.byType(UrgentButton));

    await scrollTo(tester, find.text('الإسعاف'));
    expect(find.text('خط الدعم النفسي'), findsOneWidget);
    expect(find.text('رقم تجريبي – مش حقيقي'), findsNWidgets(2));

    await tapAndSettle(tester, find.text('اتصل').first);
    expect(dialer.dialed, '0000000001');

    // The fixed "I need you" message can be copied.
    await tapAndSettle(tester, find.text('انسخ الرسالة'));
    expect(clipboard.text, 'أنا مش كويس توا ومحتاجك. تقدر تجيني أو تكلمني؟');
  });

  testWidgets('Language toggle switches to English and LTR', (tester) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.text('English'));

    expect(find.text('Our commitment to you.'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Our commitment to you.'))),
      TextDirection.ltr,
    );
  });
}
