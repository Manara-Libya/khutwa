import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../privacy/domain/entities/redaction_result.dart';
import '../../../domain/entities/support_type.dart';
import '../../analysis_l10n.dart';
import '../../providers/analysis_repository_provider.dart';
import 'reflection_screen.dart';

class ReflectionPage extends ConsumerWidget {
  const ReflectionPage({super.key, required this.redaction});

  /// The redaction the user approved in the privacy panel.
  final RedactionResult redaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = analysisProvider(redaction);

    // urgent: true → the urgent screen and nothing else. `go` replaces the
    // whole stack, so no AI text can be reached with Back either.
    ref.listen(provider, (_, next) {
      if (next.value?.isUrgent ?? false) context.go(AppRoutes.urgent);
    });

    final state = ref.watch(provider);
    final result = state.value;
    final status = switch (state) {
      AsyncError() => ReflectionStatus.failed,
      AsyncData() when !result!.isUrgent => ReflectionStatus.ready,
      // Loading, or urgent while the redirect happens: show no AI text.
      _ => ReflectionStatus.loading,
    };

    return ReflectionScreen(
      status: status,
      reflection: result?.reflection,
      onSeeOptions: () {
        // fallback: true → the reflection plus generic support options.
        // The API's own suggestions win over generic ones of the same type.
        final seen = <SupportType>{};
        final options = result!.fallback || result.suggestions.isEmpty
            ? [
                ...result.suggestions,
                ...context.l10n.genericSupportOptions,
              ].where((s) => seen.add(s.type)).take(3).toList()
            : result.suggestions;
        context.push(AppRoutes.supportOptions, extra: options);
      },
      onRetry: ref.read(provider.notifier).retry,
      onBack: context.pop,
    );
  }
}
