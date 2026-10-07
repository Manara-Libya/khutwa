import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../privacy/domain/entities/redaction_result.dart';
import '../../../privacy/presentation/providers/privacy_repository_provider.dart';
import 'analysis_repository_provider.dart';
import 'conversation_session.dart';
import 'conversation_state.dart';

/// The chat. Every message is redacted on the device first (#53); the API
/// only ever receives the [RedactionResult].
class ConversationNotifier extends Notifier<ConversationState>
    implements ConversationSession {
  RedactionResult? _lastSent;

  @override
  ConversationState build() => const ConversationState();

  @override
  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.waiting) return;

    final RedactionResult redaction;
    try {
      redaction = await ref.read(redactorProvider).redact(trimmed);
    } on Object {
      // Redaction failed on the phone: send nothing.
      if (ref.mounted) state = state.copyWith(failed: true);
      return;
    }
    if (!ref.mounted) return;

    _lastSent = redaction;
    state = state.copyWith(
      entries: [
        ...state.entries,
        SentEntry(original: trimmed, redacted: redaction.redacted),
      ],
    );
    await _analyze(redaction);
  }

  @override
  Future<void> retry() async {
    final redaction = _lastSent;
    if (redaction == null || state.waiting) return;
    await _analyze(redaction);
  }

  Future<void> _analyze(RedactionResult redaction) async {
    state = state.copyWith(waiting: true, failed: false);
    try {
      final result = await ref
          .read(analysisRepositoryProvider)
          .analyze(redaction);
      if (!ref.mounted) return;
      state = state.copyWith(
        waiting: false,
        latest: result,
        // Urgent: no AI text is added, ever.
        entries: result.isUrgent || result.reflection == null
            ? state.entries
            : [...state.entries, ReplyEntry(result.reflection!)],
      );
    } on Object {
      if (ref.mounted) state = state.copyWith(waiting: false, failed: true);
    }
  }
}
