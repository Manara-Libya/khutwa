import 'package:flutter/material.dart';

import '../app/app_theme.dart';

/// A raised card drawn with the pen outline; when selected it turns
/// green-soft and gets the print shadow.
class AppOptionCard extends StatelessWidget {
  const AppOptionCard({
    super.key,
    required this.child,
    required this.onTap,
    this.selected = false,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final VoidCallback onTap;
  final bool selected;
  final EdgeInsetsGeometry padding;

  static const _radius = BorderRadius.all(Radius.circular(AppRadius.lg));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: _radius,
        boxShadow: selected ? context.brand.printShadow : null,
      ),
      child: Material(
        color: selected ? colors.primaryContainer : colors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: _radius,
          side: BorderSide(color: colors.onSurface, width: AppStroke.hand),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Icon in a green-soft circle with the pen outline, used inside cards.
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({super.key, required this.icon, this.size = 44});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colors.onSurface,
          width: AppStroke.hand,
        ),
      ),
      child: Icon(icon, size: size * 0.5, color: context.colors.onSurface),
    );
  }
}
