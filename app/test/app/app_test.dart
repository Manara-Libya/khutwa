import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:khutwa_app/app/app.dart';
import 'package:khutwa_app/app/app_routes.dart';
import 'package:khutwa_app/app/bootstrap.dart';
import 'package:khutwa_app/core/platform/clipboard_service.dart';
import 'package:khutwa_app/core/platform/phone_dialer.dart';
import 'package:khutwa_app/core/platform/platform_providers.dart';
import 'package:khutwa_app/features/analysis/data/repositories/mock_analysis_repository.dart';
import 'package:khutwa_app/features/analysis/domain/entities/analysis_result.dart';
import 'package:khutwa_app/features/analysis/domain/repositories/analysis_repository.dart';
import 'package:khutwa_app/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:khutwa_app/features/privacy/domain/entities/redaction_result.dart';
import 'package:khutwa_app/features/privacy/presentation/screens/privacy_panel/widgets/outgoing_text_box.dart';
import 'package:khutwa_app/features/urgent_help/presentation/screens/urgent_help/widgets/urgent_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

class _FakeClipboard implements ClipboardService {
  String? text;

  @override
  Future<void> copy(String value) async => text = value;
}

class _FakePhoneDialer implements PhoneDialer {
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
  late _FakePhoneDialer dialer;
  late _RecordingAnalysisRepository api;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    Locale locale = const Locale('ar'),
    Duration apiDelay = Duration.zero,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.localesTestValue = [locale];
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    clipboard = _FakeClipboard();
    dialer = _FakePhoneDialer();
    api = _RecordingAnalysisRepository(apiDelay);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...appOverrides(useKotlinRedactor: false, analysisRepository: api),
          chatReplyDelayProvider.overrideWithValue(Duration.zero),
          clipboardServiceProvider.overrideWithValue(clipboard),
          phoneDialerProvider.overrideWithValue(dialer),
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

  Future<void> sendChat(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
  }

  /// Goes straight to the write screen (consent is covered by its own test).
  Future<void> openWrite(WidgetTester tester) async {
    tester.element(find.byType(Scaffold).first).go(AppRoutes.write);
    await tester.pumpAndSettle();
  }

