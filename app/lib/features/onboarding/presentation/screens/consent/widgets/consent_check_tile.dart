import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

class ConsentCheckTile extends StatelessWidget {
  const ConsentCheckTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.child,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          spacing: 4,
          children: [
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: colors.secondary,
              checkColor: Colors.white,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
