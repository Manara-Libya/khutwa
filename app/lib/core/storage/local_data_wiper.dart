import 'package:shared_preferences/shared_preferences.dart';

/// One-tap "delete everything" (#53, #55): the plan, drafts, any cached text
/// and preferences. Dart counterpart of the Kotlin `LocalDataWiper`.
abstract interface class LocalDataWiper {
  Future<void> deleteEverything();
}

/// Clears everything the app keeps in on-device storage (DataStore).
/// In-memory state is reset by the caller.
class PrefsLocalDataWiper implements LocalDataWiper {
  PrefsLocalDataWiper([SharedPreferencesAsync? prefs])
    : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  @override
  Future<void> deleteEverything() => _prefs.clear();
}
