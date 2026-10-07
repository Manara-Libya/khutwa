import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/platform_providers.dart';
import 'message_draft_session.dart';

/// State: whether the draft has been copied.
class MessageDraftNotifier extends Notifier<bool>
    implements MessageDraftSession {
  @override
  bool build() => false;

  @override
  Future<void> copy(String text) async {
    // Clipboard only: never an intent that sends the message (#54).
    await ref.read(clipboardServiceProvider).copy(text);
    if (ref.mounted) state = true;
  }
}
