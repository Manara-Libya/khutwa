import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../plan/presentation/providers/plan_repository_provider.dart';
import 'write_controller.dart';
import 'write_screen.dart';
import 'write_validators.dart';

class WritePage extends ConsumerStatefulWidget {
  const WritePage({super.key});

  @override
  ConsumerState<WritePage> createState() => _WritePageState();
}

class _WritePageState extends ConsumerState<WritePage> {
  WriteController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= WriteController(
      validator: WriteValidators.text(context.l10n),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _next() {
    final text = _controller!.submit();
    if (text == null) return;
    FocusScope.of(context).unfocus();
    // Next stop is the privacy panel; nothing is sent from here.
    context.push(AppRoutes.privacyPanel, extra: text);
  }

  @override
  Widget build(BuildContext context) {
    final hasPlan = ref.watch(planProvider).value != null;
    return WriteScreen(
      textController: _controller!.text,
      error: _controller!.error,
      hasPlan: hasPlan,
      onNext: _next,
      onOpenPlan: () => context.push(AppRoutes.plan),
    );
  }
}
