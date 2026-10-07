import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_fill_scroll_view.dart';
import '../../../../../utilities/app_mascot.dart';
import '../../../../../utilities/app_screen_body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onNext,
    required this.onToggleLanguage,
  });

  final VoidCallback onNext;
  final VoidCallback onToggleLanguage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = context.textStyles;
    final colors = context.colors;

    return Scaffold(
      body: AppScreenBody(
        actions: [
          TextButton.icon(
            onPressed: onToggleLanguage,
            style: TextButton.styleFrom(foregroundColor: colors.primary),
            icon: const Icon(Icons.language_rounded),
            label: Text(l10n.switchLanguage),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: AppFillScrollView(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: AppColors.secondarySoft,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.bottomCenter,
                child: const AppMascot(size: 170),
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(l10n.welcomeGreeting, style: text.displaySmall),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [colors.primary, colors.secondary],
                    ).createShader(bounds),
                    child: Text(
                      l10n.appName,
                      style: text.displaySmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: text.bodyLarge?.copyWith(
                  fontSize: 19,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: 76,
                height: 76,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: onNext,
                  tooltip: l10n.continueLabel,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: const CircleBorder(),
                  // matchTextDirection: points right in LTR and left in RTL.
                  child: const Icon(Icons.arrow_forward_rounded, size: 32),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
