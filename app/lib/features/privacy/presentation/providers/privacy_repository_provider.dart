import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/redaction_result.dart';
import '../../domain/repositories/redactor.dart';
import 'privacy_panel_notifier.dart';

/// Bound to a concrete implementation in `app/bootstrap.dart`.
final redactorProvider = Provider<Redactor>(
  (ref) => throw UnimplementedError('Bind redactorProvider in bootstrap'),
);

/// Keyed by the text the user wrote.
final privacyPanelProvider = AsyncNotifierProvider.autoDispose
    .family<PrivacyPanelNotifier, RedactionResult, String>(
      PrivacyPanelNotifier.new,
    );
