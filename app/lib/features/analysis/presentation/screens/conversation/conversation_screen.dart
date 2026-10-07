import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_doodle.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../../../utilities/app_typing_indicator.dart';
import '../../../../../utilities/app_unwinding_line.dart';
import '../../providers/conversation_state.dart';
import 'widgets/conversation_composer.dart';
import 'widgets/question_chips.dart';
import 'widgets/reply_text.dart';
import 'widgets/sent_bubble.dart';

/// Characters written before the unwinding line is fully straight.
const calmAfterCharacters = 50;

/// 0 (tangled) to 1 (straight) for [characters] written so far.
double writingProgress(int characters) =>
    (characters / calmAfterCharacters).clamp(0.0, 1.0);

/// The chat: a dark "focus" screen. The user writes, the AI reflects, and
/// the user can then see support options.
class ConversationScreen extends StatelessWidget {
  const ConversationScreen({
    super.key,
    required this.state,
    required this.textController,
    required this.inputError,
    required this.scrollController,
    required this.onSend,
    required this.onRetry,
    required this.onSeeOptions,
  });

  final ConversationState state;
  final TextEditingController textController;
  final ValueListenable<String?> inputError;
  final ScrollController scrollController;
  final VoidCallback onSend;
  final VoidCallback onRetry;
  final VoidCallback onSeeOptions;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark(Theme.of(context)),
      child: Builder(builder: _build),
    );
  }

  Widget _build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final entries = state.entries
        .map(
          (e) => switch (e) {
            SentEntry() => SentBubble(
              text: e.original,
              sentLabel: e.wasRedacted ? l10n.chatSentAs(e.redacted) : null,
            ),
            ReplyEntry(:final reflection) => ReplyText(
              text: reflection,
              disclaimer: l10n.reflectionDisclaimer,
            ),
          },
        )
        .toList();

    return Scaffold(
      body: AppScreenBody(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                children: [
                  AppHeader(title: l10n.chatTitle, subtitle: l10n.chatIntro),
                  const SizedBox(height: 28),
                  if (entries.isEmpty)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AppDoodle.bloom(
                        size: 170,
                        color: colors.onSurface,
                      ),
                    ),
                  ...entries,
                  if (state.waiting) ...[
                    AppTypingIndicator(color: colors.onSurface),
                    const SizedBox(height: 16),
                    const QuestionChips(),
                  ],
                  if (state.failed)
                    Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.analysisErrorTitle,
                          style: context.textStyles.titleMedium,
                        ),
                        Text(
                          l10n.analysisErrorBody,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: onRetry,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(l10n.retry),
                        ),
                      ],
                    ),
                  if (state.canShowOptions) ...[
                    const SizedBox(height: 4),
                    AppButton(
                      label: l10n.reflectionSeeSuggestions,
                      onPressed: onSeeOptions,
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // The more the user writes, the more the line unwinds.
            ListenableBuilder(
              listenable: textController,
              builder: (context, _) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: AppUnwindingLine(
                  progress: writingProgress(
                    state.charactersSent + textController.text.trim().length,
                  ),
                  height: 72,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: ConversationComposer(
                controller: textController,
                error: inputError,
                enabled: !state.waiting,
                onSend: onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
