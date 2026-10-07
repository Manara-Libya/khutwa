import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:khutwa_app/features/analysis/presentation/screens/conversation/conversation_screen.dart';
import 'package:khutwa_app/utilities/app_unwinding_line.dart';

void main() {
  const size = Size(300, 90);

  /// Largest distance of any point from the middle line.
  double spread(double progress) => UnwindingLinePath.points(
    size,
    progress,
  ).map((p) => (p.dy - size.height / 2).abs()).reduce((a, b) => a > b ? a : b);

  /// True if the line ever moves backwards, i.e. it forms a loop.
  bool loops(double progress) {
    final pts = UnwindingLinePath.points(size, progress);
    return Iterable.generate(pts.length - 1)
        .any((i) => pts[i + 1].dx < pts[i].dx);
  }

  test('fully written: a straight line', () {
    expect(spread(1), lessThan(0.001));
    expect(loops(1), isFalse);
  });

  test('nothing written: tangled, with loops', () {
    expect(loops(0), isTrue);
    expect(spread(0), greaterThan(size.height * 0.3));
  });

  test('the tangle loosens steadily as progress grows', () {
    expect(spread(0), greaterThan(spread(0.4)));
    expect(spread(0.4), greaterThan(spread(0.8)));
  });

  test('the end side is always calm', () {
    final last = UnwindingLinePath.points(size, 0).last;
    expect(last.dy, closeTo(size.height / 2, 0.5));
  });

  test('progress maps 0 → 50 characters onto 0 → 1', () {
    expect(writingProgress(0), 0);
    expect(writingProgress(20), closeTo(0.4, 1e-9));
    expect(writingProgress(50), 1);
    expect(writingProgress(500), 1);
  });
}
