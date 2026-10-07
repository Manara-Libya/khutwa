import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../privacy/domain/entities/redaction_result.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/repositories/analysis_repository.dart';
import 'analysis_notifier.dart';
import 'message_draft_notifier.dart';

/// Bound in `app/bootstrap.dart`: the live API when configured, else a mock.
final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) =>
      throw UnimplementedError('Bind analysisRepositoryProvider in bootstrap'),
);

/// Keyed by the redaction the user approved.
final analysisProvider = AsyncNotifierProvider.autoDispose
    .family<AnalysisNotifier, AnalysisResult, RedactionResult>(
      AnalysisNotifier.new,
    );

final messageDraftProvider =
    NotifierProvider.autoDispose<MessageDraftNotifier, bool>(
      MessageDraftNotifier.new,
    );
