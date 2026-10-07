import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/consent.dart';
import 'widgets/consent_widgets.dart';

class ConsentScreen extends StatelessWidget {
  const ConsentScreen({
    super.key,
    required this.consent,
    required this.onAgeConfirmedChanged,
    required this.onUnderstandsLimitsChanged,
    required this.onAcceptedTermsChanged,
    required this.onAgree,
    required this.onBack,
  });

  final Consent consent;
  final ValueChanged<bool> onAgeConfirmedChanged;
  final ValueChanged<bool> onUnderstandsLimitsChanged;
  final ValueChanged<bool> onAcceptedTermsChanged;
  final VoidCallback onAgree;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = context.textStyles;
    final link = TextStyle(
      color: context.colors.primary,
      fontWeight: FontWeight.w700,
    );
    final points = [
      // Everything #54 and #62 require. TODO(#62): reviewed texts.
      (Icons.smart_toy_outlined, l10n.consentPointAi),
      (Icons.shield_outlined, l10n.consentPointRedaction),
      (Icons.cloud_outlined, l10n.consentPointModel),
      (Icons.storage_outlined, l10n.consentPointNoStorage),
      (Icons.phone_android_rounded, l10n.consentPointPlan),
      (Icons.sos_rounded, l10n.consentPointNotEmergency),
    ];

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
                      title: l10n.consentTitle,
                      subtitle: l10n.consentSubtitle,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          spacing: 14,
                          children: points
                              .map((p) => ConsentPoint(icon: p.$1, text: p.$2))
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConsentCheckTile(
                      value: consent.ageConfirmed,
                      onChanged: onAgeConfirmedChanged,
                      child: Text(l10n.consentCheckAge, style: text.bodyMedium),
                    ),
                    ConsentCheckTile(
                      value: consent.understandsLimits,
                      onChanged: onUnderstandsLimitsChanged,
                      child: Text(
                        l10n.consentCheckUnderstand,
                        style: text.bodyMedium,
                      ),
                    ),
                    ConsentCheckTile(
                      value: consent.acceptedTerms,
                      onChanged: onAcceptedTermsChanged,
                      child: Text.rich(
                        TextSpan(
                          text: l10n.consentCheckTermsPrefix,
                          children: [
                            TextSpan(text: l10n.termsOfService, style: link),
                            TextSpan(text: l10n.termsAnd),
                            TextSpan(text: l10n.privacyPolicy, style: link),
                          ],
                        ),
                        style: text.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                label: l10n.consentAgree,
                onPressed: consent.isComplete ? onAgree : null,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
