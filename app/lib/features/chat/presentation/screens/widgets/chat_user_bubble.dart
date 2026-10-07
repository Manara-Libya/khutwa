import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';

/// User Message bubble widget.
class ChatUserBubble extends StatelessWidget {
  const ChatUserBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 64, bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: context.textStyles.bodyLarge?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
