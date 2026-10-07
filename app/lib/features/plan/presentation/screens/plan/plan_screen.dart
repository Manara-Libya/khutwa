import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/saved_plan.dart';
import 'widgets/coping_card.dart';
import 'widgets/plan_section.dart';

/// The saved plan (#55). Reads only on-device data, so it opens offline.
class PlanScreen extends StatelessWidget {
  const PlanScreen({
    super.key,
    required this.plan,
    required this.savedOnLabel,
    required this.onCopyDraft,
    required this.onDeleteEverything,
    required this.onStartOver,
    required this.onBack,
  });

  /// Null when nothing is saved.
  final SavedPlan? plan;

  /// The save date, already formatted for the current locale.
  final String? savedOnLabel;
  final VoidCallback onCopyDraft;
  final VoidCallback onDeleteEverything;
  final VoidCallback onStartOver;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = context.textStyles;
    final plan = this.plan;
    final coping = [
      (Icons.air_rounded, l10n.copingBreathingTitle, l10n.copingBreathingBody),
      (
        Icons.visibility_rounded,
        l10n.copingGroundingTitle,
        l10n.copingGroundingBody,
      ),
      (
        Icons.mark_chat_unread_rounded,
        l10n.copingMessageTitle,
        l10n.copingMessageBody,
      ),
    ];

    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            0,
            AppSpacing.screenHorizontal,
            32,
          ),
          children: [
            AppHeader(title: l10n.planTitle, subtitle: l10n.planSubtitle),
            const SizedBox(height: 24),
            if (plan == null)
              Text(
                l10n.planEmpty,
                textAlign: TextAlign.center,
                style: text.bodyLarge,
              )
            else
              Column(
                spacing: 24,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (savedOnLabel case final date?)
                    Text(
                      l10n.planSavedOn(date),
                      style: text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  PlanSection(
                    label: l10n.planSupportLabel,
                    child: Text(plan.supportLabel, style: text.titleLarge),
                  ),
                  PlanSection(
                    label: l10n.planDraftLabel,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(plan.draft, style: text.bodyLarge),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton.icon(
                                onPressed: onCopyDraft,
                                icon: const Icon(Icons.copy_rounded),
                                label: Text(l10n.draftCopy),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            PlanSection(
              label: l10n.planCopingTitle,
              child: Column(
                spacing: 12,
                children: coping
                    .map((c) => CopingCard(icon: c.$1, title: c.$2, body: c.$3))
                    .toList(),
              ),
            ),
            const SizedBox(height: 32),
            Column(
              spacing: 8,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: onStartOver,
                    icon: const Icon(Icons.edit_rounded),
                    label: Text(l10n.planStartOver),
                  ),
                ),
                TextButton.icon(
                  onPressed: onDeleteEverything,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.urgent,
                  ),
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: Text(l10n.planDeleteAll),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
