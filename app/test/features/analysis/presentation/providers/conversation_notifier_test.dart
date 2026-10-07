import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/core/failure/app_failure.dart';
import 'package:khutwa_app/features/analysis/data/repositories/mock_analysis_repository.dart';
import 'package:khutwa_app/features/analysis/domain/entities/analysis_result.dart';
import 'package:khutwa_app/features/analysis/domain/repositories/analysis_repository.dart';
import 'package:khutwa_app/features/analysis/presentation/providers/analysis_repository_provider.dart';
import 'package:khutwa_app/features/analysis/presentation/providers/conversation_state.dart';
import 'package:khutwa_app/features/privacy/domain/entities/redaction_result.dart';
import 'package:khutwa_app/features/privacy/domain/repositories/redactor.dart';
import 'package:khutwa_app/features/privacy/presentation/providers/privacy_repository_provider.dart';

/// Hides every "سلمى" so tests can check what is sent.
class _NameRedactor implements Redactor {
  @override
  Future<RedactionResult> redact(String text) async {
    final i = text.indexOf('سلمى');
    return RedactionResult(
      text,
      i < 0 ? const [] : [Span(i, i + 4, IdentifierType.name)],
    );
  }

  @override
  Future<RedactionResult> toggle(RedactionResult r, int s, int e) async => r;
}

class _FakeApi implements AnalysisRepository {
  _FakeApi(this.respond);

  final Future<AnalysisResult> Function() respond;
  final sent = <RedactionResult>[];

  @override
  Future<AnalysisResult> analyze(RedactionResult redaction) {
    sent.add(redaction);
    return respond();
  }
}

void main() {
  ProviderContainer containerWith(_FakeApi api) => ProviderContainer.test(
    overrides: [
      redactorProvider.overrideWithValue(_NameRedactor()),
      analysisRepositoryProvider.overrideWithValue(api),
    ],
  );

  Future<AnalysisResult> mock(String text) =>
      const MockAnalysisRepository(delay: Duration.zero)
          .analyze(RedactionResult(text, const []));

  test('sends only the redacted text and adds the reflection', () async {
    final api = _FakeApi(() => mock('ok'));
    final container = containerWith(api);
    container.listen(conversationProvider, (_, _) {});

    await container.read(conversationProvider.notifier).send('انا سلمى');

    expect(api.sent.single.redacted, 'انا [اسم]');
    final state = container.read(conversationProvider);
    final sent = state.entries.first as SentEntry;
    expect(sent.original, 'انا سلمى');
    expect(sent.wasRedacted, isTrue);
    expect(state.entries.last, isA<ReplyEntry>());
    expect(state.canShowOptions, isTrue);
  });

  test('urgent adds no AI text and offers no options', () async {
    final api = _FakeApi(() => mock('نبي نموت'));
    final container = containerWith(api);
    container.listen(conversationProvider, (_, _) {});

    await container.read(conversationProvider.notifier).send('نبي نموت');

    final state = container.read(conversationProvider);
    expect(state.latest!.isUrgent, isTrue);
    expect(state.entries.whereType<ReplyEntry>(), isEmpty);
    expect(state.canShowOptions, isFalse);
  });

  test('a failure can be retried with the same redacted text', () async {
    var calls = 0;
    final api = _FakeApi(() async {
      if (calls++ == 0) throw const AppFailure(FailureKind.network);
      return mock('ok');
    });
    final container = containerWith(api);
    container.listen(conversationProvider, (_, _) {});
    final session = container.read(conversationProvider.notifier);

    await session.send('انا سلمى');
    expect(container.read(conversationProvider).failed, isTrue);

    await session.retry();
    expect(container.read(conversationProvider).failed, isFalse);
    expect(api.sent.map((r) => r.redacted), ['انا [اسم]', 'انا [اسم]']);
  });

  test('blank messages are ignored', () async {
    final api = _FakeApi(() => mock('ok'));
    final container = containerWith(api);
    container.listen(conversationProvider, (_, _) {});

    await container.read(conversationProvider.notifier).send('   ');
    expect(api.sent, isEmpty);
  });
}
