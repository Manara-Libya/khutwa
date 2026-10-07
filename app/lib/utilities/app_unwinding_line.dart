import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One hand-drawn line that is a tangled scribble on the start side and a
/// calm straight line on the end side. As [progress] goes from 0 to 1 the
/// tangle unwinds until the whole line is straight.
///
/// Animates smoothly between values, unless the platform asks to reduce
/// motion.
class AppUnwindingLine extends StatelessWidget {
  const AppUnwindingLine({
    super.key,
    required this.progress,
    this.color,
    this.height = 96,
  });

  /// 0 = most tangled, 1 = straight.
  final double progress;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final lineColor = color ?? Theme.of(context).colorScheme.onSurface;
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: progress.clamp(0.0, 1.0)),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => CustomPaint(
            painter: _UnwindingLinePainter(
              progress: value,
              color: lineColor,
              // The tangle starts on the reading-start side.
              mirror: Directionality.of(context) == TextDirection.rtl,
            ),
          ),
        ),
      ),
    );
  }
}

/// The geometry, kept separate so it can be tested without painting.
abstract final class UnwindingLinePath {
  static const _samples = 900;

  /// Points along the line inside [size], from the tangled end to the calm
  /// end, for a [progress] between 0 and 1.
  static List<Offset> points(Size size, double progress) {
    final t = progress.clamp(0.0, 1.0);
    final calm = 1 - t;
    final midY = size.height / 2;
    // Sized for the knot; the result is fitted into [size] below.
    final maxRadius = size.height * 0.34;

    final raw = List.generate(_samples + 1, (i) {
      final s = i / _samples;
      // How tangled the line is here: strongest at the start, none at the
      // end, and all of it fading out as progress grows.
      final chaos = calm * math.pow(1 - s, 1.3).toDouble();
      // While tangled, the start moves forward more slowly, so its loops
      // pile up into a knot; once calm, the line advances evenly.
      final forward = math.pow(s, 1 + 0.55 * calm).toDouble();
      // Uneven, drifting loop sizes look scribbled rather than coiled.
      final r1 =
          maxRadius *
          chaos *
          (0.7 + 0.45 * math.sin(2 * math.pi * 3.7 * s + 0.5));
      final r2 =
          maxRadius *
          0.6 *
          chaos *
          (0.6 + 0.4 * math.cos(2 * math.pi * 5.3 * s));
      final r3 = maxRadius * 0.45 * chaos;
      // Large radius at high frequency makes loops; small radius makes a
      // gentle wave, which flattens into a straight line.
      final a1 = 2 * math.pi * 19 * s;
      final a2 = -2 * math.pi * 11 * s + 1.3;
      final a3 = 2 * math.pi * 4.5 * s + 0.4;
      final wave =
          size.height *
          0.14 *
          calm *
          math.sin(2 * math.pi * 3 * s) *
          math.max(0, 1 - s * 1.15);
      return Offset(
        forward * size.width +
            r1 * math.cos(a1) +
            r2 * math.cos(a2) +
            r3 * math.cos(a3),
        midY + r1 * math.sin(a1) + r2 * math.sin(a2) + r3 * math.sin(a3) + wave,
      );
    });

    // Fit inside [size]: loops at the start can reach past the edges.
    // Horizontally stretch to the full width; vertically only shrink,
    // around the middle, so the calm end stays on the centre line.
    const inset = 2.0;
    final minX = raw.map((p) => p.dx).reduce(math.min);
    final maxX = raw.map((p) => p.dx).reduce(math.max);
    final sx = (size.width - 2 * inset) / (maxX - minX);
    final reach = raw.map((p) => (p.dy - midY).abs()).reduce(math.max);
    final sy = reach <= midY - inset ? 1.0 : (midY - inset) / reach;
    return raw
        .map(
          (p) => Offset(inset + (p.dx - minX) * sx, midY + (p.dy - midY) * sy),
        )
        .toList();
  }
}

class _UnwindingLinePainter extends CustomPainter {
  _UnwindingLinePainter({
    required this.progress,
    required this.color,
    required this.mirror,
  });

  final double progress;
  final Color color;
  final bool mirror;

  @override
  void paint(Canvas canvas, Size size) {
    final pts = UnwindingLinePath.points(size, progress);
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    if (mirror) {
      canvas
        ..translate(size.width, 0)
        ..scale(-1, 1);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_UnwindingLinePainter old) =>
      old.progress != progress || old.color != color || old.mirror != mirror;
}
