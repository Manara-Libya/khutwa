import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../features/analysis/data/repositories/api_analysis_repository.dart';
import '../features/analysis/data/repositories/mock_analysis_repository.dart';
import '../features/analysis/domain/repositories/analysis_repository.dart';
import '../features/analysis/presentation/providers/analysis_repository_provider.dart';
import '../features/onboarding/data/repositories/in_memory_profile_repository.dart';
import '../features/onboarding/presentation/providers/onboarding_repository_provider.dart';
import '../features/privacy/data/repositories/channel_redactor.dart';
import '../features/privacy/data/repositories/stub_redactor.dart';
import '../features/privacy/presentation/providers/privacy_repository_provider.dart';
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
/// [showDemoContacts]: overrides `AppConfig.showDemoContacts` (tests).
List<Override> appOverrides({
  bool? useKotlinRedactor,
  Duration mockApiDelay = const Duration(seconds: 2),
  AnalysisRepository? analysisRepository,
  bool? showDemoContacts,
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
  emergencyRepositoryProvider.overrideWithValue(
    StaticEmergencyRepository([
      ...StaticEmergencyRepository.verified,
      if (showDemoContacts ?? AppConfig.showDemoContacts)
        ...StaticEmergencyRepository.demo,
    ]),
  ),
  profileRepositoryProvider.overrideWithValue(InMemoryProfileRepository()),
];

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  // Cairo is bundled in assets/google_fonts/, so fonts never need the
  // network (the urgent screen must work offline, #55).
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(ProviderScope(overrides: appOverrides(), child: const KhutwaApp()));
}
