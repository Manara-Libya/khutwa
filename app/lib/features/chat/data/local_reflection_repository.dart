import '../../../core/text/text_normalizer.dart';
import '../domain/entities/reflection.dart';
import '../domain/repositories/home_repository.dart';

/// On-device, keyword-based reflection: nothing leaves the device.
/// TODO: add an LLM-backed implementation and bind it in bootstrap.
class LocalReflectionRepository implements ReflectionRepository {
  const LocalReflectionRepository();

  static const _keywords = {
    Feeling.stressed: [
      'ضغط',
      'توتر',
      'مضغوط',
      'تعب',
      'تعبان',
      'مرهق',
      'امتحان',
      'اختبار',
      'stress',
      'pressure',
      'exam',
      'tired',
      'overwhelm',
      'exhausted',
    ],
    Feeling.anxious: [
      'قلق',
      'خوف',
      'خايف',
      'خائف',
      'هلع',
      'anxious',
      'anxiety',
      'worr',
      'afraid',
      'scared',
      'panic',
      'nervous',
    ],
    Feeling.sad: [
      'حزين',
      'حزن',
      'زعلان',
      'مكتئب',
      'اكتئاب',
      'ابكي',
      'بكاء',
      'ضايق',
      'sad',
      'down',
      'depress',
      'cry',
      'upset',
      'unhappy',
    ],
    Feeling.angry: [
      'غاضب',
      'غضب',
      'معصب',
      'عصبي',
      'قهر',
      'angry',
      'mad',
      'furious',
      'annoyed',
      'frustrat',
    ],
    Feeling.lonely: [
      'وحيد',
      'وحدة',
      'لا احد',
      'ما عندي احد',
      'محد',
      'lonely',
      'alone',
      'no one',
      'nobody',
      'isolated',
    ],
  };

  @override
  Future<Reflection> reflect(List<String> answers) async {
    final text = TextNormalizer.forMatching(answers.join(' '));
    int score(List<String> words) =>
        words.where((w) => text.contains(TextNormalizer.forMatching(w))).length;

    final best = _keywords.entries
        .map((e) => (feeling: e.key, score: score(e.value)))
        .where((e) => e.score > 0)
        .fold<({Feeling feeling, int score})?>(
          null,
          (best, e) => best == null || e.score > best.score ? e : best,
        );

    return Reflection(
      topic: answers.isEmpty ? '' : answers.first,
      feeling: best?.feeling ?? Feeling.unclear,
    );
  }
}
