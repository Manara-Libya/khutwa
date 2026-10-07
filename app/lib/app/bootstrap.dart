import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/storage/local_data_wiper.dart';
import '../features/analysis/data/repositories/api_analysis_repository.dart';
import '../features/analysis/data/repositories/mock_analysis_repository.dart';
import '../features/analysis/domain/repositories/analysis_repository.dart';
import '../features/analysis/presentation/providers/analysis_repository_provider.dart';
import '../features/chat/data/local_reflection_repository.dart';
import '../features/chat/data/repositories/mock_chat_repository.dart';
import '../features/chat/presentation/providers/chat_repository_provider.dart';
import '../features/onboarding/data/repositories/in_memory_profile_repository.dart';
import '../features/onboarding/presentation/providers/onboarding_repository_provider.dart';
import '../features/plan/data/repositories/prefs_plan_repository.dart';
import '../features/plan/presentation/providers/plan_repository_provider.dart';
import '../features/privacy/data/repositories/channel_redactor.dart';
import '../features/privacy/data/repositories/stub_redactor.dart';
import '../features/privacy/presentation/providers/privacy_repository_provider.dart';
import '../features/support/data/repositories/rule_based_support_repository.dart';
import '../features/support/presentation/providers/support_repository_provider.dart';
import '../features/urgent_help/data/repositories/static_emergency_repository.dart';
import '../features/urgent_help/presentation/providers/urgent_help_repository_provider.dart';
import 'app.dart';
import 'app_config.dart';

/// Composition root: the one place abstract repositories are bound to
/// concrete implementations.
///
/// [useKotlinRedactor]: on Android the Kotlin `Redactor` (#53) runs behind a
/// platform channel; elsewhere (and in tests) the Dart stub is used.
/// [mockApiDelay]: the offline mock's simulated wait, when no API is set.
/// [analysisRepository]: replaces the API client (tests).
List<Override> appOverrides({
  bool? useKotlinRedactor,
  Duration mockApiDelay = const Duration(seconds: 2),
  AnalysisRepository? analysisRepository,
}) => [
  redactorProvider.overrideWithValue(
    (useKotlinRedactor ??
            (!kIsWeb && defaultTargetPlatform == TargetPlatform.android))
        ? const ChannelRedactor()
        : const StubRedactor(),
  ),
  analysisRepositoryProvider.overrideWith(
    (ref) =>
        analysisRepository ??
        (AppConfig.useMockApi
        ? MockAnalysisRepository(delay: mockApiDelay)
        : ApiAnalysisRepository(
            baseUrl: AppConfig.apiUrl,
            apiKey: AppConfig.apiKey,
          )),
  ),
  planRepositoryProvider.overrideWith((ref) => PrefsPlanRepository()),
  localDataWiperProvider.overrideWith((ref) => PrefsLocalDataWiper()),
  emergencyRepositoryProvider.overrideWithValue(
    const StaticEmergencyRepository(StaticEmergencyRepository.verified),
  ),
  // Earlier onboarding/chat screens, not on the demo path.
  profileRepositoryProvider.overrideWithValue(InMemoryProfileRepository()),
  reflectionRepositoryProvider.overrideWithValue(
    const LocalReflectionRepository(),
  ),
  chatAiRepositoryProvider.overrideWith((ref) => MockChatRepository()),
  supportRepositoryProvider.overrideWithValue(
    const RuleBasedSupportRepository(),
  ),
];

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  // Cairo is bundled in assets/google_fonts/, so fonts never need the
  // network (offline plan and urgent screen, #55).
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(ProviderScope(overrides: appOverrides(), child: const KhutwaApp()));
}
