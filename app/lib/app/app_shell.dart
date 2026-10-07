import 'package:flutter/material.dart';

import '../features/urgent_help/presentation/screens/urgent_help/widgets/urgent_button.dart';
import '../features/urgent_help/presentation/screens/urgent_help/urgent_help_page.dart';
import '../utilities/app_screen_body.dart';

/// Wraps every routed screen and puts the Urgent button at the end of its top
/// bar, so no screen can forget it.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppTopBarTrailing(
      trailing: UrgentButton(onPressed: () => showUrgentHelp(context)),
      child: child,
    );
  }
}
