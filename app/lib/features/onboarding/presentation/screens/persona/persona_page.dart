import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../providers/onboarding_repository_provider.dart';
import 'persona_screen.dart';

class PersonaPage extends ConsumerWidget {
  const PersonaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      onboardingProvider.select((s) => s.profile.personality),
    );
    void next() => context.push(AppRoutes.supportPreference);
    return PersonaScreen(
      selected: selected,
      onSelect: ref.read(onboardingProvider.notifier).selectPersonality,
      onContinue: next,
      onSkip: next,
      onBack: context.pop,
    );
  }
}
