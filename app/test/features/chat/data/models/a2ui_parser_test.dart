import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/chat/data/models/a2ui_parser.dart';
import 'package:khutwa_app/features/chat/domain/entities/a2ui_surface.dart';

void main() {
  test('parses surfaceUpdate + beginRendering into a component tree', () {
    final surface = A2uiParser.parse([
      {
        'surfaceUpdate': {
          'surfaceId': 's1',
          'components': [
            {
              'id': 'root',
              'component': {
                'Card': {'child': 'btn', 'highlight': true},
              },
            },
            {
              'id': 'btn',
              'component': {
                'Button': {
                  'child': 'label',
                  'primary': true,
                  'action': {
                    'name': 'contact_specialist',
                    'context': [
                      {
                        'key': 'topic',
                        'value': {'literalString': 'exams'},
                      },
                    ],
                  },
                },
              },
            },
            {
              'id': 'label',
              'component': {
                'Text': {
                  'text': {'literalString': 'Go'},
                  'usageHint': 'h3',
                },
              },
            },
            {
              'id': 'mystery',
              'component': {'Slider': <String, Object?>{}},
            },
          ],
        },
      },
      {
        'beginRendering': {'surfaceId': 's1', 'root': 'root'},
      },
    ]);

    expect(surface.rootId, 'root');
    final card = surface['root']! as A2uiCard;
    expect(card.highlight, isTrue);
    final button = surface[card.child]! as A2uiButton;
    expect(button.primary, isTrue);
    expect(button.action.name, 'contact_specialist');
    expect(button.action.context, {'topic': 'exams'});
    final label = surface['label']! as A2uiText;
    expect((label.text, label.hint), ('Go', A2uiTextHint.h3));
    expect(surface['mystery'], isA<A2uiUnsupported>());
  });

  test('rejects messages without beginRendering or with an unknown root', () {
    final update = {
      'surfaceUpdate': {
        'surfaceId': 's1',
        'components': [
          {
            'id': 'a',
            'component': {
              'Text': {'text': 'hi'},
            },
          },
        ],
      },
    };
    expect(() => A2uiParser.parse([update]), throwsFormatException);
    expect(
      () => A2uiParser.parse([
        update,
        {
          'beginRendering': {'surfaceId': 's1', 'root': 'missing'},
        },
      ]),
      throwsFormatException,
    );
  });
}
