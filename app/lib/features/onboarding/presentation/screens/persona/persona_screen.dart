import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_fill_scroll_view.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/user_profile.dart';
import 'widgets/persona_card.dart';

class PersonaScreen extends StatelessWidget {
  const PersonaScreen({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onContinue,
    required this.onSkip,
    required this.onBack,
  });

  final Personality? selected;
  final ValueChanged<Personality> onSelect;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      (Personality.warm, l10n.personalityWarmTitle, l10n.personalityWarmDesc),
      (
        Personality.direct,
        l10n.personalityDirectTitle,
        l10n.personalityDirectDesc,
      ),
    ];

    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: AppFillScrollView(
            spacing: 16,
            children: [
              AppHeader(
                title: l10n.personalityTitle,
                subtitle: l10n.personalitySubtitle,
              ),
              const Spacer(),
              ...options.map(
                (o) => PersonaCard(
                  personality: o.$1,
                  title: o.$2,
                  description: o.$3,
                  selected: selected == o.$1,
                  onTap: () => onSelect(o.$1),
                ),
              ),
              const Spacer(),
              Column(
                spacing: 8,
                children: [
                  AppButton(
                    label: l10n.continueLabel,
                    onPressed: selected == null ? null : onContinue,
                  ),
                  TextButton(onPressed: onSkip, child: Text(l10n.maybeLater)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
