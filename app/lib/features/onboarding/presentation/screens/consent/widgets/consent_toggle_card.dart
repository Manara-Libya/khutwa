import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// White card with a switch: the user's single, explicit agreement.
class ConsentToggleCard extends StatelessWidget {
  const ConsentToggleCard({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: value
          ? context.colors.primaryContainer
          : context.colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
        side: BorderSide(
          color: context.colors.onSurface,
          width: AppStroke.hand,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            spacing: 14,
            children: [
              Switch(value: value, onChanged: onChanged),
              Expanded(
                child: Text(label, style: context.textStyles.titleMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
