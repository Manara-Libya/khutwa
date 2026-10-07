import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/app_theme.dart';
import '../../../../../../app/l10n/l10n.dart';
import '../../../../../../utilities/app_text_field.dart';

/// Message field and a round send button.
class ConversationComposer extends StatelessWidget {
  const ConversationComposer({
    super.key,
    required this.controller,
    required this.error,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final ValueListenable<String?> error;

  /// False while waiting for a reply.
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return ListenableBuilder(
      listenable: Listenable.merge([controller, error]),
      builder: (context, _) {
        final canSend = enabled && controller.text.trim().isNotEmpty;
        return Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                controller: controller,
                hintText: l10n.writeHint,
                errorText: error.value,
                minLines: 1,
                maxLines: 5,
                radius: 24,
                bordered: false,
              ),
            ),
            IconButton.filled(
              onPressed: canSend ? onSend : null,
              tooltip: l10n.chatSend,
              style: IconButton.styleFrom(
                fixedSize: const Size.square(54),
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                disabledBackgroundColor: colors.primary.withValues(alpha: 0.25),
                disabledForegroundColor: colors.onPrimary,
              ),
              // matchTextDirection: points the right way in RTL.
              icon: const Icon(Icons.arrow_upward_rounded),
            ),
          ],
        );
      },
    );
  }
}
