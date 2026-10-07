import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../utilities/app_option_card.dart';

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
        AppIconBadge(icon: icon, size: 36),
        Expanded(child: Text(text, style: context.textStyles.bodyMedium)),
      ],
    );
  }
}
