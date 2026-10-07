import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// A fixed "I need you" message the user copies and sends themselves.
class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.title,
    required this.message,
    required this.copyLabel,
    required this.onCopy,
  });

  final String title;
  final String message;
  final String copyLabel;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Material(
      color: context.colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
        side: BorderSide(
          color: context.colors.onSurface,
          width: AppStroke.hand,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.titleMedium),
            Text('«$message»', style: text.bodyLarge),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: OutlinedButton.icon(
                onPressed: onCopy,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  shape: const StadiumBorder(),
                ),
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(copyLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
