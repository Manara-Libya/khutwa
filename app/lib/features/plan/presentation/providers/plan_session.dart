import '../../domain/entities/saved_plan.dart';

abstract interface class PlanSession {
  Future<void> save(SavedPlan plan);

  /// Wipes the plan, drafts and any cached text from the device (#55).
  Future<void> deleteEverything();
}
