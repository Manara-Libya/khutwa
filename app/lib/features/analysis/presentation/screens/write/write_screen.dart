import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../../../utilities/app_text_field.dart';

class WriteScreen extends StatelessWidget {
  const WriteScreen({
    super.key,
    required this.textController,
    required this.error,
    required this.hasPlan,
    required this.onNext,
    required this.onOpenPlan,
  });

  final TextEditingController textController;
  final ValueListenable<String?> error;
  final bool hasPlan;
  final VoidCallback onNext;
  final VoidCallback onOpenPlan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: AppScreenBody(
        actions: [
          if (hasPlan)
            TextButton.icon(
              onPressed: onOpenPlan,
              style: TextButton.styleFrom(
                foregroundColor: context.colors.primary,
              ),
              icon: const Icon(Icons.bookmark_rounded),
              label: Text(l10n.myPlan),
            ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: ListenableBuilder(
            listenable: Listenable.merge([textController, error]),
            builder: (context, _) => Column(
              spacing: 12,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      AppHeader(
                        title: l10n.writeTitle,
                        subtitle: l10n.writeSubtitle,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: textController,
                        hintText: l10n.writeHint,
                        errorText: error.value,
                        minLines: 7,
                        maxLines: null,
                        radius: 18,
                      ),
                    ],
                  ),
                ),
                AppButton(
                  label: l10n.writeNext,
                  icon: Icons.shield_outlined,
                  onPressed: textController.text.trim().isEmpty ? null : onNext,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
