import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'app_theme.dart';
import 'l10n/l10n.dart';
import 'locale_provider.dart';

class KhutwaApp extends ConsumerWidget {
  const KhutwaApp({super.key, this.useGoogleFonts = true});

  final bool useGoogleFonts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(useGoogleFonts: useGoogleFonts),
      locale: ref.watch(localeProvider),
      // Arabic first: it is the fallback for unsupported device languages.
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
