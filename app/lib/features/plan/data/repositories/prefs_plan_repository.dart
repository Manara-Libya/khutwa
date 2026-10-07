import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../analysis/domain/entities/support_type.dart';
import '../../domain/entities/saved_plan.dart';
import '../../domain/repositories/plan_repository.dart';

/// Stores the plan as JSON with `SharedPreferencesAsync`, which uses
/// Jetpack DataStore on Android (#55). Cloud backup is off in the manifest.
class PrefsPlanRepository implements PlanRepository {
  PrefsPlanRepository([SharedPreferencesAsync? prefs])
    : _prefs = prefs ?? SharedPreferencesAsync();

  static const _key = 'saved_plan';

  final SharedPreferencesAsync _prefs;

  @override
  Future<SavedPlan?> load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, Object?>;
      final type = SupportType.fromApi(json['type']! as String);
      if (type == null) return null;
      return SavedPlan(
        supportType: type,
        supportLabel: json['label']! as String,
        draft: json['draft']! as String,
        savedAt: DateTime.parse(json['savedAt']! as String),
      );
    } on Object {
      // A corrupt plan is treated as no plan rather than crashing offline.
      return null;
    }
  }

  @override
  Future<void> save(SavedPlan plan) => _prefs.setString(
    _key,
    jsonEncode({
      'type': plan.supportType.apiValue,
      'label': plan.supportLabel,
      'draft': plan.draft,
      'savedAt': plan.savedAt.toIso8601String(),
    }),
  );
}
