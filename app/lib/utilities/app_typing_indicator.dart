import 'package:flutter/material.dart';

/// Three pulsing dots shown while a reply is being written.
class AppTypingIndicator extends StatefulWidget {
  const AppTypingIndicator({super.key, this.color = Colors.white});

  final Color color;

  @override
  State<AppTypingIndicator> createState() => _AppTypingIndicatorState();
}

class _AppTypingIndicatorState extends State<AppTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Row(
          spacing: 6,
          children: List.generate(3, (i) {
            final t = (_controller.value * 3 - i).clamp(0.0, 1.0);
            final opacity = 0.3 + 0.7 * (1 - (t - 0.5).abs() * 2);
            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ),
    );
  }
}
