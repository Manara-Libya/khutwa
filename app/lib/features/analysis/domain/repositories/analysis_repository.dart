import '../../../privacy/domain/entities/redaction_result.dart';
import '../entities/analysis_result.dart';

abstract interface class AnalysisRepository {
  /// Sends `redaction.redacted` (never `original`) for risk check, reflection
  /// and suggestions. Takes a [RedactionResult], never a String (#53 rule 1).
  ///
  /// Throws `AppFailure` on network or server problems.
  Future<AnalysisResult> analyze(RedactionResult redaction);
}
