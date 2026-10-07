import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The Khutwa design system colours (brand `tokens/tokens.json`), light
/// theme. Green is a ground, never text on paper: use [greenDeep] for that.
abstract final class AppColors {
  static const paper = Color(0xFFF4F1EA); // page ground
  static const paperRaised = Color(
    0xFFFCFAF5,
  ); // cards, assistant bubbles, fields
  static const paperSunk = Color(0xFFEAE6DB); // wells, disabled
  static const ink = Color(0xFF1F2A1D); // text and every pen outline
  static const inkMuted = Color(0xFF56624F); // secondary copy
  static const line = Color(0xFFDAD5C8); // decorative hairlines only
  static const border = Color(0xFF757E6B); // control borders at rest (3:1)

  static const green = Color(0xFF9DD99D); // primary buttons, user bubbles
  static const onGreen = Color(0xFF1F2A1D); // text on green, clay and sun
  static const greenSoft = Color(0xFFDDF0D9); // selected cards, success
  static const greenDeep = Color(0xFF2A6A37); // green as text: links, ticks
  static const clay = Color(0xFFF0B594); // illustration accent
  static const claySoft = Color(0xFFFAE6D8); // "a person you trust" cards
  static const sun = Color(0xFFF4D67C); // second illustration accent
  static const sunSoft = Color(0xFFFBF0CC); // redacted words, gentle notices

  static const urgent = Color(0xFFB4432B); // 🆘 only, never an error
  static const onUrgent = Color(0xFFFFFFFF);

  static const shadow = Color(0xFF1F2A1D); // the print shadow
}

/// Dark-theme values of the same tokens.
abstract final class AppColorsDark {
  static const paper = Color(0xFF151B14);
  static const paperRaised = Color(0xFF1E261C);
  static const paperSunk = Color(0xFF0F140E);
  static const ink = Color(0xFFEEF1E6);
  static const inkMuted = Color(0xFFA9B3A2);
  static const line = Color(0xFF2E382B);
  static const border = Color(0xFF7C8672);

  static const greenSoft = Color(0xFF263A26);
  static const greenDeep = Color(0xFF9DD99D);
  static const clay = Color(0xFFE9A882);
  static const claySoft = Color(0xFF3A2A20);
  static const sun = Color(0xFFEBCB6B);
  static const sunSoft = Color(0xFF3A3319);

  static const urgent = Color(0xFFF29A7E);
  static const onUrgent = Color(0xFF1F1410);

  static const shadow = Color(0xFF0A0D09);
}

abstract final class AppSpacing {
  /// Height of the top bar header container.
  static const topBarHeight = 56.0;

  /// Default top spacing for screen content below the top bar.
  static const screenTop = 300.0;

  /// Horizontal padding for screen content.
  static const screenHorizontal = 24.0;
}

/// Radii from the design system.
abstract final class AppRadius {
  static const sm = 8.0; // chips in text, a bubble's tail corner
  static const md = 16.0; // inputs, small cards
  static const lg = 24.0; // cards, chat bubbles
  static const xl = 32.0; // sheets, the urgent-help panel
}

/// Pen strokes from the design system.
abstract final class AppStroke {
  static const hand = 2.0; // outline of buttons, cards and bubbles
  static const bold = 3.0; // focus ring
}

/// Brand colours that [ColorScheme] has no slot for, per theme.
@immutable
class KhutwaColors extends ThemeExtension<KhutwaColors> {
  const KhutwaColors({
    required this.greenDeep,
    required this.clay,
    required this.claySoft,
    required this.sun,
    required this.sunSoft,
    required this.urgent,
    required this.onUrgent,
    required this.shadow,
  });

  static const light = KhutwaColors(
    greenDeep: AppColors.greenDeep,
    clay: AppColors.clay,
    claySoft: AppColors.claySoft,
    sun: AppColors.sun,
    sunSoft: AppColors.sunSoft,
    urgent: AppColors.urgent,
    onUrgent: AppColors.onUrgent,
    shadow: AppColors.shadow,
  );

