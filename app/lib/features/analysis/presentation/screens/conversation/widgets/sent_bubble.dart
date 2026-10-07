import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// The user's message. When redaction changed it, also shows exactly what
/// left the phone.
class SentBubble extends StatelessWidget {
  const SentBubble({super.key, required this.text, required this.sentLabel});

  final String text;

  /// "What left your phone: …", or null if nothing was removed.
  final String? sentLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 48, bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.primary,
          border: Border.all(color: AppColors.onGreen, width: AppStroke.hand),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(AppRadius.lg),
            topEnd: Radius.circular(22),
            bottomStart: Radius.circular(AppRadius.lg),
            bottomEnd: Radius.circular(AppRadius.sm),
          ),
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: context.textStyles.bodyLarge?.copyWith(
                color: colors.onPrimary,
              ),
            ),
            if (sentLabel case final label?)
              Row(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: colors.onPrimary,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      label,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
