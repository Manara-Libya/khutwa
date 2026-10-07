import 'package:flutter/material.dart';

import '../app/app_theme.dart';

/// Full-width primary button: a green pill with the pen outline and the
/// hard "print" shadow (from the theme). Disabled drops the shadow and sinks
/// into the paper.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
    final button = icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
        : FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon),
            label: Text(label),
          );
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          shadows: onPressed == null ? null : context.brand.printShadow,
        ),
        child: button,
      ),
    );
  }
}
