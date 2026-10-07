import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// The exact text that will leave the phone.
class OutgoingTextBox extends StatelessWidget {
  const OutgoingTextBox({super.key, required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 6,
          children: [
            Icon(Icons.upload_rounded, size: 20, color: colors.primary),
            Expanded(
              child: Text(
                label,
                style: context.textStyles.titleMedium?.copyWith(
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondarySoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.secondary),
          ),
          child: SelectableText(text, style: context.textStyles.bodyLarge),
        ),
      ],
    );
  }
}
