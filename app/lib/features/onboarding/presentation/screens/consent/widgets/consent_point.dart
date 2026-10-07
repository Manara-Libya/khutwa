import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';

/// One line of the consent text, with a small leading icon.
class ConsentPoint extends StatelessWidget {
  const ConsentPoint({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Icon(icon, size: 20, color: context.colors.onSurface),
        ),
        Expanded(child: Text(text, style: context.textStyles.bodyMedium)),
      ],
    );
  }
}
