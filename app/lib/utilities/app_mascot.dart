import 'package:flutter/material.dart';

import '../app/app_theme.dart';

/// Khutwa's mascot (AppMascot): a small teal character with a leaf sprouting on top.
class AppMascot extends StatelessWidget {
  const AppMascot({super.key, this.size = 160, this.happy = true});

  final double size;

  /// Closed, smiling eyes when true; round open eyes otherwise.
  final bool happy;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _MascotPainter(happy: happy),
    );
  }
}

class _MascotPainter extends CustomPainter {
  _MascotPainter({required this.happy});

  final bool happy;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    Offset p(double x, double y) => Offset(x * s, y * s);

    // Leaf sprout.
    final stem = Paint()
      ..color = AppColors.primary
      ..strokeWidth = s * 0.025
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(p(0.5, 0.16), p(0.5, 0.06), stem);
    final leaf = Path()
      ..moveTo(0.5 * s, 0.07 * s)
      ..quadraticBezierTo(0.56 * s, -0.03 * s, 0.7 * s, 0.02 * s)
      ..quadraticBezierTo(0.62 * s, 0.11 * s, 0.5 * s, 0.07 * s);
    canvas.drawPath(leaf, Paint()..color = AppColors.secondary);

    // Body.
    final body = Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(
          0.17 * s,
          0.12 * s,
          0.83 * s,
          0.98 * s,
          topLeft: Radius.circular(0.33 * s),
          topRight: Radius.circular(0.33 * s),
          bottomLeft: Radius.circular(0.2 * s),
          bottomRight: Radius.circular(0.2 * s),
        ),
      );
    canvas.drawPath(body, Paint()..color = AppColors.secondary);

    // Belly, clipped to the body.
    canvas.save();
    canvas.clipPath(body);
    canvas.drawOval(
      Rect.fromLTRB(0.27 * s, 0.6 * s, 0.73 * s, 1.15 * s),
      Paint()..color = Colors.white,
    );
    canvas.restore();

    // Face.
    canvas.drawOval(
      Rect.fromLTRB(0.28 * s, 0.24 * s, 0.72 * s, 0.53 * s),
      Paint()..color = Colors.white,
    );

    // Eyes.
    final eye = Paint()
      ..color = AppColors.text
      ..strokeWidth = s * 0.022
      ..strokeCap = StrokeCap.round
      ..style = happy ? PaintingStyle.stroke : PaintingStyle.fill;
    for (final x in [0.41, 0.59]) {
      if (happy) {
        canvas.drawArc(
          Rect.fromCenter(
            center: p(x, 0.39),
            width: 0.08 * s,
            height: 0.07 * s,
          ),
          3.4,
          2.6,
          false,
          eye,
        );
      } else {
        canvas.drawCircle(p(x, 0.38), 0.03 * s, eye);
      }
    }

    // Cheeks.
    final cheek = Paint()
      ..color = const Color(0xFFF4A6A6).withValues(alpha: 0.6);
    canvas.drawCircle(p(0.35, 0.45), 0.03 * s, cheek);
    canvas.drawCircle(p(0.65, 0.45), 0.03 * s, cheek);

    // Smile.
    canvas.drawArc(
      Rect.fromCenter(center: p(0.5, 0.44), width: 0.08 * s, height: 0.06 * s),
      0.3,
      2.5,
      false,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = s * 0.02
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_MascotPainter oldDelegate) => oldDelegate.happy != happy;
}
