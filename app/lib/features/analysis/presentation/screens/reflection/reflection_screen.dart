import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_screen_body.dart';
import 'widgets/question_chips.dart';
import 'widgets/reflection_text_card.dart';

enum ReflectionStatus { loading, ready, failed }

class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({
    super.key,
    required this.status,
    required this.reflection,
    required this.onSeeOptions,
    required this.onRetry,
    required this.onBack,
  });

  final ReflectionStatus status;

  /// Shown when [status] is ready.
  final String? reflection;
  final VoidCallback onSeeOptions;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = context.textStyles;
    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            spacing: 12,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ...switch (status) {
                      ReflectionStatus.loading => [
                        Row(
                          spacing: 12,
                          children: [
                            const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                l10n.reflectionWaiting,
                                style: text.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const QuestionChips(),
                      ],
                      ReflectionStatus.ready => [
                        ReflectionTextCard(text: reflection ?? ''),
                      ],
                      ReflectionStatus.failed => [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 48,
                          color: context.colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.analysisErrorTitle,
                          textAlign: TextAlign.center,
                          style: text.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.analysisErrorBody,
                          textAlign: TextAlign.center,
                          style: text.bodyLarge?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    },
                  ],
                ),
              ),
              switch (status) {
                ReflectionStatus.loading => const SizedBox.shrink(),
                ReflectionStatus.ready => AppButton(
                  label: l10n.reflectionSeeSuggestions,
                  onPressed: onSeeOptions,
                ),
                ReflectionStatus.failed => AppButton(
                  label: l10n.retry,
                  icon: Icons.refresh_rounded,
                  onPressed: onRetry,
                ),
              },
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
