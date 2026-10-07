import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_fill_scroll_view.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_mascot.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../../../utilities/app_text_field.dart';

class NicknameScreen extends StatelessWidget {
  const NicknameScreen({
    super.key,
    required this.textController,
    required this.error,
    required this.onSubmit,
    required this.onBack,
  });

  final TextEditingController textController;
  final ValueListenable<String?> error;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: AppFillScrollView(
            children: [
              AppHeader(
                title: l10n.nicknameTitle,
                subtitle: l10n.nicknameSubtitle,
              ),
              const Spacer(),
              // The mascot peeks out from behind the text field.
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 36),
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.5,
                      child: const AppMascot(size: 72, happy: false),
                    ),
                  ),
                ),
              ),
              ListenableBuilder(
                listenable: Listenable.merge([textController, error]),
                builder: (context, _) => AppTextField(
                  controller: textController,
                  hintText: l10n.nicknameHint,
                  errorText: error.value,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onSubmit(),
                  suffix: textController.text.trim().isNotEmpty
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(end: 6),
                          child: IconButton.filled(
                            onPressed: onSubmit,
                            tooltip: l10n.continueLabel,
                            icon: const Icon(Icons.arrow_forward_rounded),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
