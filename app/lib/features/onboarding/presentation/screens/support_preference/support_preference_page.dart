import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../domain/entities/user_profile.dart';
import '../../providers/onboarding_repository_provider.dart';
import 'support_preference_screen.dart';

class SupportPreferencePage extends ConsumerWidget {
  const SupportPreferencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> select(SupportStyle style) async {
      final session = ref.read(onboardingProvider.notifier);
      session.selectSupportStyle(style);
      await session.complete();
      if (context.mounted) context.go(AppRoutes.chat);
    }

    return SupportPreferenceScreen(onSelect: select, onBack: context.pop);
  }
}
