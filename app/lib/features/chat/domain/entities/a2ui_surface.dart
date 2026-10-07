/// A UI surface described by the AI using the A2UI protocol (v0.8 subset).
///
/// The AI sends a flat list of components that reference each other by id;
/// rendering starts at [rootId].
class A2uiSurface {
  const A2uiSurface({
    required this.surfaceId,
    required this.rootId,
    required this.components,
  });

  final String surfaceId;
  final String rootId;
  final Map<String, A2uiComponent> components;

  A2uiComponent? operator [](String id) => components[id];
}

/// Components in Khutwa's A2UI catalog.
sealed class A2uiComponent {
  const A2uiComponent();
}

class A2uiColumn extends A2uiComponent {
  const A2uiColumn(this.children);

  final List<String> children;
}

class A2uiRow extends A2uiComponent {
  const A2uiRow(this.children);

  final List<String> children;
}

class A2uiCard extends A2uiComponent {
  const A2uiCard({required this.child, this.highlight = false});

  final String child;

  /// Catalog extension: draws the card as the recommended choice.
  final bool highlight;
}

enum A2uiTextHint { h1, h2, h3, body, caption }

class A2uiText extends A2uiComponent {
  const A2uiText(this.text, {this.hint = A2uiTextHint.body});

  final String text;
  final A2uiTextHint hint;
}

class A2uiIcon extends A2uiComponent {
  const A2uiIcon(this.name);

  final String name;
}

/// Catalog extension: a small label such as "Recommended".
class A2uiBadge extends A2uiComponent {
  const A2uiBadge(this.text);

  final String text;
}

class A2uiButton extends A2uiComponent {
  const A2uiButton({
    required this.child,
    required this.action,
    this.primary = false,
  });

  final String child;
  final A2uiAction action;
  final bool primary;
}

/// A component type the client does not know; rendered as nothing.
class A2uiUnsupported extends A2uiComponent {
  const A2uiUnsupported(this.type);

  final String type;
}

/// What a button reports back when tapped (A2UI `userAction`).
class A2uiAction {
  const A2uiAction(this.name, {this.context = const {}});

  final String name;
  final Map<String, String> context;
}
