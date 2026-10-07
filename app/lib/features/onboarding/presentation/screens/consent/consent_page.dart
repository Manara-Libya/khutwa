import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../providers/onboarding_repository_provider.dart';
import 'consent_screen.dart';

class ConsentPage extends ConsumerWidget {
  const ConsentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consent = ref.watch(onboardingProvider.select((s) => s.consent));
    final session = ref.read(onboardingProvider.notifier);
    return ConsentScreen(
      consent: consent,
      onAgeConfirmedChanged: session.setAgeConfirmed,
      onUnderstandsLimitsChanged: session.setUnderstandsLimits,
      onAcceptedTermsChanged: session.setAcceptedTerms,
      // The demo path (#54): consent → write.
      onAgree: () => context.go(AppRoutes.write),
      onBack: context.pop,
    );
  }
}
