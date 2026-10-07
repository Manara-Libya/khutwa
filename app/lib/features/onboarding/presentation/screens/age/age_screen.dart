import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_fill_scroll_view.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_option_card.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/user_profile.dart';

class AgeScreen extends StatelessWidget {
  const AgeScreen({
    super.key,
    required this.nickname,
    required this.selected,
    required this.onSelect,
    required this.onContinue,
    required this.onBack,
  });

  final String nickname;
  final AgeGroup? selected;
  final ValueChanged<AgeGroup> onSelect;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = {
      AgeGroup.under13: l10n.ageUnder13,
      AgeGroup.teen: l10n.ageTeen,
      AgeGroup.adult: l10n.ageAdult,
    };

    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: AppFillScrollView(
            spacing: 14,
            children: [
              AppHeader(
                title: l10n.ageTitle(nickname),
                subtitle: l10n.ageSubtitle,
              ),
              const Spacer(),
              ...options.entries.map(
                (option) => AppOptionCard(
                  selected: selected == option.key,
                  onTap: () => onSelect(option.key),
                  child: Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: Text(
                          option.value,
                          style: context.textStyles.titleMedium,
                        ),
                      ),
                      AppSelectionIndicator(selected: selected == option.key),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              AppButton(
                label: l10n.continueLabel,
                onPressed: selected == null ? null : onContinue,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
