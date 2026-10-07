import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../providers/onboarding_repository_provider.dart';
import 'nickname_controller.dart';
import 'nickname_screen.dart';
import 'nickname_validators.dart';

class NicknamePage extends ConsumerStatefulWidget {
  const NicknamePage({super.key});

  @override
  ConsumerState<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends ConsumerState<NicknamePage> {
  NicknameController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= NicknameController(
      session: ref.read(onboardingProvider.notifier),
      validator: NicknameValidators.nickname(context.l10n),
      initialValue: ref.read(onboardingProvider).profile.nickname,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_controller!.submit()) return;
    FocusScope.of(context).unfocus();
    context.push(AppRoutes.age);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    return NicknameScreen(
      textController: controller.text,
      error: controller.error,
      onSubmit: _submit,
      onBack: context.pop,
    );
  }
}
