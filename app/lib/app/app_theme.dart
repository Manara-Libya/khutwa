import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  // Core palette.
  static const primary = Color(0xFF1A365D); // Deep Navy
  static const secondary = Color(0xFF00B4D8); // Vibrant Cyan
  static const background = Color(0xFFF8FAFC); // Soft Off-White
  static const card = Color(0xFFFFFFFF); // Pure White
  static const text = Color(0xFF0F172A); // Slate Dark

  // Derived neutrals and tints.
  static const textMuted = Color(0xFF475569);
  static const border = Color(0xFFE2E8F0);
  static const urgent = Color(0xFFDC2626);
  static final secondarySoft = secondary.withValues(alpha: 0.12);
  static final chatGradientEnd = Color.lerp(primary, secondary, 0.45)!;
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
  /// Pass [useGoogleFonts] = false where the font can't be fetched (tests).
  static ThemeData light({bool useGoogleFonts = true}) {
    // House rule: `surface` is the page background, `surfaceContainer` is
    // for cards and other raised surfaces.
    const colors = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.primary,
      error: AppColors.urgent,
      onError: Colors.white,
      surface: AppColors.background,
      surfaceContainer: AppColors.card,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.textMuted,
      outline: AppColors.border,
    );

    const baseText = TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.35,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
    );
    final colored = baseText.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );
    final text = useGoogleFonts ? _withCairo(colored) : colored;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: text,
      cardTheme: CardThemeData(
        color: colors.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.outline),
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
          shape: const StadiumBorder(),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: BorderSide(color: colors.outline, width: 1.5),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.onSurfaceVariant,
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainer,
        hintStyle: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colors.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.primary,
        contentTextStyle: text.bodyMedium?.copyWith(color: colors.onPrimary),
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
