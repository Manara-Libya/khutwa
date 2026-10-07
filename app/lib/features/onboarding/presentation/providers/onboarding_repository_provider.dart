import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/profile_repository.dart';
import 'onboarding_notifier.dart';
import 'onboarding_state.dart';

/// Bound to a concrete implementation in `app/bootstrap.dart`.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => throw UnimplementedError(
    'Override profileRepositoryProvider in bootstrap',
  ),
);

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
