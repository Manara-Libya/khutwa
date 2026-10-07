import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';

/// Reflection Card message widget.
class ChatReflectionCard extends StatelessWidget {
  const ChatReflectionCard({
    super.key,
    required this.text,
    required this.onSeeSuggestions,
  });

  final String text;
  final VoidCallback onSeeSuggestions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyles = context.textStyles;
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.secondary.withValues(alpha: 0.6)),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.auto_awesome_rounded, color: colors.secondary),
              Text(
                l10n.reflectionTitle,
                style: textStyles.titleMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
          Text(
            text,
            style: textStyles.bodyLarge?.copyWith(color: Colors.white),
          ),
          Text(
            l10n.reflectionDisclaimer,
            style: textStyles.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: onSeeSuggestions,
              style: FilledButton.styleFrom(
                backgroundColor: colors.secondary,
                foregroundColor: colors.primary,
              ),
              child: Text(l10n.reflectionSeeSuggestions),
            ),
          ),
        ],
      ),
    );
  }
}
