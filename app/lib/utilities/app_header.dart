import 'package:flutter/material.dart';

import '../app/app_theme.dart';

/// Big start-aligned title with an optional paragraph under it.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Column(
      spacing: 14,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.displaySmall),
        if (subtitle case final subtitle?)
          Text(
            subtitle,
            style: text.bodyLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
