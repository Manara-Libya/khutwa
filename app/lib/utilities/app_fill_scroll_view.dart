import 'package:flutter/material.dart';

/// A column that fills the available height (so [Spacer]s work) but scrolls
/// when its content is taller than the screen, e.g. on small phones or with
/// large system font sizes.
class AppFillScrollView extends StatelessWidget {
  const AppFillScrollView({
    super.key,
    required this.children,
    this.spacing = 0,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(spacing: spacing, children: children),
          ),
        ),
      ),
    );
  }
}
