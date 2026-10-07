import 'package:flutter/material.dart';

/// Full-width pill button: outlined while disabled, filled when enabled.
/// Pass [icon] for a leading icon.
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
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: onPressed == null
            ? OutlinedButton(
                key: const ValueKey('disabled'),
                onPressed: null,
                child: Text(label),
              )
            : icon == null
            ? FilledButton(
                key: const ValueKey('enabled'),
                onPressed: onPressed,
                style: style,
                child: Text(label),
              )
            : FilledButton.icon(
                key: const ValueKey('enabled'),
                onPressed: onPressed,
                style: style,
                icon: Icon(icon),
                label: Text(label),
              ),
      ),
    );
  }
}
