import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The user's chosen locale; null follows the device language.
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  /// Switches between Arabic and English, given the locale currently shown.
  void toggle(Locale current) =>
      state = Locale(current.languageCode == 'ar' ? 'en' : 'ar');
}
