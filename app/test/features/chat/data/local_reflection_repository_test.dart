import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/chat/data/local_reflection_repository.dart';
import 'package:khutwa_app/features/chat/domain/entities/reflection.dart';

void main() {
  const repository = LocalReflectionRepository();

  Future<Feeling> feelingOf(List<String> answers) async =>
      (await repository.reflect(answers)).feeling;

  test('detects feelings in Arabic and English', () async {
    expect(await feelingOf(['الدراسة', 'أشعر بضغط']), Feeling.stressed);
    expect(await feelingOf(['work', 'I feel so alone']), Feeling.lonely);
    expect(await feelingOf(['المدرسة', 'أنا حزين']), Feeling.sad);
    expect(await feelingOf(['school', 'I am worried']), Feeling.anxious);
  });

  test('falls back to unclear when nothing matches', () async {
    expect(await feelingOf(['work', 'nothing much']), Feeling.unclear);
  });

  test('topic is the first answer', () async {
    final reflection = await repository.reflect(['الدراسة', 'الألعاب', 'قلق']);
    expect(reflection.topic, 'الدراسة');
  });
}
