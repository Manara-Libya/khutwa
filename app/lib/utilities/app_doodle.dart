import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/app_theme.dart';

/// Hand-drawn style line art: a wobbly flower outline, optionally with
/// concentric rings, a keyhole or a small stem. Drawn in code, no assets.
class AppDoodle extends StatelessWidget {
  /// A flower with rings in the middle.
  const AppDoodle.flower({super.key, this.size = 200, this.color})
    : petals = 6,
      depth = 0.22,
      rings = 2,
      keyhole = false,
      stem = false;

  /// A soft blob with a keyhole: privacy.
  const AppDoodle.lock({super.key, this.size = 120, this.color})
    : petals = 7,
      depth = 0.08,
      rings = 0,
      keyhole = true,
      stem = false;

  /// An open five-petal flower on a small stem.
  const AppDoodle.bloom({super.key, this.size = 220, this.color})
    : petals = 5,
      depth = 0.42,
      rings = 0,
      keyhole = false,
      stem = true;

  final double size;

  /// Line colour; defaults to the current text colour.
  final Color? color;
  final int petals;

  /// How deep the petals are cut (0 = circle).
  final double depth;
  final int rings;
  final bool keyhole;
  final bool stem;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(size, stem ? size * 1.35 : size),
        painter: _DoodlePainter(
          color: color ?? context.colors.onSurface,
          background: context.colors.surface,
          petals: petals,
          depth: depth,
          rings: rings,
          keyhole: keyhole,
          stem: stem,
        ),
      ),
    );
  }
}

class _DoodlePainter extends CustomPainter {
  _DoodlePainter({
    required this.color,
    required this.background,
    required this.petals,
    required this.depth,
    required this.rings,
    required this.keyhole,
    required this.stem,
  });

  final Color color;
  final Color background;
  final int petals;
  final double depth;
  final int rings;
  final bool keyhole;
  final bool stem;

  /// Small deterministic tremor so lines look drawn by hand.
  static double _wobble(double t, double seed) =>
      0.018 * math.sin(11 * t + seed) + 0.011 * math.sin(23 * t + seed * 2.3);

  Path _closedCurve(
    Offset c,
    double radius,
    double Function(double t) shape,
    double seed,
  ) {
    final path = Path();
    const steps = 240;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps * 2 * math.pi;
      final r = radius * (shape(t) + _wobble(t, seed));
      final p = c + Offset(math.cos(t), math.sin(t)) * r;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.5, s * 0.022)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final center = Offset(s / 2, s / 2);
    final radius = s * 0.46;

    if (stem) {
      // A short clay stem under the flower, with a foot line.
      final stemRect = Rect.fromLTWH(s * 0.46, s * 0.62, s * 0.09, s * 0.6);
      canvas.drawRect(stemRect, Paint()..color = AppColors.clay);
      canvas.drawLine(
        Offset(s * 0.38, s * 1.24),
        Offset(s * 0.56, s * 1.24),
        stroke,
      );
    }

    // Petals: exactly [petals] lobes; the outline dips between them by
    // [depth]. Rotated so a petal points up.
    final outline = _closedCurve(
      center,
      radius,
      (t) => 1 - depth * (1 - (1 + math.cos(petals * (t + math.pi / 2))) / 2),
      0.7,
    );
    // Filled with the page colour so the stem sits behind the flower.
    canvas.drawPath(outline, Paint()..color = background);
    canvas.drawPath(outline, stroke);
    if (stem) canvas.drawCircle(center, s * 0.06, stroke);

    // Concentric rings, each slightly uneven.
    for (var i = 1; i <= rings; i++) {
      canvas.drawPath(
        _closedCurve(center, radius * (0.42 - i * 0.14), (_) => 1, i * 1.9),
        stroke,
      );
    }

    if (keyhole) {
      final fill = Paint()..color = color;
      canvas.drawCircle(center - Offset(0, s * 0.06), s * 0.075, fill);
      canvas.drawPath(
        Path()
          ..moveTo(center.dx - s * 0.035, center.dy - s * 0.04)
          ..lineTo(center.dx + s * 0.035, center.dy - s * 0.04)
          ..lineTo(center.dx + s * 0.06, center.dy + s * 0.13)
          ..lineTo(center.dx - s * 0.06, center.dy + s * 0.13)
          ..close(),
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(_DoodlePainter old) =>
      old.color != color ||
      old.background != background ||
      old.petals != petals ||
      old.depth != depth ||
      old.rings != rings ||
      old.keyhole != keyhole ||
      old.stem != stem;
}
