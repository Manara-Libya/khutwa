import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../utilities/app_mascot.dart';
import '../../../../../../utilities/app_option_card.dart';
import '../../../../domain/entities/user_profile.dart';

class PersonaCard extends StatelessWidget {
  const PersonaCard({
    super.key,
    required this.personality,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final Personality personality;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return AppOptionCard(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Row(
        spacing: 14,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.colors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.bottomCenter,
            child: AppMascot(size: 44, happy: personality == Personality.warm),
          ),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium),
                Text(
                  description,
                  style: text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSelectionIndicator(selected: selected),
        ],
      ),
    );
  }
}
