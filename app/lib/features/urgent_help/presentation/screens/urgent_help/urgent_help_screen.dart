import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/verified_contact.dart';
import 'widgets/urgent_step.dart';

/// The urgent-help screen (#55): fixed text only, never AI text. Built from
/// compiled-in data, so it opens offline.
class UrgentHelpScreen extends StatelessWidget {
  const UrgentHelpScreen({
    super.key,
    required this.contacts,
    required this.verifiedOnLabel,
    required this.onCall,
    required this.onBack,
  });

  /// Verified contacts only; when empty, step 3 is not shown.
  final List<VerifiedContact> contacts;

  /// Formats a verified-on date for the current locale.
  final String Function(DateTime date) verifiedOnLabel;
  final ValueChanged<VerifiedContact> onCall;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = context.textStyles;
    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            0,
            AppSpacing.screenHorizontal,
            32,
          ),
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 56,
              color: AppColors.urgent,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.urgentScreenTitle,
              textAlign: TextAlign.center,
              style: text.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.urgentScreenBody,
              textAlign: TextAlign.center,
              style: text.bodyLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            Column(
              spacing: 24,
              children: [
                UrgentStep(number: 1, text: l10n.urgentStep1),
                UrgentStep(number: 2, text: l10n.urgentStep2),
                if (contacts.isNotEmpty)
                  UrgentStep(
                    number: 3,
                    text: l10n.urgentStep3Title,
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: contacts
                          .map(
                            (c) => Column(
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FilledButton.icon(
                                  onPressed: () => onCall(c),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.urgent,
                                  ),
                                  icon: const Icon(Icons.call_rounded),
                                  label: Text(
                                    '${l10n.urgentCallContact(c.name)} · ${c.number}',
                                  ),
                                ),
                                Text(
                                  l10n.urgentVerifiedOn(
                                    verifiedOnLabel(c.verifiedOn),
                                  ),
                                  style: text.bodySmall,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
