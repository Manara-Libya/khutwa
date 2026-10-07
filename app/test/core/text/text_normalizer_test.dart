import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/core/text/text_normalizer.dart';

void main() {
  test('unifies Arabic letter variants and strips diacritics', () {
    expect(TextNormalizer.forMatching('أَنا خائفة'), 'انا خائفه');
    expect(TextNormalizer.forMatching('إلى'), 'الي');
  });

  test('lower-cases Latin text', () {
    expect(TextNormalizer.forMatching('I Feel ALONE'), 'i feel alone');
  });
}
