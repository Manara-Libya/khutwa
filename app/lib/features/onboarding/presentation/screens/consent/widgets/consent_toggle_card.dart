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
      color: context.colors.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
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
