import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';

/// Individual Bot Message bubble widget.
class ChatBotMessage extends StatelessWidget {
  const ChatBotMessage({super.key, required this.text, required this.onListen});

  final String text;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 32, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: context.textStyles.bodyLarge?.copyWith(color: Colors.white),
          ),
          IconButton(
            onPressed: onListen,
            tooltip: context.l10n.chatListen,
            padding: EdgeInsets.zero,
            alignment: AlignmentDirectional.centerStart,
            color: Colors.white,
            icon: const Icon(Icons.volume_up_outlined, size: 22),
          ),
        ],
      ),
    );
  }
}
