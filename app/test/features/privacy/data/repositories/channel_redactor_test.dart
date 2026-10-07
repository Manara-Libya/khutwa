import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/privacy/data/repositories/channel_redactor.dart';
import 'package:khutwa_app/features/privacy/domain/entities/redaction_result.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('ly.manara.khutwa/redactor');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          // Mimics the Kotlin side: one NAME span over "Salma".
          return {
            'original': 'I am Salma',
            'spans': [
              {'start': 5, 'end': 10, 'type': 'NAME'},
            ],
          };
        });
  });

  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  test('redact sends the text and maps the Kotlin result', () async {
    final result = await const ChannelRedactor().redact('I am Salma');

    expect(calls.single.method, 'redact');
    expect(calls.single.arguments, {'text': 'I am Salma'});
    expect(result.spans.single, const Span(5, 10, IdentifierType.name));
    expect(result.redacted, 'I am [اسم1]');
  });

  test('toggle sends the current spans with Kotlin enum names', () async {
    await const ChannelRedactor().toggle(
      const RedactionResult('I am Salma', [Span(0, 1, IdentifierType.hidden)]),
      5,
      10,
    );

    expect(calls.single.method, 'toggle');
    expect(calls.single.arguments, {
      'original': 'I am Salma',
      'spans': [
        {'start': 0, 'end': 1, 'type': 'HIDDEN'},
      ],
      'start': 5,
      'end': 10,
    });
  });
}
