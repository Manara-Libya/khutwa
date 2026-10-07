import '../../domain/entities/a2ui_surface.dart';

/// Parses A2UI v0.8 server messages (`surfaceUpdate` + `beginRendering`)
/// into an [A2uiSurface]. Throws [FormatException] on malformed input.
abstract final class A2uiParser {
  static A2uiSurface parse(List<Object?> messages) {
    final components = <String, A2uiComponent>{};
    String? surfaceId;
    String? rootId;

    for (final message in messages.whereType<Map<String, Object?>>()) {
      if (message['surfaceUpdate'] case final Map<String, Object?> update) {
        surfaceId ??= update['surfaceId'] as String?;
        final list = update['components'] as List<Object?>? ?? const [];
        for (final entry in list.whereType<Map<String, Object?>>()) {
          final id = entry['id'] as String?;
          final component = entry['component'] as Map<String, Object?>?;
          if (id == null || component == null || component.isEmpty) {
            throw const FormatException('A2UI component without id or body');
          }
          components[id] = _component(component);
        }
      }
      if (message['beginRendering'] case final Map<String, Object?> begin) {
        surfaceId ??= begin['surfaceId'] as String?;
        rootId = begin['root'] as String?;
      }
    }

    if (surfaceId == null || rootId == null) {
      throw const FormatException('A2UI messages missing beginRendering');
    }
    if (!components.containsKey(rootId)) {
      throw FormatException('A2UI root "$rootId" is not defined');
    }
    return A2uiSurface(
      surfaceId: surfaceId,
      rootId: rootId,
      components: components,
    );
  }

  static A2uiComponent _component(Map<String, Object?> wrapper) {
    final MapEntry(key: type, value: raw) = wrapper.entries.first;
    final props = raw as Map<String, Object?>? ?? const {};
    return switch (type) {
      'Column' => A2uiColumn(_children(props)),
      'Row' => A2uiRow(_children(props)),
      'Card' => A2uiCard(
        child: props['child']! as String,
        highlight: props['highlight'] == true,
      ),
      'Text' => A2uiText(
        _literal(props['text']),
        hint:
            A2uiTextHint.values.asNameMap()[props['usageHint']] ??
            A2uiTextHint.body,
      ),
      'Icon' => A2uiIcon(_literal(props['name'])),
      'Badge' => A2uiBadge(_literal(props['text'])),
      'Button' => A2uiButton(
        child: props['child']! as String,
        primary: props['primary'] == true,
        action: _action(props['action']! as Map<String, Object?>),
      ),
      _ => A2uiUnsupported(type),
    };
  }

  static List<String> _children(Map<String, Object?> props) {
    final children = props['children'] as Map<String, Object?>?;
    return (children?['explicitList'] as List<Object?>? ?? const [])
        .cast<String>();
  }

  /// A2UI values are wrapped, e.g. `{"literalString": "Hi"}`.
  static String _literal(Object? value) => switch (value) {
    {'literalString': final String s} => s,
    final String s => s,
    _ => '',
  };

  static A2uiAction _action(Map<String, Object?> action) => A2uiAction(
    action['name']! as String,
    context: {
      for (final entry
          in (action['context'] as List<Object?>? ?? const [])
              .whereType<Map<String, Object?>>())
        entry['key']! as String: _literal(entry['value']),
    },
  );
}
