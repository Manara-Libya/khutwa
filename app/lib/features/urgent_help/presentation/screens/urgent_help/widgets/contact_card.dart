import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// One number with a big one-tap call button that opens the phone dialer.
class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.name,
    required this.number,
    required this.note,
    required this.isDemo,
    required this.callLabel,
    required this.onCall,
    this.description,
  });

  final String name;
  final String number;
  final String? description;

  /// "Verified on …", or the demo warning.
  final String note;
  final bool isDemo;
  final String callLabel;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    return Material(
      color: colors.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 14,
          children: [
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: text.titleMedium),
                  if (description case final description?)
                    Text(
                      description,
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  // Numbers read left-to-right even in Arabic.
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(number, style: text.bodyLarge),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDemo
                          ? AppColors.urgent.withValues(alpha: 0.1)
                          : AppColors.mint.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      note,
                      style: text.bodySmall?.copyWith(
                        color: isDemo ? AppColors.urgent : colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: onCall,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.urgent,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 52),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.call_rounded),
              label: Text(callLabel),
            ),
          ],
        ),
      ),
    );
  }
}
