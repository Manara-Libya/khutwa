import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_fill_scroll_view.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/user_profile.dart';
import 'widgets/support_preference_card.dart';

class SupportPreferenceScreen extends StatelessWidget {
  const SupportPreferenceScreen({
    super.key,
    required this.onSelect,
    required this.onBack,
  });

  final ValueChanged<SupportStyle> onSelect;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      (
        SupportStyle.selfCare,
        l10n.supportSelfCareTitle,
        l10n.supportSelfCareDesc,
        Icons.self_improvement_rounded,
      ),
      (
        SupportStyle.guided,
        l10n.supportGuidedTitle,
        l10n.supportGuidedDesc,
        Icons.groups_rounded,
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
            spacing: 20,
            children: [
              AppHeader(
                title: l10n.supportTitle,
                subtitle: l10n.supportSubtitle,
              ),
              const Spacer(),
              ...options.map(
                (o) => SupportPreferenceCard(
                  title: o.$2,
                  description: o.$3,
                  icon: o.$4,
                  onTap: () => onSelect(o.$1),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
