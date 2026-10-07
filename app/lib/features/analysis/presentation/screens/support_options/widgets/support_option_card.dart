import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../app/l10n/l10n.dart';
import '../../../../../../utilities/app_option_card.dart';
import '../../../../domain/entities/support_type.dart';

/// One support option: its Arabic label and the `why` line (#54).
class SupportOptionCard extends StatelessWidget {
  const SupportOptionCard({
    super.key,
    required this.type,
    required this.label,
    required this.why,
    required this.onTap,
  });

  final SupportType type;
  final String label;
  final String why;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return AppOptionCard(
      elevated: true,
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Row(
        spacing: 14,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(icon: _icon),
          Expanded(
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: text.titleMedium),
                Text(
                  '${context.l10n.suggestionsWhy} $why',
                  style: text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // matchTextDirection: points to the end in both LTR and RTL.
          Icon(
            Icons.chevron_right_rounded,
            color: context.colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  IconData get _icon => switch (type) {
    SupportType.trustedFriend => Icons.people_alt_rounded,
    SupportType.academicAdviser => Icons.school_rounded,
    SupportType.trustedRelative => Icons.family_restroom_rounded,
    SupportType.communityFigure => Icons.diversity_3_rounded,
    SupportType.specialist => Icons.psychology_rounded,
  };
}
