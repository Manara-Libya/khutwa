import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// The AI's reflection: plain large text, no bubble.
class ReplyText extends StatelessWidget {
  const ReplyText({super.key, required this.text, required this.disclaimer});

  final String text;
  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 24, bottom: 20),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          Text(
            disclaimer,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
