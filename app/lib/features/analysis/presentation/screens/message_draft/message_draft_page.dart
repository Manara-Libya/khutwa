import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/l10n/l10n.dart';
import '../../../domain/entities/analysis_result.dart';
import '../../analysis_l10n.dart';
import '../../providers/analysis_repository_provider.dart';
import 'message_draft_controller.dart';
import 'message_draft_screen.dart';

class MessageDraftPage extends ConsumerStatefulWidget {
  const MessageDraftPage({super.key, required this.suggestion});

  final SupportSuggestion suggestion;

  @override
  ConsumerState<MessageDraftPage> createState() => _MessageDraftPageState();
}

class _MessageDraftPageState extends ConsumerState<MessageDraftPage> {
  late final _controller = MessageDraftController(
    session: ref.read(messageDraftProvider.notifier),
    draft: widget.suggestion.draft,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    final messenger = ScaffoldMessenger.of(context);
    final copied = context.l10n.draftCopied;
    await _controller.copy();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(copied)));
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the draft session alive while this page is shown.
    ref.watch(messageDraftProvider);
    return MessageDraftScreen(
      supportLabel: context.l10n.supportTypeLabel(widget.suggestion.type),
      textController: _controller.text,
      onCopy: _copy,
      onBack: context.pop,
    );
  }
}
