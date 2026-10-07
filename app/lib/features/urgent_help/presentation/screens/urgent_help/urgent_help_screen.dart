import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/emergency_contact.dart';
import 'widgets/contact_card.dart';
import 'widgets/message_card.dart';
import 'widgets/urgent_step.dart';

/// The urgent-help screen (#55): fixed, team-reviewed text only, never AI
/// text. Built from compiled-in data, so it works offline.
class UrgentHelpScreen extends StatelessWidget {
  const UrgentHelpScreen({
    super.key,
    required this.contacts,
    required this.autoOpened,
    required this.verifiedOnLabel,
    required this.onCall,
    required this.onCopyMessage,
    required this.onBack,
  });

  /// Verified numbers, plus labelled demo numbers in demo builds.
  final List<EmergencyContact> contacts;

  /// Opened after a message (`urgent: true`) rather than by the button.
  final bool autoOpened;

  /// Formats a verified-on date for the current locale.
  final String Function(DateTime date) verifiedOnLabel;
  final ValueChanged<EmergencyContact> onCall;
  final VoidCallback onCopyMessage;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = context.textStyles;
    final muted = context.colors.onSurfaceVariant;
    final steps = [
      l10n.urgentStepPerson,
      l10n.urgentStepHospital,
      l10n.urgentStepSafeSpace,
    ];

    return Scaffold(
      body: AppScreenBody(
        leading: AppBackButton(onPressed: onBack),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            8,
            AppSpacing.screenHorizontal,
            32,
          ),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Icon(
                Icons.warning_amber_rounded,
                size: 44,
                color: context.brand.urgent,
              ),
            ),
            const SizedBox(height: 12),
            AppHeader(
              title: l10n.urgentSafetyTitle,
              subtitle: autoOpened ? l10n.urgentIntroAuto : null,
            ),
            const SizedBox(height: 28),
            Column(
              spacing: 20,
              children: steps
                  .asMap()
                  .entries
                  .map((s) => UrgentStep(number: s.key + 1, text: s.value))
                  .toList(),
            ),
            const SizedBox(height: 32),
            Text(l10n.urgentContactsTitle, style: text.titleLarge),
            const SizedBox(height: 12),
            if (contacts.isEmpty)
              Text(
                l10n.urgentNoContacts,
                style: text.bodyMedium?.copyWith(color: muted),
              )
            else
              Column(
                spacing: 12,
                children: contacts
                    .map(
                      (c) => ContactCard(
                        name: c.name,
                        number: c.number,
                        description: c.description,
                        isDemo: c.isDemo,
                        note: switch (c.verifiedOn) {
                          final date? when !c.isDemo =>
                            l10n.urgentContactVerified(verifiedOnLabel(date)),
                          _ => l10n.urgentContactDemo,
                        },
                        callLabel: l10n.urgentCallNow,
                        onCall: () => onCall(c),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 28),
            MessageCard(
              title: l10n.urgentMessageTitle,
              message: l10n.urgentMessageText,
              copyLabel: l10n.urgentCopy,
              onCopy: onCopyMessage,
            ),
            const SizedBox(height: 28),
            Text(
              l10n.urgentFooter,
              style: text.bodySmall?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}
