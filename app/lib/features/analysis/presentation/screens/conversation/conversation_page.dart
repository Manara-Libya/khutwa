import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../app/l10n/l10n.dart';
import '../../../../urgent_help/presentation/screens/urgent_help/urgent_help_page.dart';
import '../../../domain/entities/support_type.dart';
import '../../analysis_l10n.dart';
import '../../providers/analysis_repository_provider.dart';
import 'conversation_controller.dart';
import 'conversation_screen.dart';
import 'conversation_validators.dart';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({super.key});

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  final _scroll = ScrollController();
  ConversationController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= ConversationController(
      session: ref.read(conversationProvider.notifier),
      validator: ConversationValidators.message(context.l10n),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _seeOptions() {
    final result = ref.read(conversationProvider).latest!;
    // fallback: true (or no suggestions) → add generic options. The API's
    // own suggestions win over generic ones of the same type.
    final seen = <SupportType>{};
    final options = result.fallback || result.suggestions.isEmpty
        ? [
            ...result.suggestions,
            ...context.l10n.genericSupportOptions,
          ].where((s) => seen.add(s.type)).take(3).toList()
        : result.suggestions;
    context.push(AppRoutes.supportOptions, extra: options);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversationProvider);
    ref.listen(conversationProvider, (previous, next) {
      // urgent: true → the urgent screen and nothing else; `go` replaces
      // the stack so no AI text can be reached with Back.
      if (next.latest?.isUrgent ?? false) {
        context.go(AppRoutes.urgent, extra: urgentOpenedAutomatically);
        return;
      }
      if (previous?.entries.length != next.entries.length ||
          previous?.waiting != next.waiting) {
        _scrollToEnd();
      }
    });

    final notifier = ref.read(conversationProvider.notifier);
    return ConversationScreen(
      state: state,
      textController: _controller!.text,
      inputError: _controller!.error,
      scrollController: _scroll,
      onSend: _controller!.send,
      onRetry: notifier.retry,
      onSeeOptions: _seeOptions,
    );
  }
}
