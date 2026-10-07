import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../app/l10n/l10n.dart';

/// Supplies a widget shown at the end of every [AppScreenBody] top bar below
/// it. The app shell uses it for the Urgent button, so no screen can forget it.
class AppTopBarTrailing extends InheritedWidget {
  const AppTopBarTrailing({
    super.key,
    required this.trailing,
    required super.child,
  });

  final Widget trailing;

  static Widget? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppTopBarTrailing>()?.trailing;

  @override
  bool updateShouldNotify(AppTopBarTrailing oldWidget) =>
      trailing != oldWidget.trailing;
}

/// Standard screen layout: top bar container with height [topBarHeight]
/// holding an optional [leading] widget, [actions], and [AppTopBarTrailing],
/// followed by [child] filling the remaining screen height.
class AppScreenBody extends StatelessWidget {
  const AppScreenBody({
    super.key,
    required this.child,
    this.leading,
    this.actions = const [],
    this.topBarHeight = AppSpacing.topBarHeight,
  });

  final Widget child;
  final Widget? leading;
  final List<Widget> actions;
  final double topBarHeight;

  @override
  Widget build(BuildContext context) {
    final trailing = AppTopBarTrailing.maybeOf(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: topBarHeight,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8, end: 16),
              child: Row(
                spacing: 8,
                children: [?leading, const Spacer(), ...actions, ?trailing],
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Back chevron that mirrors with the text direction and is labelled in the
/// current language.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, required this.onPressed, this.color});

  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // A round, softly filled button, like the rest of the design.
    return IconButton.filled(
      onPressed: onPressed,
      tooltip: context.l10n.back,
      style: IconButton.styleFrom(
        fixedSize: const Size.square(48),
        backgroundColor: context.colors.onSurface.withValues(alpha: 0.08),
        foregroundColor: color ?? context.colors.onSurface,
      ),
      // matchTextDirection: points left in LTR and right in RTL.
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }
}
