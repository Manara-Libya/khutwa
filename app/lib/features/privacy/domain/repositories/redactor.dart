import '../entities/redaction_result.dart';

/// On-device redaction (#53). Async on the Dart side because the real
/// implementation runs in Kotlin behind a platform channel.
abstract interface class Redactor {
  /// Automatic pass: patterns, Libyan name/place lists, kin phrases.
  Future<RedactionResult> redact(String text);

  /// Tap-to-hide: a visible word gets a HIDDEN span; tapping a removed part
  /// removes its span and restores the original text.
  Future<RedactionResult> toggle(RedactionResult result, int start, int end);
}
