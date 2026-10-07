import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/locale_provider.dart';
import '../../providers/onboarding_repository_provider.dart';
import 'consent_screen.dart';

class ConsentPage extends ConsumerWidget {
  const ConsentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consent = ref.watch(onboardingProvider.select((s) => s.consent));
    final session = ref.read(onboardingProvider.notifier);

    // One switch covers the age check, the limits and the terms.
    void setAgreed(bool value) => session
      ..setAgeConfirmed(value)
      ..setUnderstandsLimits(value)
      ..setAcceptedTerms(value);

    return ConsentScreen(
      agreed: consent.isComplete,
      onAgreedChanged: setAgreed,
      // consent → chat → suggestions → draft
      onAgree: () => context.go(AppRoutes.chat),
      onToggleLanguage: () => ref
          .read(localeProvider.notifier)
          .toggle(Localizations.localeOf(context)),
    );
  }
}
