import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../providers/privacy_repository_provider.dart';
import 'privacy_panel_screen.dart';

class PrivacyPanelPage extends ConsumerWidget {
  const PrivacyPanelPage({super.key, required this.text});

  /// What the user wrote. It never leaves this screen unredacted.
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = privacyPanelProvider(text);
    final state = ref.watch(provider);
    final result = state.value;
    return PrivacyPanelScreen(
      result: result,
      failed: state.hasError,
      onToggle: ref.read(provider.notifier).toggle,
      // The API only ever receives the RedactionResult, never the raw text.
      onSend: () => context.push(AppRoutes.reflection, extra: result),
      onBack: context.pop,
    );
  }
}
