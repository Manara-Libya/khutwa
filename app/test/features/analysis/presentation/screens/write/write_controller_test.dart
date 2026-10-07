import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/analysis/presentation/screens/write/write_controller.dart';

void main() {
  late WriteController controller;

  setUp(
    () => controller = WriteController(
      validator: (v) => v.length > 12 ? 'too long' : null,
    ),
  );

  tearDown(() => controller.dispose());

  test('returns the trimmed text when valid', () {
    controller.text.text = '  rani ta3ban  ';
    expect(controller.submit(), 'rani ta3ban');
    expect(controller.error.value, isNull);
  });

  test('empty input returns null without an error', () {
    controller.text.text = '   ';
    expect(controller.hasInput, isFalse);
    expect(controller.submit(), isNull);
    expect(controller.error.value, isNull);
  });

  test('invalid input returns null and exposes the error', () {
    controller.text.text = 'way too long text';
    expect(controller.submit(), isNull);
    expect(controller.error.value, 'too long');
  });
}
