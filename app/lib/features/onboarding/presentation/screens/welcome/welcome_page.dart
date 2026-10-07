import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/locale_provider.dart';
import 'welcome_screen.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WelcomeScreen(
      onNext: () => context.push(AppRoutes.consent),
      onToggleLanguage: () => ref
          .read(localeProvider.notifier)
          .toggle(Localizations.localeOf(context)),
    );
  }
}
