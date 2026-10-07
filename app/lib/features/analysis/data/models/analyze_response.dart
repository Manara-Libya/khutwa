import '../../../../core/failure/app_failure.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/support_type.dart';

/// Parses the `AnalyzeOut` JSON from `POST /v1/analyze`.
abstract final class AnalyzeResponse {
  static AnalysisResult fromJson(Object? json) {
    if (json is! Map<String, Object?>) {
      throw const AppFailure(FailureKind.invalidResponse, 'not an object');
    }
    final urgent = json['urgent'];
    final risk = json['risk'];
    if (urgent is! bool || risk is! String) {
      throw const AppFailure(
        FailureKind.invalidResponse,
        'missing urgent/risk',
      );
    }
    final result = AnalysisResult(
      urgent: urgent,
      risk: risk,
      reflection: json['reflection'] as String?,
      fallback: json['fallback'] == true,
      suggestions: (json['suggestions'] as List<Object?>? ?? const [])
          .whereType<Map<String, Object?>>()
          .map(_suggestion)
          .nonNulls
          .take(3)
          .toList(),
    );
    // Safety: if urgent, drop any AI text that might have come along.
    return result.isUrgent
        ? AnalysisResult(urgent: true, risk: result.risk)
        : result;
  }

  /// Unknown support types or missing fields are skipped, not fatal.
  static SupportSuggestion? _suggestion(Map<String, Object?> json) {
    final type = SupportType.fromApi(json['type'] as String? ?? '');
    final why = json['why'], draft = json['draft'];
    if (type == null || why is! String || draft is! String) return null;
    return SupportSuggestion(type: type, why: why, draft: draft);
  }
}
