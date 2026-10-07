import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/local_data_wiper.dart';
import '../../domain/entities/saved_plan.dart';
import '../../domain/repositories/plan_repository.dart';
import 'plan_notifier.dart';

/// Bound in `app/bootstrap.dart`.
final planRepositoryProvider = Provider<PlanRepository>(
  (ref) => throw UnimplementedError('Bind planRepositoryProvider in bootstrap'),
);

/// Bound in `app/bootstrap.dart`.
final localDataWiperProvider = Provider<LocalDataWiper>(
  (ref) => throw UnimplementedError('Bind localDataWiperProvider in bootstrap'),
);

final planProvider = AsyncNotifierProvider<PlanNotifier, SavedPlan?>(
  PlanNotifier.new,
);
