import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../app/l10n/l10n.dart';

/// The red Urgent button the app shell shows on every screen.
class UrgentButton extends StatelessWidget {
  const UrgentButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: l10n.urgentTitle,
      excludeSemantics: true,
      child: Material(
        color: AppColors.urgent,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              spacing: 6,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                Text(
                  l10n.urgentLabel,
                  style: context.textStyles.labelLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
