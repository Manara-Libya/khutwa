import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/analysis/domain/entities/analysis_result.dart';
import '../features/analysis/presentation/screens/message_draft/message_draft_page.dart';
import '../features/analysis/presentation/screens/reflection/reflection_page.dart';
import '../features/analysis/presentation/screens/support_options/support_options_page.dart';
import '../features/analysis/presentation/screens/write/write_page.dart';
import '../features/chat/domain/entities/reflection.dart';
import '../features/chat/presentation/screens/chat_page.dart';
import '../features/onboarding/presentation/screens/age/age_page.dart';
import '../features/onboarding/presentation/screens/consent/consent_page.dart';
import '../features/onboarding/presentation/screens/nickname/nickname_page.dart';
import '../features/onboarding/presentation/screens/persona/persona_page.dart';
import '../features/onboarding/presentation/screens/support_preference/support_preference_page.dart';
import '../features/onboarding/presentation/screens/welcome/welcome_page.dart';
import '../features/plan/presentation/screens/plan/plan_page.dart';
import '../features/privacy/domain/entities/redaction_result.dart';
import '../features/privacy/presentation/screens/privacy_panel/privacy_panel_page.dart';
import '../features/support/domain/entities/draft_request.dart';
import '../features/urgent_help/presentation/screens/urgent_help/urgent_help_page.dart';
import '../features/support/presentation/screens/draft/draft_page.dart';
import '../features/support/presentation/screens/suggestions/suggestions_page.dart';
import 'app_routes.dart';
import 'app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.welcome,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.welcome,
            builder: (_, _) => const WelcomePage(),
          ),
          GoRoute(
            path: AppRoutes.consent,
            builder: (_, _) => const ConsentPage(),
          ),
          // Demo path (#54). Screens that need data from the previous one
          // fall back to the write screen without it (e.g. a deep link).
          GoRoute(path: AppRoutes.write, builder: (_, _) => const WritePage()),
          GoRoute(
            path: AppRoutes.privacyPanel,
            redirect: (_, state) =>
                state.extra is String ? null : AppRoutes.write,
            builder: (_, state) =>
                PrivacyPanelPage(text: state.extra! as String),
          ),
          GoRoute(
            path: AppRoutes.reflection,
            redirect: (_, state) =>
                state.extra is RedactionResult ? null : AppRoutes.write,
            builder: (_, state) =>
                ReflectionPage(redaction: state.extra! as RedactionResult),
          ),
          GoRoute(
            path: AppRoutes.supportOptions,
            redirect: (_, state) =>
                state.extra is List<SupportSuggestion> ? null : AppRoutes.write,
            builder: (_, state) => SupportOptionsPage(
              options: state.extra! as List<SupportSuggestion>,
            ),
          ),
          GoRoute(
            path: AppRoutes.messageDraft,
            redirect: (_, state) =>
                state.extra is SupportSuggestion ? null : AppRoutes.write,
            builder: (_, state) =>
                MessageDraftPage(suggestion: state.extra! as SupportSuggestion),
          ),
          // #55: both work offline.
          GoRoute(path: AppRoutes.plan, builder: (_, _) => const PlanPage()),
          GoRoute(
            path: AppRoutes.urgent,
            builder: (_, _) => const UrgentHelpPage(),
          ),
          // Earlier onboarding/chat screens, not on the demo path.
          GoRoute(
            path: AppRoutes.nickname,
            builder: (_, _) => const NicknamePage(),
          ),
          GoRoute(path: AppRoutes.age, builder: (_, _) => const AgePage()),
          GoRoute(
            path: AppRoutes.persona,
            builder: (_, _) => const PersonaPage(),
          ),
          GoRoute(
            path: AppRoutes.supportPreference,
            builder: (_, _) => const SupportPreferencePage(),
          ),
          GoRoute(path: AppRoutes.chat, builder: (_, _) => const ChatPage()),
          // These two need data from the previous screen; without it
          // (e.g. a deep link) they fall back to the chat.
          GoRoute(
            path: AppRoutes.suggestions,
            redirect: (_, state) =>
                state.extra is Reflection ? null : AppRoutes.chat,
            builder: (_, state) =>
                SuggestionsPage(reflection: state.extra! as Reflection),
          ),
          GoRoute(
            path: AppRoutes.draft,
            redirect: (_, state) =>
                state.extra is DraftRequest ? null : AppRoutes.chat,
            builder: (_, state) =>
                DraftPage(request: state.extra! as DraftRequest),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
