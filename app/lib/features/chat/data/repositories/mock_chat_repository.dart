import 'dart:convert';

import '../../../../core/text/text_normalizer.dart';
import '../../domain/entities/a2ui_surface.dart';
import '../../domain/entities/ai_reply.dart';
import '../../domain/repositories/chat_ai_repository.dart';
import '../models/a2ui_parser.dart';

/// Stand-in for the AI backend, for trying A2UI on the device.
///
/// When the user asks for help ("أحتاج إلى مساعدة", "I need help"), it replies
/// with an A2UI surface of help options, the specialist one recommended.
/// Its JSON goes through [A2uiParser] exactly like a real response would.
/// Anything else returns null so the scripted intro continues.
class MockChatRepository implements ChatAiRepository {
  MockChatRepository();

  static const helpSurfaceId = 'help_options';

  static const _helpKeywords = [
    'مساعده',
    'ساعدني',
    'ساعدوني',
    'محتاج حد',
    'help',
    'support',
  ];

  bool _arabic = true;

  @override
  Future<AiReply?> reply(String message) async {
    final normalized = TextNormalizer.forMatching(message);
    if (!_helpKeywords.any(normalized.contains)) return null;
    _arabic = RegExp('[؀-ۿ]').hasMatch(message);
    final json = jsonEncode(_helpSurfaceMessages(topic: message));
    return AiReply(
      text: _t(
        'أنا هنا معك. اختر نوع المساعدة الذي يناسبك الآن:',
        "I'm here with you. Pick the kind of help that fits you right now:",
      ),
      surface: A2uiParser.parse(jsonDecode(json) as List<Object?>),
    );
  }

  @override
  Future<AiReply?> handleAction(A2uiAction action) async =>
      switch (action.name) {
        'contact_specialist' => AiReply(
          text: _t(
            'قرار شجاع 💙 جهّزت لك مسودة رسالة لمختص. عدّلها كما تريد ثم أرسلها بنفسك.',
            "That's a brave step 💙 I've drafted a message to a specialist. Edit it, then send it yourself.",
          ),
        ),
        'talk_trusted_adult' => AiReply(
          text: _t(
            'فكرة جميلة. جهّزت لك مسودة تبدأ بها الحديث مع شخص تثق به.',
            "Good idea. I've drafted a message to start that conversation.",
          ),
        ),
        'calming_exercise' => AiReply(
          text: _t(
            'لنجرّب معًا: تنفّس من أنفك 4 ثوانٍ… احبس 4… أخرج الهواء ببطء 6 ثوانٍ. كرّرها 4 مرات، ثم أخبرني كيف تشعر.',
            "Let's try together: breathe in for 4 seconds… hold for 4… breathe out slowly for 6. Repeat 4 times, then tell me how you feel.",
          ),
        ),
        _ => null,
      };

  String _t(String ar, String en) => _arabic ? ar : en;

  /// The A2UI v0.8 messages a real agent would stream for this surface.
  List<Map<String, Object?>> _helpSurfaceMessages({required String topic}) {
    Map<String, Object?> lit(String s) => {'literalString': s};
    Map<String, Object?> text(String id, String value, String hint) => {
      'id': id,
      'component': {
        'Text': {'text': lit(value), 'usageHint': hint},
      },
    };
    Map<String, Object?> column(String id, List<String> children) => {
      'id': id,
      'component': {
        'Column': {
          'children': {'explicitList': children},
        },
      },
    };

    List<Map<String, Object?>> option({
      required String key,
      required String icon,
      required String title,
      required String description,
      required String button,
      required String action,
      bool recommended = false,
    }) => [
      {
        'id': 'card_$key',
        'component': {
          'Card': {'child': 'col_$key', 'highlight': recommended},
        },
      },
      column('col_$key', [
        if (recommended) 'badge_$key',
        'head_$key',
        'desc_$key',
        'btn_$key',
      ]),
      if (recommended)
        {
          'id': 'badge_$key',
          'component': {
            'Badge': {'text': lit(_t('⭐ الخيار الموصى به', '⭐ Recommended'))},
          },
        },
      {
        'id': 'head_$key',
        'component': {
          'Row': {
            'children': {
              'explicitList': ['icon_$key', 'title_$key'],
            },
          },
        },
      },
      {
        'id': 'icon_$key',
        'component': {
          'Icon': {'name': lit(icon)},
        },
      },
      text('title_$key', title, 'h3'),
      text('desc_$key', description, 'body'),
      {
        'id': 'btn_$key',
        'component': {
          'Button': {
            'child': 'btnlabel_$key',
            'primary': recommended,
            'action': {
              'name': action,
              'context': [
                {'key': 'topic', 'value': lit(topic)},
              ],
            },
          },
        },
      },
      text('btnlabel_$key', button, 'body'),
    ];

    final options = [
      // Listed first and highlighted: the option we hope the user picks.
      ...option(
        key: 'specialist',
        icon: 'psychology',
        title: _t('التواصل مع مختص', 'Talk to a specialist'),
        description: _t(
          'مختص نفسي مرخّص يستمع لك بسرية تامة ويساعدك بخطة واضحة تناسبك.',
          'A licensed professional who listens in full confidence and helps you with a clear plan.',
        ),
        button: _t('تواصل مع مختص', 'Contact a specialist'),
        action: 'contact_specialist',
        recommended: true,
      ),
      ...option(
        key: 'adult',
        icon: 'family',
        title: _t('التحدث مع شخص تثق به', 'Talk to someone you trust'),
        description: _t(
          'أحد والديك، قريب، أو معلم تشعر بالراحة معه.',
          'A parent, relative or teacher you feel comfortable with.',
        ),
        button: _t('اكتب له رسالة', 'Write them a message'),
        action: 'talk_trusted_adult',
      ),
      ...option(
        key: 'calm',
        icon: 'air',
        title: _t('تمرين تهدئة الآن', 'A calming exercise now'),
        description: _t(
          'دقيقة واحدة من التنفس الهادئ لتخفيف التوتر.',
          'One minute of slow breathing to ease the tension.',
        ),
        button: _t('ابدأ التمرين', 'Start the exercise'),
        action: 'calming_exercise',
      ),
      ...option(
        key: 'urgent',
        icon: 'sos',
        title: _t('أحتاج مساعدة عاجلة', 'I need urgent help'),
        description: _t(
          'إذا كنت في خطر الآن، تواصل مع الطوارئ فورًا.',
          'If you are in danger right now, contact emergency services immediately.',
        ),
        button: _t('مساعدة عاجلة', 'Urgent help'),
        action: 'urgent_help',
      ),
    ];

    return [
      {
        'surfaceUpdate': {
          'surfaceId': helpSurfaceId,
          'components': [
            column('root', [
              'card_specialist',
              'card_adult',
              'card_calm',
              'card_urgent',
            ]),
            ...options,
          ],
        },
      },
      {
        'beginRendering': {'surfaceId': helpSurfaceId, 'root': 'root'},
      },
    ];
  }
}
