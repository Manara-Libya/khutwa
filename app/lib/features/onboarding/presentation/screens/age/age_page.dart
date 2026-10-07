import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../providers/onboarding_repository_provider.dart';
import 'age_screen.dart';

class AgePage extends ConsumerWidget {
  const AgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(onboardingProvider.select((s) => s.profile));
    return AgeScreen(
      nickname: profile.nickname,
      selected: profile.ageGroup,
      onSelect: ref.read(onboardingProvider.notifier).selectAge,
      onContinue: () => context.push(AppRoutes.persona),
      onBack: context.pop,
    );
  }
}
