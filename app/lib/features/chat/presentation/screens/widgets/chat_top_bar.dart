import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_mascot.dart';
import '../../../../urgent_help/presentation/screens/urgent_help/widgets/urgent_button.dart';

/// Top Bar widget containing Logo (Mascot), Name, and Urgent Button.
class ChatTopBar extends StatelessWidget {
  const ChatTopBar({super.key, required this.onUrgentPressed});

  final VoidCallback onUrgentPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.bottomCenter,
          child: const AppMascot(size: 38),
        ),
        const SizedBox(width: 12),
        Text(
          context.l10n.appName,
          style: context.textStyles.titleLarge?.copyWith(color: Colors.white),
        ),
        const Spacer(),
        UrgentButton(onPressed: onUrgentPressed),
      ],
    );
  }
}
