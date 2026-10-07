import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../../../utilities/app_text_field.dart';

/// Editable draft with a copy action and, deliberately, no send action.
class DraftScreen extends StatelessWidget {
  const DraftScreen({
    super.key,
    required this.textController,
    required this.onCopy,
    required this.onReset,
    required this.onBack,
  });

  final TextEditingController textController;
  final VoidCallback onCopy;
  final VoidCallback onReset;
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
                    AppHeader(
                      title: l10n.draftTitle,
                      subtitle: l10n.draftSubtitle,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.secondarySoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: colors.primary,
                          ),
                          Expanded(
                            child: Text(
                              l10n.draftNeverSent,
                              style: context.textStyles.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: textController,
                      minLines: 8,
                      maxLines: null,
                      radius: 18,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: onReset,
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: Text(l10n.draftReset),
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                label: l10n.draftCopy,
                icon: Icons.copy_rounded,
                onPressed: onCopy,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
