import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_text_field.dart';

/// Chat Input & Send widget.
class ChatInputComposer extends StatelessWidget {
  const ChatInputComposer({
    super.key,
    required this.controller,
    required this.error,
    required this.onSend,
    required this.onVoice,
  });

  final TextEditingController controller;
  final ValueListenable<String?> error;
  final VoidCallback onSend;
  final VoidCallback onVoice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return ListenableBuilder(
      listenable: Listenable.merge([controller, error]),
      builder: (context, _) {
        final hasText = controller.text.trim().isNotEmpty;
        return Row(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                controller: controller,
                hintText: l10n.chatHint,
                errorText: error.value,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                minLines: 1,
                maxLines: 4,
                bordered: false,
              ),
            ),
            SizedBox(
              width: 54,
              height: 54,
              child: IconButton.filled(
                onPressed: hasText ? onSend : onVoice,
                tooltip: hasText ? l10n.chatSend : l10n.chatVoice,
                style: IconButton.styleFrom(
                  backgroundColor: colors.secondary,
                  foregroundColor: colors.primary,
                ),
                icon: Icon(
                  hasText ? Icons.send_rounded : Icons.mic_none_rounded,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
