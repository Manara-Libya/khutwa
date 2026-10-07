import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../core/platform/platform_providers.dart';
import '../../../../chat/presentation/providers/chat_repository_provider.dart';
import '../../../../onboarding/presentation/providers/onboarding_repository_provider.dart';
import '../../providers/plan_repository_provider.dart';
import 'plan_screen.dart';

class PlanPage extends ConsumerWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(planProvider).value;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();

    Future<void> deleteEverything() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.planDeleteConfirmTitle),
          content: Text(l10n.planDeleteConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.urgent),
              child: Text(l10n.planDeleteConfirm),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      await ref.read(planProvider.notifier).deleteEverything();
      // Also drop any text still held in memory.
      ref
        ..invalidate(onboardingProvider)
        ..invalidate(chatProvider);
      messenger.showSnackBar(SnackBar(content: Text(l10n.planDeleted)));
      if (context.mounted) context.go(AppRoutes.welcome);
    }

    return PlanScreen(
      plan: plan,
      savedOnLabel: plan == null
          ? null
          : DateFormat.yMMMMd(locale).format(plan.savedAt),
      onCopyDraft: () async {
        if (plan == null) return;
        final messenger = ScaffoldMessenger.of(context);
        await ref.read(clipboardServiceProvider).copy(plan.draft);
        messenger.showSnackBar(SnackBar(content: Text(l10n.draftCopied)));
      },
      onDeleteEverything: deleteEverything,
      onStartOver: () => context.go(AppRoutes.write),
      onBack: () =>
          context.canPop() ? context.pop() : context.go(AppRoutes.write),
    );
  }
}
