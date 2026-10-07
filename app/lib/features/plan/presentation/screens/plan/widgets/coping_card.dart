import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../utilities/app_option_card.dart';

/// A fixed coping card (#62).
class CopingCard extends StatelessWidget {
  const CopingCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        spacing: 14,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(icon: icon, size: 40),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.titleMedium),
                Text(body, style: context.textStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
