import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../domain/entities/redaction_result.dart';
import 'redaction_segments.dart';

/// The user's original text. Removed parts are highlighted; every word can
/// be tapped to hide it, and every removed part to restore it.
class TappableOriginalText extends StatelessWidget {
  const TappableOriginalText({
    super.key,
    required this.result,
    required this.onToggle,
  });

  final RedactionResult result;
  final void Function(int start, int end) onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = context.textStyles.bodyLarge;
    final text = result.original;

    InlineSpan tappable(RedactionSegment s, {required bool removed}) =>
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Semantics(
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () => onToggle(s.start, s.end),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                decoration: removed
                    ? BoxDecoration(
                        color: AppColors.urgent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      )
                    : null,
                child: Text(
                  text.substring(s.start, s.end),
                  style: removed
                      ? base?.copyWith(
                          color: AppColors.urgent,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.urgent,
                        )
                      : base,
                ),
              ),
            ),
          ),
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Text.rich(
        TextSpan(
          children: segmentsOf(result)
              .map(
                (s) => switch (s) {
                  RemovedSegment() => tappable(s, removed: true),
                  WordSegment() => tappable(s, removed: false),
                  GapSegment() => TextSpan(
                    text: text.substring(s.start, s.end),
                    style: base,
                  ),
                },
              )
              .toList(),
        ),
      ),
    );
  }
}
