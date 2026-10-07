import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../privacy/domain/entities/redaction_result.dart';
import '../../domain/entities/analysis_result.dart';
import 'analysis_repository_provider.dart';
import 'analysis_session.dart';

/// Analyses the redaction the user approved in the privacy panel. This is
/// the only place the app calls the network with the user's words.
class AnalysisNotifier extends AsyncNotifier<AnalysisResult>
    implements AnalysisSession {
  AnalysisNotifier(this.redaction);

  final RedactionResult redaction;

  @override
  Future<AnalysisResult> build() =>
      ref.read(analysisRepositoryProvider).analyze(redaction);

  @override
  void retry() => ref.invalidateSelf();
}
