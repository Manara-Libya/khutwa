import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../utilities/app_option_card.dart';
import '../../../domain/entities/a2ui_surface.dart';

/// Renders an A2UI surface with Khutwa's component catalog.
///
/// Once [chosenAction] is set, buttons are disabled, the chosen one shows a
/// check, and cards without it fade back.
class A2uiSurfaceView extends StatelessWidget {
  const A2uiSurfaceView({
    super.key,
    required this.surface,
    required this.onAction,
    this.chosenAction,
  });

  final A2uiSurface surface;
  final ValueChanged<A2uiAction> onAction;
  final String? chosenAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _build(context, surface.rootId, depth: 0),
    );
  }

  Widget _build(BuildContext context, String id, {required int depth}) {
    // Guards against cyclic references in malformed AI output.
    if (depth > 12) return const SizedBox.shrink();
    Widget child(String childId) => _build(context, childId, depth: depth + 1);
    final text = context.textStyles;
    final colors = context.colors;

    return switch (surface[id]) {
      A2uiColumn(:final children) => Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children.map(child).toList(),
      ),
      // Text in a row takes the remaining width and wraps instead of
      // overflowing; other children keep their natural size.
      A2uiRow(:final children) => Row(
        spacing: 10,
        children: children
            .map(
              (id) => surface[id] is A2uiText
                  ? Expanded(child: child(id))
                  : child(id),
            )
            .toList(),
      ),
      A2uiCard(child: final childId, :final highlight) => _Card(
        highlight: highlight,
        dimmed: chosenAction != null && !_contains(childId, chosenAction!),
        child: child(childId),
      ),
      A2uiText(text: final value, :final hint) => Text(
        value,
        style: switch (hint) {
          A2uiTextHint.h1 => text.headlineMedium,
          A2uiTextHint.h2 => text.titleLarge,
          A2uiTextHint.h3 => text.titleMedium,
          A2uiTextHint.body => text.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
          A2uiTextHint.caption => text.bodySmall,
        },
      ),
      A2uiIcon(:final name) => AppIconBadge(
        icon: _icons[name] ?? Icons.circle_outlined,
        size: 40,
      ),
      A2uiBadge(text: final value) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: text.bodySmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      A2uiButton(child: final labelId, :final action, :final primary) =>
        _Button(
          label: _label(labelId),
          primary: primary,
          chosen: chosenAction == action.name,
          onPressed: chosenAction == null ? () => onAction(action) : null,
        ),
      A2uiUnsupported() || null => const SizedBox.shrink(),
    };
  }

  /// Plain text of a button's label component.
  String _label(String id) => switch (surface[id]) {
    A2uiText(:final text) => text,
    _ => '',
  };

  /// Whether the subtree at [id] holds a button for [action].
  bool _contains(String id, String action, [int depth = 0]) {
    if (depth > 12) return false;
    return switch (surface[id]) {
      A2uiButton(action: A2uiAction(:final name)) => name == action,
      A2uiCard(:final child) => _contains(child, action, depth + 1),
      A2uiColumn(:final children) || A2uiRow(:final children) => children.any(
        (c) => _contains(c, action, depth + 1),
      ),
      _ => false,
    };
  }

  static const _icons = {
    'psychology': Icons.psychology_rounded,
    'family': Icons.family_restroom_rounded,
    'air': Icons.air_rounded,
    'sos': Icons.sos_rounded,
    'chat': Icons.chat_bubble_outline_rounded,
    'school': Icons.school_rounded,
  };
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    required this.highlight,
    required this.dimmed,
  });

  final Widget child;
  final bool highlight;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: dimmed ? 0.45 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: highlight ? colors.secondary : colors.outline,
            width: highlight ? 2.5 : 1,
          ),
          boxShadow: highlight
              ? [
                  BoxShadow(
                    color: colors.secondary.withValues(alpha: 0.45),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.primary,
    required this.chosen,
    required this.onPressed,
  });

  final String label;
  final bool primary;
  final bool chosen;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final child = Row(
      spacing: 6,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (chosen) const Icon(Icons.check_circle_rounded, size: 20),
        Flexible(child: Text(label)),
      ],
    );
    return SizedBox(
      height: 48,
      child: primary || chosen
          ? FilledButton(
              onPressed: onPressed,
              // The chosen button keeps its colors after it is disabled.
              style: chosen
                  ? FilledButton.styleFrom(
                      disabledBackgroundColor: colors.primary,
                      disabledForegroundColor: colors.onPrimary,
                    )
                  : null,
              child: child,
            )
          : OutlinedButton(onPressed: onPressed, child: child),
    );
  }
}
