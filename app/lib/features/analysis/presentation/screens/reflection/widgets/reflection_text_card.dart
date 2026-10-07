import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../app/l10n/l10n.dart';

/// The AI's non-diagnostic reflection.
class ReflectionTextCard extends StatelessWidget {
  const ReflectionTextCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.secondary, width: 1.5),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.auto_awesome_rounded, color: colors.secondary),
              Text(l10n.reflectionTitle, style: context.textStyles.titleMedium),
            ],
          ),
          Text(text, style: context.textStyles.bodyLarge),
          Text(
            l10n.reflectionDisclaimer,
            style: context.textStyles.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
