import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_doodle.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import 'widgets/consent_widgets.dart';

/// "Our commitment to you": what Khutwa is, what leaves the phone, and one
/// explicit agreement before anything starts.
class ConsentScreen extends StatelessWidget {
  const ConsentScreen({
    super.key,
    required this.agreed,
    required this.onAgreedChanged,
    required this.onAgree,
    required this.onToggleLanguage,
  });

  final bool agreed;
  final ValueChanged<bool> onAgreedChanged;
  final VoidCallback onAgree;
  final VoidCallback onToggleLanguage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Everything #54 and #62 require. TODO(#62): reviewed texts.
    final points = [
      (Icons.smart_toy_outlined, l10n.consentPointAi),
      (Icons.shield_outlined, l10n.consentPointRedaction),
      (Icons.cloud_outlined, l10n.consentPointModel),
      (Icons.storage_outlined, l10n.consentPointNoStorage),
      (Icons.phone_android_rounded, l10n.consentPointPlan),
      (Icons.sos_rounded, l10n.consentPointNotEmergency),
    ];

    return Scaffold(
      body: AppScreenBody(
        actions: [
          TextButton.icon(
            onPressed: onToggleLanguage,
            icon: const Icon(Icons.language_rounded),
            label: Text(l10n.switchLanguage),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            spacing: 16,
            children: [
              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    const Center(child: AppDoodle.lock(size: 110)),
                    const SizedBox(height: 16),
                    AppHeader(
                      title: l10n.consentHeading,
                      subtitle: l10n.consentIntro,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      spacing: 14,
                      children: points
                          .map((p) => ConsentPoint(icon: p.$1, text: p.$2))
                          .toList(),
                    ),
                    const SizedBox(height: 32),

                    ConsentToggleCard(
                      value: agreed,
                      onChanged: onAgreedChanged,
                      label: l10n.consentToggle,
                    ),
                  ],
                ),
              ),
              AppButton(
                label: l10n.consentAgree,
                onPressed: agreed ? onAgree : null,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
