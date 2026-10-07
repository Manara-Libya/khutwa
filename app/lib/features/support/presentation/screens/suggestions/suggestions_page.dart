import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../../chat/domain/entities/reflection.dart';
import '../../../domain/entities/draft_request.dart';
import '../../providers/support_repository_provider.dart';
import 'suggestions_screen.dart';

class SuggestionsPage extends ConsumerWidget {
  const SuggestionsPage({super.key, required this.reflection});

  final Reflection reflection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = suggestionsProvider(reflection);
    final state = ref.watch(provider);
    final session = ref.read(provider.notifier);
    return SuggestionsScreen(
      state: state,
      onSelect: session.select,
      onToggleWhy: session.toggleWhy,
      onWriteDraft: () => context.push(
        AppRoutes.draft,
        extra: DraftRequest(kind: state.selected!, reflection: reflection),
      ),
      onBack: context.pop,
    );
  }
}
