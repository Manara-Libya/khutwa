import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/platform_providers.dart';
import 'draft_session.dart';

enum DraftStatus { editing, copied }

class DraftNotifier extends Notifier<DraftStatus> implements DraftSession {
  @override
  DraftStatus build() => DraftStatus.editing;

  @override
  Future<void> copy(String text) async {
    await ref.read(clipboardServiceProvider).copy(text);
    if (ref.mounted) state = DraftStatus.copied;
  }
}
