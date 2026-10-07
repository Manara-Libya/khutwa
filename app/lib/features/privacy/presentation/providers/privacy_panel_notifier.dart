import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/redaction_result.dart';
import 'privacy_panel_session.dart';
import 'privacy_repository_provider.dart';

/// The redaction of [text] as the user adjusts it in the privacy panel.
/// Nothing here touches the network.
class PrivacyPanelNotifier extends AsyncNotifier<RedactionResult>
    implements PrivacyPanelSession {
  PrivacyPanelNotifier(this.text);

  final String text;

  @override
  Future<RedactionResult> build() => ref.read(redactorProvider).redact(text);

  @override
  Future<void> toggle(int start, int end) async {
    final current = state.value;
    if (current == null) return;
    final next = await ref.read(redactorProvider).toggle(current, start, end);
    if (ref.mounted) state = AsyncData(next);
  }
}
