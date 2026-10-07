import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../utilities/app_option_card.dart';

class SupportPreferenceCard extends StatelessWidget {
  const SupportPreferenceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return AppOptionCard(
      elevated: true,
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleLarge),
                Text(
                  description,
                  style: text.bodyLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppIconBadge(icon: icon, size: 88),
        ],
      ),
    );
  }
}
