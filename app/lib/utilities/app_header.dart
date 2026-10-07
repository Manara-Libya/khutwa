import 'package:flutter/material.dart';

import '../app/app_theme.dart';

/// Centered screen title with an optional subtitle.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Column(
      spacing: 14,
      children: [
        Text(title, textAlign: TextAlign.center, style: text.headlineMedium),
        if (subtitle case final subtitle?)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: text.bodyLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
