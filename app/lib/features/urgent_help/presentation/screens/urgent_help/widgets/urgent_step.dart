import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// A numbered step on the urgent-help screen.
class UrgentStep extends StatelessWidget {
  const UrgentStep({
    super.key,
    required this.number,
    required this.text,
    this.child,
  });

  final int number;
  final String text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.urgent,
          foregroundColor: Colors.white,
          child: Text(
            '$number',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(text, style: context.textStyles.titleMedium),
              ),
              ?child,
            ],
          ),
        ),
      ],
    );
  }
}
