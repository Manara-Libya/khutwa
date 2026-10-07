import 'package:flutter/material.dart';

import '../app/app_theme.dart';

/// A plain raised (surfaceContainer) card; outlined in ink when selected.
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

  static const _radius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: _radius,
        side: BorderSide(
          color: selected ? colors.onSurface : Colors.transparent,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Icon in a soft circle, used inside cards.
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
        color: context.colors.onSurface.withValues(alpha: 0.06),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size * 0.5, color: context.colors.onSurface),
    );
  }
}
