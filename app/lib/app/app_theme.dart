import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Calm, editorial palette: warm cream pages, near-black ink, hand-drawn
/// line art, and black "focus" screens for the conversation.
abstract final class AppColors {
  static const cream = Color(0xFFF3F1EC); // page background
  static const ink = Color(0xFF1F1B17); // text, primary buttons
  static const card = Color(0xFFFFFFFF); // raised surfaces
  static const muted = Color(0xFF6B655E); // secondary text
  static const line = Color(0xFFE4E0D8); // hairlines

  static const night = Color(0xFF000000); // dark screens
  static const nightCard = Color(0xFF161616);
  static const nightMuted = Color(0xFFA8A29A);
  static const nightLine = Color(0xFF2A2A2A);

  static const lavender = Color(0xFFCFCBF2); // illustration accent
  static const mint = Color(0xFF8ED19B); // toggles, success
  static const urgent = Color(0xFFD93B30); // 🆘 only
}

abstract final class AppSpacing {
  /// Height of the top bar header container.
  static const topBarHeight = 56.0;

  /// Default top spacing for screen content below the top bar.
  static const screenTop = 300.0;

  /// Horizontal padding for screen content.
  static const screenHorizontal = 24.0;
}

abstract final class AppTheme {
  /// Pass [useGoogleFonts] = false where the font can't be loaded (tests).
  static ThemeData light({bool useGoogleFonts = true}) {
    // House rule: `surface` is the page background, `surfaceContainer` is
    // for cards and other raised surfaces.
    const colors = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.ink,
      onPrimary: Colors.white,
      secondary: AppColors.mint,
      onSecondary: AppColors.ink,
      error: AppColors.urgent,
      onError: Colors.white,
      surface: AppColors.cream,
      surfaceContainer: AppColors.card,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.muted,
      outline: AppColors.line,
    );
    final text = _textTheme(colors, useGoogleFonts: useGoogleFonts);
    return _build(colors, text);
  }

  /// The dark "focus" variant of [light], keeping its fonts.
  static ThemeData dark(ThemeData light) {
    const colors = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: AppColors.night,
      secondary: AppColors.mint,
      onSecondary: AppColors.ink,
      error: AppColors.urgent,
      onError: Colors.white,
      surface: AppColors.night,
      surfaceContainer: AppColors.nightCard,
      onSurface: Colors.white,
      onSurfaceVariant: AppColors.nightMuted,
      outline: AppColors.nightLine,
    );
    final text = light.textTheme.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );
    return _build(colors, text);
  }

  static TextTheme _textTheme(
    ColorScheme colors, {
    required bool useGoogleFonts,
  }) {
    const base = TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.35,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    );
    final colored = base.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );
    return useGoogleFonts ? _withCairo(colored) : colored;
  }

  static ThemeData _build(ColorScheme colors, TextTheme text) {
    const radius = BorderRadius.all(Radius.circular(18));
    final buttonShape = const RoundedRectangleBorder(borderRadius: radius);
    OutlineInputBorder field(Color color, double width) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: width == 0
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: text,
      cardTheme: CardThemeData(
        color: colors.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.primary.withValues(alpha: 0.25),
          disabledForegroundColor: colors.onPrimary.withValues(alpha: 0.7),
          minimumSize: const Size.fromHeight(56),
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.onSurface,
          minimumSize: const Size.fromHeight(56),
          shape: buttonShape,
          side: BorderSide(color: colors.onSurface, width: 1.5),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.onSurface,
          textStyle: text.labelLarge,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.mint
              : colors.outline,
        ),
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainer,
        hintStyle: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: field(colors.outline, 0),
        focusedBorder: field(colors.onSurface, 1.5),
        errorBorder: field(colors.error, 1.5),
        focusedErrorBorder: field(colors.error, 2),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.onSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: colors.surface),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Applies the Cairo font (Arabic + Latin) to every style in [t].
  static TextTheme _withCairo(TextTheme t) {
    TextStyle? cairo(TextStyle? s) =>
        s == null ? null : GoogleFonts.cairo(textStyle: s);
    return t.copyWith(
      displaySmall: cairo(t.displaySmall),
      headlineMedium: cairo(t.headlineMedium),
      titleLarge: cairo(t.titleLarge),
      titleMedium: cairo(t.titleMedium),
      bodyLarge: cairo(t.bodyLarge),
      bodyMedium: cairo(t.bodyMedium),
      bodySmall: cairo(t.bodySmall),
      labelLarge: cairo(t.labelLarge),
    );
  }
}

extension ThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
}