  /// Writes [text] and opens the privacy panel.
  Future<void> writeAndReview(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    // Let the button finish animating from disabled to enabled.
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.text('شوف شن اللي بيطلع'));
  }

  testWidgets('Demo path (#54): consent → write → privacy → reflection → '
      'options → draft → saved plan (#55)', (tester) async {
    await pumpApp(tester);
    expect(
      Directionality.of(tester.element(find.text('خطوة'))),
      TextDirection.rtl,
    );

    // Consent: «أوافق، نبدأ» stays disabled until every box is checked.
    await tapAndSettle(tester, find.byIcon(Icons.arrow_forward_rounded));
    expect(find.text('قبل أن نبدأ'), findsOneWidget);
    expect(find.text('أنا ذكاء اصطناعي، مش إنسان.'), findsOneWidget);
    expectUrgentButton();
    await tester.tap(find.text('أوافق، نبدأ'));
    await tester.pumpAndSettle();
    expect(find.text('قبل أن نبدأ'), findsOneWidget);
    for (final label in [
      'عمري 13 عامًا أو أكثر',
      'أفهم أن خطوة لا تغني عن المختصين أو خدمات الطوارئ',
      'أوافق على شروط الخدمة وسياسة الخصوصية',
    ]) {
      final finder = find.text(label, findRichText: true);
      await tester.scrollUntilVisible(
        finder,
        80,
        scrollable: find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
      );
      await tapAndSettle(tester, finder);
    }
    await tapAndSettle(tester, find.text('أوافق، نبدأ'));

    // Write: nothing is sent from here.
    expect(find.text('شن اللي في بالك؟'), findsOneWidget);
    expectUrgentButton();
    await writeAndReview(tester, 'انا سلمى ودايما مضغوطة من الامتحانات');
    expect(api.sent, isEmpty);

    // Privacy panel: tapping a word hides it in what will be sent.
    expect(find.text('قبل ما نبعتو'), findsOneWidget);
    expect(
      find.text('الحذف ما يقدرش يشيل كل شي، والسياق ممكن يعرّف بيك'),
      findsOneWidget,
    );
    expectUrgentButton();
    await tapAndSettle(tester, find.text('سلمى'));
    final outgoing = tester
        .widget<OutgoingTextBox>(find.byType(OutgoingTextBox))
        .text;
    expect(outgoing, 'انا [مخفي] ودايما مضغوطة من الامتحانات');
    expect(api.sent, isEmpty);

    // Send: the API receives only the redacted text.
    await tapAndSettle(tester, find.text('ابعت'));
    expect(api.sent.single.redacted, outgoing);
    expect(find.text('ما فهمته منك'), findsOneWidget);
    expectUrgentButton();

    // Support options: Arabic labels and the "why" line; the user taps one.
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
    // Wait for the "copied" snackbar to leave the bottom buttons.
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Saved plan (#55): chosen type, edited draft, coping cards.
    await tapAndSettle(tester, find.text('احفظ في خطتي'));
    expect(find.text('خطتي'), findsWidgets);
    expect(find.text('أخصائي'), findsOneWidget);
    expect(find.text('رسالتي المعدّلة'), findsOneWidget);
    expect(find.text('تنفّس ببطء'), findsOneWidget);
    expectUrgentButton();
    expect(await SharedPreferencesAsync().getKeys(), isNotEmpty);

    // Delete everything: confirm, then nothing is left in storage.
    // `.first`: the page's list; the SelectableText draft has its own.
    await tester.scrollUntilVisible(
      find.text('امسح كل شي'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tapAndSettle(tester, find.text('امسح كل شي'));
    await tapAndSettle(tester, find.text('امسح'));
    expect(await SharedPreferencesAsync().getKeys(), isEmpty);
    expect(find.text('خطوة'), findsOneWidget);
  });

  testWidgets('Question chips show while the API works', (tester) async {
    await pumpApp(tester, apiDelay: const Duration(seconds: 3));
    await openWrite(tester);
    await writeAndReview(tester, 'تعبانة من الدراسة');
    await tester.tap(find.text('ابعت'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('قاعدين نقروا كلامك…'), findsOneWidget);
    expect(find.text('شن أكثر حاجة تتعبك هالأيام؟'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('ما فهمته منك'), findsOneWidget);
  });

  testWidgets('urgent: true goes to the urgent screen and shows no AI text', (
    tester,
  ) async {
    await pumpApp(tester);
    await openWrite(tester);
    await writeAndReview(tester, 'خلاص نبي نموت');
    await tapAndSettle(tester, find.text('ابعت'));

    expect(find.text('محتاج مساعدة توا؟'), findsOneWidget);
    expect(find.text('قول لشخص قريب منك توا.'), findsOneWidget);
    expect(find.text('ما فهمته منك'), findsNothing);
    expect(find.text('اعرض لي خيارات الدعم'), findsNothing);

    // Back can't reach any AI text either: the stack holds only this screen.
    await tapAndSettle(tester, find.byTooltip('رجوع'));
    expect(find.text('شن اللي في بالك؟'), findsOneWidget);
  });

  testWidgets('🆘 opens the urgent screen; no unverified numbers are shown', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.byType(UrgentButton));

    expect(find.text('محتاج مساعدة توا؟'), findsOneWidget);
    expect(find.text('امشي لأقرب قسم طوارئ في مستشفى.'), findsOneWidget);
    // #62 hasn't verified any number yet, so step 3 is hidden.
    expect(find.text('أرقام تم التحقق منها'), findsNothing);
    expect(find.byIcon(Icons.call_rounded), findsNothing);

    // Tapping 🆘 again on the urgent screen doesn't stack another copy.
    await tapAndSettle(tester, find.byType(UrgentButton));
    await tapAndSettle(tester, find.byTooltip('رجوع'));
    expect(find.text('خطوة'), findsOneWidget);
  });

  testWidgets(
    '"I need help" shows A2UI help cards; specialist leads to a draft',
    (tester) async {
      await pumpApp(tester);
      tester.element(find.byType(Scaffold).first).go(AppRoutes.chat);
      await tester.pumpAndSettle();

      await sendChat(tester, 'أحتاج إلى مساعدة');

      // The recommended card comes first, with its badge.
      expect(find.text('⭐ الخيار الموصى به'), findsOneWidget);
      final titles = [
        'التواصل مع مختص',
        'التحدث مع شخص تثق به',
        'تمرين تهدئة الآن',
      ].map((t) => tester.getTopLeft(find.text(t)).dy).toList();
      expect(titles, orderedEquals([...titles]..sort()));

      await tapAndSettle(tester, find.text('تواصل مع مختص'));
      expect(find.text('مسودتك'), findsOneWidget);
      final draft = tester
          .widget<TextField>(find.byType(TextField))
          .controller!
          .text;
      expect(draft, contains('استشارة نفسية'));
    },
  );

  testWidgets('Language toggle switches to English and LTR', (tester) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.text('English'));

    expect(find.text('Khutwa'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Khutwa'))),
      TextDirection.ltr,
    );
    await tapAndSettle(tester, find.byIcon(Icons.arrow_forward_rounded));
    expect(find.text('Before we start'), findsOneWidget);
  });
}
