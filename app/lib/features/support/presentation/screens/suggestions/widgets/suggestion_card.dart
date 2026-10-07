import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../app/l10n/l10n.dart';
import '../../../../../../utilities/app_option_card.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    super.key,
    required this.title,
    required this.description,
    required this.why,
    required this.icon,
    required this.selected,
    required this.whyVisible,
    required this.onTap,
    required this.onToggleWhy,
  });

  final String title;
  final String description;
  final String why;
  final IconData icon;
  final bool selected;
  final bool whyVisible;
  final VoidCallback onTap;
  final VoidCallback onToggleWhy;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final colors = context.colors;
    return AppOptionCard(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 14,
            children: [
              AppIconBadge(icon: icon),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    Text(
                      description,
                      style: text.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppSelectionIndicator(selected: selected),
            ],
          ),
          TextButton.icon(
            onPressed: onToggleWhy,
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
              padding: EdgeInsets.zero,
              textStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            icon: Icon(
              whyVisible
                  ? Icons.expand_less_rounded
                  : Icons.help_outline_rounded,
              size: 20,
            ),
            label: Text(context.l10n.suggestionsWhy),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: AlignmentDirectional.topStart,
            child: whyVisible
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(why, style: text.bodyMedium),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
