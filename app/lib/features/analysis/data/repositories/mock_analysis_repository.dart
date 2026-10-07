import '../../../../core/text/text_normalizer.dart';
import '../../../privacy/domain/entities/redaction_result.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/support_type.dart';
import '../../domain/repositories/analysis_repository.dart';

/// Offline stand-in for `POST /v1/analyze`, used when no API URL/key is
/// configured (development and tests). Same contract as the real API:
/// it only ever sees the redacted text.
///
/// Writing a risk phrase (e.g. «نبي نموت», "kill myself") returns
/// `urgent: true` so the urgent path can be rehearsed.
class MockAnalysisRepository implements AnalysisRepository {
  const MockAnalysisRepository({this.delay = const Duration(seconds: 2)});

  final Duration delay;

  static const _riskPhrases = [
    'انتحار',
    'نموت روحي',
    'نبي نموت',
    'نقتل روحي',
    'نأذي روحي',
    'kill myself',
    'suicide',
    'end my life',
    'nmout',
    'nebi nmout',
  ];

  @override
  Future<AnalysisResult> analyze(RedactionResult redaction) async {
    await Future<void>.delayed(delay);
    final text = TextNormalizer.forMatching(redaction.redacted);
    if (_riskPhrases.any((p) => text.contains(TextNormalizer.forMatching(p)))) {
      return const AnalysisResult(urgent: true, risk: 'high');
    }
    return const AnalysisResult(
      urgent: false,
      risk: 'none',
      reflection:
          'واضح إنك شايل حمل كبير هالفترة، وإن الضغط هذا ماخذ منك برشا. '
          'إنك تكتب عليه خطوة مهمة.',
      suggestions: [
        SupportSuggestion(
          type: SupportType.specialist,
          why: 'الأخصائي يسمعك بسرية ويساعدك تلقى طريقة تتعامل بيها مع الضغط.',
          draft:
              'السلام عليكم، نبي نحجز جلسة. نحس بضغط كبير هالأيام ونبي نحكي '
              'مع مختص. شن المواعيد المتاحة؟',
        ),
        SupportSuggestion(
          type: SupportType.trustedFriend,
          why: 'الحكي مع صديق تثق فيه يخليك تحس إنك مش وحدك.',
          draft:
              'أهلين، فيه حاجة شاغلة بالي ونبي نحكي معاك فيها. عندك وقت قريب؟',
        ),
        SupportSuggestion(
          type: SupportType.academicAdviser,
          why: 'المرشد الأكاديمي يقدر يساعدك تنظّم ضغط الدراسة.',
          draft:
              'السلام عليكم أستاذ، نبي نحكي معاك على ضغط الدراسة اللي نحس بيه. '
              'نقدر نحجز وقت؟',
        ),
      ],
    );
  }
}
