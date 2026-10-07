import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../providers/urgent_help_repository_provider.dart';
import 'urgent_help_screen.dart';

/// Opens the urgent screen from anywhere (the 🆘 button, `urgent: true`).
/// Does nothing if it is already showing.
void showUrgentHelp(BuildContext context) {
  final router = GoRouter.of(context);
  // `last` sees pushed routes too; `uri` only reflects the base location.
  final current = router.routerDelegate.currentConfiguration;
  if (current.isNotEmpty && current.last.matchedLocation == AppRoutes.urgent) {
    return;
  }
  router.push(AppRoutes.urgent);
}

class UrgentHelpPage extends ConsumerWidget {
  const UrgentHelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    return UrgentHelpScreen(
      contacts: ref.watch(urgentHelpProvider),
      verifiedOnLabel: (date) => DateFormat.yMMMMd(locale).format(date),
      onCall: (contact) async {
        final messenger = ScaffoldMessenger.of(context);
        final failed = context.l10n.urgentCallFailed(contact.number);
        final ok = await ref.read(urgentHelpProvider.notifier).call(contact);
        if (!ok) messenger.showSnackBar(SnackBar(content: Text(failed)));
      },
      // After `urgent: true` the stack holds only this screen.
      onBack: () =>
          context.canPop() ? context.pop() : context.go(AppRoutes.write),
    );
  }
}
