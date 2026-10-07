import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../providers/urgent_help_repository_provider.dart';
import 'urgent_help_screen.dart';

/// Route `extra` marking that the screen opened after `urgent: true`
/// rather than from the 🆘 button.
const urgentOpenedAutomatically = 'auto';

/// Opens the urgent screen from the 🆘 button. Does nothing if it is
/// already showing.
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
  const UrgentHelpPage({super.key, this.autoOpened = false});

  final bool autoOpened;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    final session = ref.read(urgentHelpProvider.notifier);
    return UrgentHelpScreen(
      contacts: ref.watch(urgentHelpProvider),
      autoOpened: autoOpened,
      verifiedOnLabel: (date) => DateFormat.yMMMMd(locale).format(date),
      // Opens the phone dialer with the number filled in; the user presses
      // call there.
      onCall: (contact) async {
        final messenger = ScaffoldMessenger.of(context);
        final failed = context.l10n.urgentCallFailed(contact.number);
        if (!await session.call(contact)) {
          messenger.showSnackBar(SnackBar(content: Text(failed)));
        }
      },
      onCopyMessage: () async {
        final messenger = ScaffoldMessenger.of(context);
        final l10n = context.l10n;
        await session.copyMessage(l10n.urgentMessageText);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.draftCopied)));
      },
      // After `urgent: true` the stack holds only this screen.
      onBack: () =>
          context.canPop() ? context.pop() : context.go(AppRoutes.chat),
    );
  }
}
