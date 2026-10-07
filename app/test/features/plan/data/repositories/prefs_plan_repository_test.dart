import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/core/storage/local_data_wiper.dart';
import 'package:khutwa_app/features/analysis/domain/entities/support_type.dart';
import 'package:khutwa_app/features/plan/data/repositories/prefs_plan_repository.dart';
import 'package:khutwa_app/features/plan/domain/entities/saved_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  final plan = SavedPlan(
    supportType: SupportType.specialist,
    supportLabel: 'أخصائي',
    draft: 'رسالتي',
    savedAt: DateTime(2026, 10, 7, 14, 30),
  );

  test('round-trips the plan', () async {
    final repo = PrefsPlanRepository();
    expect(await repo.load(), isNull);

    await repo.save(plan);
    final loaded = (await PrefsPlanRepository().load())!;

    expect(loaded.supportType, SupportType.specialist);
    expect(loaded.supportLabel, 'أخصائي');
    expect(loaded.draft, 'رسالتي');
    expect(loaded.savedAt, plan.savedAt);
  });

  test('a corrupt entry loads as no plan instead of crashing', () async {
    await SharedPreferencesAsync().setString('saved_plan', '{not json');
    expect(await PrefsPlanRepository().load(), isNull);
  });

  test('the wiper leaves nothing in storage', () async {
    await PrefsPlanRepository().save(plan);
    await PrefsLocalDataWiper().deleteEverything();

    expect(await SharedPreferencesAsync().getKeys(), isEmpty);
    expect(await PrefsPlanRepository().load(), isNull);
  });
}
