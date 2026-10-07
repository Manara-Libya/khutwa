import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/analysis/domain/entities/analysis_result.dart';
import '../features/analysis/presentation/screens/conversation/conversation_page.dart';
import '../features/analysis/presentation/screens/message_draft/message_draft_page.dart';
import '../features/analysis/presentation/screens/support_options/support_options_page.dart';
import '../features/onboarding/presentation/screens/consent/consent_page.dart';
import '../features/urgent_help/presentation/screens/urgent_help/urgent_help_page.dart';
import 'app_routes.dart';
import 'app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.consent,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.consent,
            builder: (_, _) => const ConsentPage(),
          ),
          GoRoute(
            path: AppRoutes.chat,
            builder: (_, _) => const ConversationPage(),
          ),
          // These need data from the previous screen; without it (e.g. a
          // deep link) they fall back to the chat.
          GoRoute(
            path: AppRoutes.supportOptions,
            redirect: (_, state) =>
                state.extra is List<SupportSuggestion> ? null : AppRoutes.chat,
            builder: (_, state) => SupportOptionsPage(
              options: state.extra! as List<SupportSuggestion>,
            ),
          ),
          GoRoute(
            path: AppRoutes.messageDraft,
            redirect: (_, state) =>
                state.extra is SupportSuggestion ? null : AppRoutes.chat,
            builder: (_, state) =>
                MessageDraftPage(suggestion: state.extra! as SupportSuggestion),
          ),
          GoRoute(
            path: AppRoutes.urgent,
            builder: (_, state) => UrgentHelpPage(
              autoOpened: state.extra == urgentOpenedAutomatically,
            ),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
