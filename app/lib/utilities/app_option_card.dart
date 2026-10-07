import 'package:flutter/material.dart';

import '../app/app_theme.dart';

/// A raised (surfaceContainer) card used for choices; tinted when selected.
class AppOptionCard extends StatelessWidget {
  const AppOptionCard({
    super.key,
    required this.child,
    required this.onTap,
    this.selected = false,
    this.elevated = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
  });

  final Widget child;
  final VoidCallback onTap;
  final bool selected;
  final bool elevated;
  final EdgeInsetsGeometry padding;

  static const _radius = BorderRadius.all(Radius.circular(18));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected
            ? Color.alphaBlend(AppColors.secondarySoft, colors.surfaceContainer)
            : colors.surfaceContainer,
        borderRadius: _radius,
        border: Border.all(
          color: selected ? colors.secondary : colors.outline,
          width: selected ? 2 : 1.5,
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: _radius,
        child: Stack(
          children: [
            // A soft accent shape in the corner.
            PositionedDirectional(
              top: -40,
              end: -30,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.secondary.withValues(alpha: 0.06),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                child: Padding(padding: padding, child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Radio-style indicator shown at the end of selectable cards.
class AppSelectionIndicator extends StatelessWidget {
  const AppSelectionIndicator({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.secondary : Colors.transparent,
        border: Border.all(
          color: selected ? colors.secondary : colors.outline,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : null,
    );
  }
}

/// Icon in a soft tinted circle, used inside cards.
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
        color: AppColors.secondarySoft,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size * 0.55, color: context.colors.primary),
    );
  }
}
