import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/saved_plan.dart';
import 'plan_repository_provider.dart';
import 'plan_session.dart';

/// The saved plan, or null when there is none.
class PlanNotifier extends AsyncNotifier<SavedPlan?> implements PlanSession {
  @override
  Future<SavedPlan?> build() => ref.read(planRepositoryProvider).load();

  @override
  Future<void> save(SavedPlan plan) async {
    await ref.read(planRepositoryProvider).save(plan);
    if (ref.mounted) state = AsyncData(plan);
  }

  @override
  Future<void> deleteEverything() async {
    await ref.read(localDataWiperProvider).deleteEverything();
    if (ref.mounted) state = const AsyncData(null);
  }
}
