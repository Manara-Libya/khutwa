import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:khutwa_app/core/failure/app_failure.dart';
import 'package:khutwa_app/features/analysis/data/repositories/api_analysis_repository.dart';
import 'package:khutwa_app/features/privacy/domain/entities/redaction_result.dart';

void main() {
  const redaction = RedactionResult('انا سلمى', [
    Span(4, 8, IdentifierType.name),
  ]);

  ApiAnalysisRepository repoWith(
    MockClientHandler handler, {
    Duration timeout = const Duration(seconds: 40),
  }) => ApiAnalysisRepository(
    baseUrl: 'https://api.example.test',
    apiKey: 'test-key',
    client: MockClient(handler),
    timeout: timeout,
  );

  Matcher failure(FailureKind kind) =>
      throwsA(isA<AppFailure>().having((f) => f.kind, 'kind', kind));

  test('sends only the redacted text, with the bearer key', () async {
    late http.Request sent;
    final repo = repoWith((request) async {
      sent = request;
      return http.Response(
        jsonEncode({
          'urgent': false,
          'risk': 'none',
          'reflection': 'ok',
          'suggestions': [],
          'elapsed_ms': 1,
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    await repo.analyze(redaction);

    expect(sent.method, 'POST');
    expect(sent.url.toString(), 'https://api.example.test/v1/analyze');
    expect(sent.headers['Authorization'], 'Bearer test-key');
    expect(jsonDecode(sent.body), {'text': 'انا [اسم1]'});
    expect(sent.body, isNot(contains('سلمى')));
  });

  test('puts the real name back into the reply, on the phone', () async {
    final repo = repoWith(
      (_) async => http.Response(
        jsonEncode({
          'urgent': false,
          'risk': 'none',
          'reflection': 'شكراً يا [اسم1]',
          'suggestions': [
            {
              'type': 'trusted_friend',
              'why': 'w',
              'draft': 'يا [اسم1]، نبي نحكي معاك',
            },
          ],
          'elapsed_ms': 1,
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    );

    final result = await repo.analyze(redaction);

    expect(result.reflection, 'شكراً يا سلمى');
    expect(result.suggestions.single.draft, 'يا سلمى، نبي نحكي معاك');
  });

  test('maps 401 to unauthorized and 5xx to server', () async {
    expect(
      repoWith((_) async => http.Response('', 401)).analyze(redaction),
      failure(FailureKind.unauthorized),
    );
    expect(
      repoWith((_) async => http.Response('', 503)).analyze(redaction),
      failure(FailureKind.server),
    );
  });

  test('times out', () async {
    final repo = repoWith(
      (_) => Completer<http.Response>().future,
      timeout: const Duration(milliseconds: 10),
    );
    expect(repo.analyze(redaction), failure(FailureKind.timeout));
  });

  test('connection errors become network failures', () async {
    final repo = repoWith((_) async => throw http.ClientException('offline'));
    expect(repo.analyze(redaction), failure(FailureKind.network));
  });
}
