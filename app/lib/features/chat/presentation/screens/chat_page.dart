import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../app/l10n/l10n.dart';
import '../../../support/domain/entities/draft_request.dart';
import '../../../support/domain/entities/suggestion_kind.dart';
import '../../../urgent_help/presentation/screens/urgent_help/urgent_help_page.dart';
import '../../domain/entities/a2ui_surface.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/reflection.dart';
import '../providers/chat_repository_provider.dart';
import 'chat_controller.dart';
import 'chat_screen.dart';
import 'chat_validators.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late final ScrollController _scrollController;
  late final ChatController _controller;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = ChatController(
      session: ref.read(chatProvider.notifier),
      validator: (v) => validateChatMessage(v, context.l10n),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);

    ref.listen(chatProvider, (_, next) {
      _scrollToBottom();
    });

    return ChatScreen(
      nickname: state.nickname,
      personality: state.personality,
      messages: state.messages,
      isTyping: state.isTyping,
      inputController: _controller.input,
      inputError: _controller.error,
      scrollController: _scrollController,
      onSend: _controller.send,
      onVoice: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.comingSoon)));
      },
      onListen: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.comingSoon)));
      },
      onSeeSuggestions: (reflection) {
        context.push(AppRoutes.suggestions, extra: reflection);
      },
      onUrgentHelp: () => showUrgentHelp(context),
      onAiAction: _onAiAction,
    );
  }

  /// Handles a tap on an AI (A2UI) card button: tells the session, then
  /// does the UI side of the action.
  void _onAiAction(AiSurfaceMessage message, A2uiAction action) {
    ref.read(chatProvider.notifier).chooseAiAction(message, action);

    // The draft is written from what the user said when asking for help.
    final reflection = Reflection(
      topic: action.context['topic'] ?? '',
      feeling: Feeling.unclear,
    );
    void openDraft(SuggestionKind kind) => context.push(
      AppRoutes.draft,
      extra: DraftRequest(kind: kind, reflection: reflection),
    );

    switch (action.name) {
      case 'contact_specialist':
        openDraft(SuggestionKind.specialist);
      case 'talk_trusted_adult':
        openDraft(SuggestionKind.trustedAdult);
      case 'urgent_help':
        showUrgentHelp(context);
      // Other actions (e.g. calming_exercise) are answered by the AI.
    }
  }
}
