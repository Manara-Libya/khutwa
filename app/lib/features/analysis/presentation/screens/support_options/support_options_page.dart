import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../domain/entities/analysis_result.dart';
import 'support_options_screen.dart';

/// No Riverpod state needed: the options come from the reflection screen.
class SupportOptionsPage extends StatelessWidget {
  const SupportOptionsPage({super.key, required this.options});

  final List<SupportSuggestion> options;

  @override
  Widget build(BuildContext context) {
    return SupportOptionsScreen(
      options: options,
      onSelect: (option) => context.push(AppRoutes.messageDraft, extra: option),
      onBack: context.pop,
    );
  }
}
