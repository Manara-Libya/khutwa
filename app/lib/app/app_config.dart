/// Build-time configuration, passed with
/// `flutter run --dart-define-from-file=config/khutwa.local.json`.
/// That file is git-ignored: the API URL and key are never committed (#54).
/// See config/khutwa.example.json.
abstract final class AppConfig {
  static const apiUrl = String.fromEnvironment('KHUTWA_API_URL');
  static const apiKey = String.fromEnvironment('KHUTWA_API_KEY');

  /// Without a URL and key the app uses the offline mock API.
  static bool get useMockApi => apiUrl.isEmpty || apiKey.isEmpty;
}
