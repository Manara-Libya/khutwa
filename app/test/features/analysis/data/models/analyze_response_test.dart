import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/core/failure/app_failure.dart';
import 'package:khutwa_app/features/analysis/data/models/analyze_response.dart';
import 'package:khutwa_app/features/analysis/domain/entities/support_type.dart';

void main() {
  Map<String, Object?> body({
    bool urgent = false,
    String risk = 'none',
    Object? suggestions,
  }) => {
    'urgent': urgent,
    'risk': risk,
    'reflection': 'reflection text',
    'situation': ['study_pressure'],
    'suggestions':
        suggestions ??
        [
          {'type': 'specialist', 'why': 'why', 'draft': 'draft'},
          {'type': 'trusted_friend', 'why': 'w2', 'draft': 'd2'},
        ],
    'fallback': false,
    'elapsed_ms': 3200,
  };

  test('parses AnalyzeOut', () {
    final result = AnalyzeResponse.fromJson(body());
    expect(result.isUrgent, isFalse);
    expect(result.reflection, 'reflection text');
    expect(result.suggestions.map((s) => s.type), [
      SupportType.specialist,
      SupportType.trustedFriend,
    ]);
  });

  test('urgent: true drops any AI text', () {
    final result = AnalyzeResponse.fromJson(body(urgent: true, risk: 'high'));
    expect(result.isUrgent, isTrue);
    expect(result.reflection, isNull);
    expect(result.suggestions, isEmpty);
  });

  test('any risk other than "none" is urgent, even if urgent is false', () {
    for (final risk in ['possible', 'high', 'unknown']) {
      final result = AnalyzeResponse.fromJson(body(risk: risk));
      expect(result.isUrgent, isTrue, reason: risk);
      expect(result.reflection, isNull, reason: risk);
    }
  });

  test('skips unknown support types and caps at three', () {
    final result = AnalyzeResponse.fromJson(
      body(
        suggestions: [
          {'type': 'astrologer', 'why': 'x', 'draft': 'x'},
          {'type': 'specialist', 'why': 'x', 'draft': 'x'},
          {'type': 'trusted_friend', 'why': 'x', 'draft': 'x'},
          {'type': 'trusted_relative', 'why': 'x', 'draft': 'x'},
          {'type': 'community_figure', 'why': 'x', 'draft': 'x'},
        ],
      ),
    );
    expect(result.suggestions.map((s) => s.type), [
      SupportType.specialist,
      SupportType.trustedFriend,
      SupportType.trustedRelative,
    ]);
  });

  test('malformed responses fail with invalidResponse', () {
    expect(
      () => AnalyzeResponse.fromJson({'reflection': 'x'}),
      throwsA(
        isA<AppFailure>().having(
          (f) => f.kind,
          'kind',
          FailureKind.invalidResponse,
        ),
      ),
    );
  });
}