  static const dark = KhutwaColors(
    greenDeep: AppColorsDark.greenDeep,
    clay: AppColorsDark.clay,
    claySoft: AppColorsDark.claySoft,
    sun: AppColorsDark.sun,
    sunSoft: AppColorsDark.sunSoft,
    urgent: AppColorsDark.urgent,
    onUrgent: AppColorsDark.onUrgent,
    shadow: AppColorsDark.shadow,
  );

  final Color greenDeep;
  final Color clay;
  final Color claySoft;
  final Color sun;
  final Color sunSoft;
  final Color urgent;
  final Color onUrgent;

  /// Colour of the hard, offset "print" shadow (see [printShadow]).
  final Color shadow;

  /// The one shadow in the system: 3px 4px, no blur.
  List<BoxShadow> get printShadow => [
    BoxShadow(color: shadow, offset: const Offset(3, 4)),
  ];

  @override
  KhutwaColors copyWith() => this;

  @override
  KhutwaColors lerp(KhutwaColors? other, double t) =>
      t < 0.5 || other == null ? this : other;
}

abstract final class AppTheme {
  /// Pass [useGoogleFonts] = false where the font can't be loaded (tests).
  static ThemeData light({bool useGoogleFonts = true}) {
    // House rule: `surface` is the page background, `surfaceContainer` is
    // for cards and other raised surfaces.
    const colors = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.green,
      onPrimary: AppColors.onGreen,
      primaryContainer: AppColors.greenSoft,
      onPrimaryContainer: AppColors.ink,
      secondary: AppColors.greenDeep,
      onSecondary: AppColors.paper,
      secondaryContainer: AppColors.claySoft,
      onSecondaryContainer: AppColors.ink,
      tertiary: AppColors.clay,
      onTertiary: AppColors.onGreen,
      tertiaryContainer: AppColors.sunSoft,
      onTertiaryContainer: AppColors.ink,
      // Not `urgent`: that colour is reserved for urgent help.
      error: AppColors.ink,
      onError: AppColors.paper,
      surface: AppColors.paper,
      surfaceContainer: AppColors.paperRaised,
      surfaceDim: AppColors.paperSunk,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkMuted,
      outline: AppColors.border,
      outlineVariant: AppColors.line,
      shadow: AppColors.shadow,
    );
    final text = _textTheme(colors, useGoogleFonts: useGoogleFonts);
    return _build(colors, text, KhutwaColors.light);
  }

  /// The dark variant of [light], keeping its fonts.
  static ThemeData dark(ThemeData light) {
    const colors = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.green,
      onPrimary: AppColors.onGreen,
      primaryContainer: AppColorsDark.greenSoft,
      onPrimaryContainer: AppColorsDark.ink,
      secondary: AppColorsDark.greenDeep,
      onSecondary: AppColors.onGreen,
      secondaryContainer: AppColorsDark.claySoft,
      onSecondaryContainer: AppColorsDark.ink,
      tertiary: AppColorsDark.clay,
      onTertiary: AppColors.onGreen,
      tertiaryContainer: AppColorsDark.sunSoft,
      onTertiaryContainer: AppColorsDark.ink,
      error: AppColorsDark.ink,
      onError: AppColorsDark.paper,
      surface: AppColorsDark.paper,
      surfaceContainer: AppColorsDark.paperRaised,
      surfaceDim: AppColorsDark.paperSunk,
      onSurface: AppColorsDark.ink,
      onSurfaceVariant: AppColorsDark.inkMuted,
      outline: AppColorsDark.border,
      outlineVariant: AppColorsDark.line,
      shadow: AppColorsDark.shadow,
    );
    final text = light.textTheme.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );
    return _build(colors, text, KhutwaColors.dark);
  }

  // Type scale from the design system. Display, headline and title styles
  // use the display face (Baloo Bhaijaan 2); body and label styles use the
  // body face (IBM Plex Sans Arabic).
  static TextTheme _textTheme(
    ColorScheme colors, {
    required bool useGoogleFonts,
  }) {
    const base = TextTheme(
      // display-xl: splash and banner headline, one per screen.
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 60 / 56,
        letterSpacing: -0.56,
      ),
      // display-lg: screen titles.
      displaySmall: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 46 / 40,
      ),
      // title: section titles, large card titles.
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 34 / 28,
      ),
      // heading: card headings.
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 24 / 17,
      ),
      // body-lg: chat messages.
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 30 / 18,
      ),
      // body: default copy.
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 26 / 16,
      ),
      // caption: helper text and disclosures.
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 18 / 13,
      ),
      // Button labels (display face, like `.kh-btn`).
      labelLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 24 / 17,
      ),
      // label: chips, field labels, small buttons.
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
      ),
    );
    final colored = base.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );
    return useGoogleFonts ? _withBrandFonts(colored) : colored;
  }

  static ThemeData _build(
    ColorScheme colors,
    TextTheme text,
    KhutwaColors brand,
  ) {
    const pill = StadiumBorder();
    final pen = BorderSide(color: colors.onSurface, width: AppStroke.hand);
    OutlineInputBorder field(Color color, double width) => OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
      borderSide: BorderSide(color: color, width: width),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: text,
      extensions: [brand],
      cardTheme: CardThemeData(
        color: colors.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
          side: pen,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      // Primary: green pill with the pen outline; AppButton adds the print
      // shadow.
      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              disabledBackgroundColor: colors.surfaceDim,
              disabledForegroundColor: colors.onSurfaceVariant,
              minimumSize: const Size.fromHeight(56),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: pill,
              side: const BorderSide(
                color: AppColors.onGreen,
                width: AppStroke.hand,
              ),
              elevation: 0,
              textStyle: text.labelLarge,
            ).copyWith(
              side: WidgetStateProperty.resolveWith(
                (states) => BorderSide(
                  color: states.contains(WidgetState.disabled)
                      ? colors.outline
                      : AppColors.onGreen,
                  width: AppStroke.hand,
                ),
              ),
            ),
      ),
      // Quiet: raised paper with an ink outline.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.onSurface,
          backgroundColor: colors.surfaceContainer,
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: pill,
          side: pen,
          textStyle: text.labelLarge,
        ),
      ),
      // Text: green-deep link.
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brand.greenDeep,
          textStyle: text.labelLarge,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.primary
              : colors.surfaceDim,
        ),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.onGreen
              : colors.outline,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.onGreen
              : colors.outline,
        ),
        trackOutlineWidth: const WidgetStatePropertyAll(AppStroke.hand),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceContainer,
        selectedColor: colors.primaryContainer,
        labelStyle: text.labelMedium,
        side: pen,
        shape: pill,
        padding: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainer,
        hintStyle: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: field(colors.outline, AppStroke.hand),
        focusedBorder: field(colors.onSurface, AppStroke.bold),
        errorBorder: field(colors.onSurface, AppStroke.hand),
        focusedErrorBorder: field(colors.onSurface, AppStroke.bold),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: brand.greenDeep,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.onSurface,
        selectionColor: colors.primary.withValues(alpha: 0.5),
        selectionHandleColor: brand.greenDeep,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.onSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: colors.surface),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
    );
  }

  /// Display face for headings and buttons, body face for everything else.
  static TextTheme _withBrandFonts(TextTheme t) {
    TextStyle? display(TextStyle? s) =>
        s == null ? null : GoogleFonts.balooBhaijaan2(textStyle: s);
    TextStyle? body(TextStyle? s) =>
        s == null ? null : GoogleFonts.ibmPlexSansArabic(textStyle: s);
    return t.copyWith(
      displayLarge: display(t.displayLarge),
      displaySmall: display(t.displaySmall),
      headlineMedium: display(t.headlineMedium),
      titleLarge: display(t.titleLarge),
      titleMedium: display(t.titleMedium),
      labelLarge: display(t.labelLarge),
      bodyLarge: body(t.bodyLarge),
      bodyMedium: body(t.bodyMedium),
      bodySmall: body(t.bodySmall),
      labelMedium: body(t.labelMedium),
    );
  }
}

extension ThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Brand colours outside [ColorScheme]: urgent, clay, sun, print shadow.
  KhutwaColors get brand =>
      Theme.of(this).extension<KhutwaColors>() ?? KhutwaColors.light;
}
