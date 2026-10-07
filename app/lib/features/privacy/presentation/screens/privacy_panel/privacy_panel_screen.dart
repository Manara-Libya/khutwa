import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/redaction_result.dart';
import 'widgets/outgoing_text_box.dart';
import 'widgets/tappable_original_text.dart';

/// "What leaves your phone" (#59). The only screen with a Send button.
class PrivacyPanelScreen extends StatelessWidget {
  const PrivacyPanelScreen({
    super.key,
    required this.result,
    required this.failed,
    required this.onToggle,
    required this.onSend,
    required this.onBack,
  });

  /// Null while redacting.
  final RedactionResult? result;

  /// Redaction failed; nothing can be sent.
  final bool failed;
  final void Function(int start, int end) onToggle;
  final VoidCallback onSend;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = this.result;
    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            spacing: 12,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AppHeader(
                      title: l10n.privacyTitle,
                      subtitle: l10n.privacySubtitle,
                    ),
                    const SizedBox(height: 20),
                    if (failed)
                      Text(
                        l10n.privacyError,
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyLarge?.copyWith(
                          color: AppColors.urgent,
                        ),
                      )
                    else if (result == null)
                      const Center(child: CircularProgressIndicator())
                    else
                      Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.privacyOriginalLabel,
                                style: context.textStyles.titleMedium,
                              ),
                              TappableOriginalText(
                                result: result,
                                onToggle: onToggle,
                              ),
                            ],
                          ),
                          OutgoingTextBox(
                            label: l10n.privacyOutgoingLabel,
                            text: result.redacted,
                          ),
                          Row(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: context.colors.onSurfaceVariant,
                              ),
                              Expanded(
                                child: Text(
                                  l10n.privacyHonestLimit,
                                  style: context.textStyles.bodyMedium
                                      ?.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              AppButton(
                label: l10n.privacySend,
                icon: Icons.send_rounded,
                onPressed: result == null || failed ? null : onSend,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
