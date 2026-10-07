import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// A labelled block of the saved plan.
class PlanSection extends StatelessWidget {
  const PlanSection({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.titleMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        child,
      ],
    );
  }
}
