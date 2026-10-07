/// Normalizes Arabic/English text for keyword matching: lower-cases, unifies
/// alef/teh-marbuta/yeh variants and strips diacritics.
abstract final class TextNormalizer {
  static final _alef = RegExp('[أإآ]');
  static final _diacritics = RegExp('[ً-ْ]');

  static String forMatching(String input) => input
      .toLowerCase()
      .replaceAll(_alef, 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(_diacritics, '');
}
