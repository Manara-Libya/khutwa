import 'package:flutter/material.dart';

import '../../../../../app/app_theme.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../../utilities/app_button.dart';
import '../../../../../utilities/app_header.dart';
import '../../../../../utilities/app_screen_body.dart';
import '../../../domain/entities/suggestion_kind.dart';
import '../../support_l10n.dart';
import '../../providers/suggestions_state.dart';
import 'widgets/suggestion_card.dart';

class SuggestionsScreen extends StatelessWidget {
  const SuggestionsScreen({
    super.key,
    required this.state,
    required this.onSelect,
    required this.onToggleWhy,
    required this.onWriteDraft,
    required this.onBack,
  });

  final SuggestionsState state;
  final ValueChanged<SuggestionKind> onSelect;
  final ValueChanged<SuggestionKind> onToggleWhy;
  final VoidCallback onWriteDraft;
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
          child: Column(
            spacing: 12,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AppHeader(
                      title: l10n.suggestionsTitle,
                      subtitle: l10n.suggestionsSubtitle,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      spacing: 14,
                      children: state.suggestions
                          .map(
                            (kind) => SuggestionCard(
                              title: l10n.suggestionTitle(kind),
                              description: l10n.suggestionDesc(kind),
                              why: l10n.suggestionWhy(kind, state.reflection),
                              icon: _icon(kind),
                              selected: state.selected == kind,
                              whyVisible: state.expanded.contains(kind),
                              onTap: () => onSelect(kind),
                              onToggleWhy: () => onToggleWhy(kind),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              AppButton(
                label: l10n.suggestionsWriteDraft,
                onPressed: state.selected == null ? null : onWriteDraft,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _icon(SuggestionKind kind) => switch (kind) {
    SuggestionKind.trustedAdult => Icons.family_restroom_rounded,
    SuggestionKind.friend => Icons.people_alt_rounded,
    SuggestionKind.counselor => Icons.school_rounded,
    SuggestionKind.specialist => Icons.medical_services_outlined,
    SuggestionKind.selfNote => Icons.edit_note_rounded,
  };
}
