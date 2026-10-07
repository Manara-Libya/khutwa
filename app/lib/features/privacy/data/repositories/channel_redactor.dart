import 'package:flutter/services.dart';

import '../../domain/entities/redaction_result.dart';
import '../../domain/repositories/redactor.dart';

/// Calls the Kotlin `Redactor` (#53, #58) through the platform channel set up
/// in android/app/src/main/kotlin/com/example/khutwa_app/RedactorChannel.kt.
class ChannelRedactor implements Redactor {
  const ChannelRedactor();

  static const _channel = MethodChannel('ly.manara.khutwa/redactor');

  @override
  Future<RedactionResult> redact(String text) async => _fromMap(
    await _channel.invokeMapMethod<String, Object?>('redact', {'text': text}),
  );

  @override
  Future<RedactionResult> toggle(
    RedactionResult result,
    int start,
    int end,
  ) async => _fromMap(
    await _channel.invokeMapMethod<String, Object?>('toggle', {
      'original': result.original,
      'spans': result.spans
          .map(
            (s) => {'start': s.start, 'end': s.end, 'type': s.type.kotlinName},
          )
          .toList(),
      'start': start,
      'end': end,
    }),
  );

  static RedactionResult _fromMap(Map<String, Object?>? map) {
    if (map == null) throw PlatformException(code: 'redaction_failed');
    return RedactionResult(
      map['original']! as String,
      (map['spans']! as List<Object?>)
          .cast<Map<Object?, Object?>>()
          .map(
            (s) => Span(
              s['start']! as int,
              s['end']! as int,
              IdentifierType.fromKotlin(s['type']! as String),
            ),
          )
          .toList(),
    );
  }
}
