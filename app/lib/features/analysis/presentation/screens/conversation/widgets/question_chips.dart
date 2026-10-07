import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../app/l10n/l10n.dart';

/// Gentle questions shown immediately while the API works (2–6 s, #54).
class QuestionChips extends StatelessWidget {
  const QuestionChips({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final questions = [
      l10n.reflectionQuestion1,
      l10n.reflectionQuestion2,
      l10n.reflectionQuestion3,
    ];
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reflectionQuestionsTitle,
          style: context.textStyles.titleMedium,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: questions
              .map(
                (q) => Chip(
                  label: Text(q),
                  backgroundColor: context.colors.surfaceContainer,
                  side: BorderSide(color: context.colors.outline),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
