import '../../../privacy/domain/entities/redaction_result.dart';
import 'support_type.dart';

/// One support option: who to reach out to, why, and a draft first message.
class SupportSuggestion {
  const SupportSuggestion({
    required this.type,
    required this.why,
    required this.draft,
  });

  final SupportType type;
  final String why;
  final String draft;
}

/// The result of `POST /v1/analyze` (`AnalyzeOut`).
class AnalysisResult {
  const AnalysisResult({
    required this.urgent,
    required this.risk,
    this.reflection,
    this.suggestions = const [],
    this.fallback = false,
  });

  final bool urgent;

  /// `none`, `possible`, `high` or `unknown`.
  final String risk;
  final String? reflection;
  final List<SupportSuggestion> suggestions;

  /// Approved fixed text replaced the model output.
  final bool fallback;

  /// The API says to treat any risk other than `none` as urgent, even if
  /// `urgent` were somehow false. When true, show the urgent screen only.
  bool get isUrgent => urgent || risk != 'none';

  /// The same result with the user's real names and places put back into the
  /// AI text, using the mapping that never left the phone (#58).
  AnalysisResult restoredWith(RedactionResult redaction) => AnalysisResult(
    urgent: urgent,
    risk: risk,
    fallback: fallback,
    reflection: reflection == null ? null : redaction.restore(reflection!),
    suggestions: [
      for (final s in suggestions)
        SupportSuggestion(
          type: s.type,
          why: redaction.restore(s.why),
          draft: redaction.restore(s.draft),
        ),
    ],
  );
}
