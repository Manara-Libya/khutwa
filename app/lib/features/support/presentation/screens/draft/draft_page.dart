import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/l10n/l10n.dart';
import '../../../../onboarding/presentation/providers/onboarding_repository_provider.dart';
import '../../../domain/entities/draft_request.dart';
import '../../support_l10n.dart';
import '../../providers/support_repository_provider.dart';
import 'draft_controller.dart';
import 'draft_screen.dart';

class DraftPage extends ConsumerStatefulWidget {
  const DraftPage({super.key, required this.request});

  final DraftRequest request;

  @override
  ConsumerState<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends ConsumerState<DraftPage> {
  DraftController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nickname = ref.read(profileRepositoryProvider).read()?.nickname ?? '';
    _controller ??= DraftController(
      session: ref.read(draftProvider.notifier),
      original: context.l10n.draft(
        widget.request.kind,
        widget.request.reflection,
        nickname,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    final messenger = ScaffoldMessenger.of(context);
    final copied = context.l10n.draftCopied;
    await _controller!.copy();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(copied)));
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the draft session alive while this page is shown.
    ref.watch(draftProvider);
    return DraftScreen(
      textController: _controller!.text,
      onCopy: _copy,
      onReset: _controller!.reset,
      onBack: context.pop,
    );
  }
}
