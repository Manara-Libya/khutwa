import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../../../utilities/app_text_field.dart';

/// Editable draft + Copy (#54). There is no send-to-contact action.
class MessageDraftScreen extends StatelessWidget {
  const MessageDraftScreen({
    super.key,
    required this.supportLabel,
    required this.textController,
    required this.onCopy,
    required this.onSaveToPlan,
    required this.onBack,
  });

  final String supportLabel;
  final TextEditingController textController;
  final VoidCallback onCopy;
  final VoidCallback onSaveToPlan;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
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
                    AppHeader(title: l10n.draftTitle, subtitle: supportLabel),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: textController,
                      minLines: 6,
                      maxLines: null,
                      radius: 18,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.front_hand_rounded,
                          size: 20,
                          color: colors.primary,
                        ),
                        Text(
                          l10n.draftSendYourself,
                          style: context.textStyles.titleMedium?.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppButton(
                label: l10n.draftCopy,
                icon: Icons.copy_rounded,
                onPressed: onCopy,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: onSaveToPlan,
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: Text(l10n.draftSaveToPlan),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
