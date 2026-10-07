import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/analysis_result.dart';
import '../../analysis_l10n.dart';
import 'widgets/support_option_card.dart';

/// 2–3 support options; the user taps one (#54).
class SupportOptionsScreen extends StatelessWidget {
  const SupportOptionsScreen({
    super.key,
    required this.options,
    required this.onSelect,
    required this.onBack,
  });

  final List<SupportSuggestion> options;
  final ValueChanged<SupportSuggestion> onSelect;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            0,
            AppSpacing.screenHorizontal,
            24,
          ),
          children: [
            AppHeader(
              title: l10n.suggestionsTitle,
              subtitle: l10n.suggestionsSubtitle,
            ),
            const SizedBox(height: 24),
            Column(
              spacing: 14,
              children: options
                  .map(
                    (o) => SupportOptionCard(
                      type: o.type,
                      label: l10n.supportTypeLabel(o.type),
                      why: o.why,
                      onTap: () => onSelect(o),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
