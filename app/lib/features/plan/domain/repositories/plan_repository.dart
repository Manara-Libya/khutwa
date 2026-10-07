import '../entities/saved_plan.dart';

/// On-device storage for the plan. Never sends anything anywhere, and never
/// needs the network.
abstract interface class PlanRepository {
  Future<SavedPlan?> load();

  Future<void> save(SavedPlan plan);
}
