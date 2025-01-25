import 'dart:ui';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart' show FlexSchemeColor, FlexSchemeData;
import 'package:flutter/material.dart' show ColorScheme;
import 'package:material_color_utilities/material_color_utilities.dart';

CorePalette? _corePalette;

FlexSchemeData? _systemScheme;

(ColorScheme, ColorScheme)? _colorSchemes;

ChessboardColorScheme? _boardColorScheme;

/// Set the system core palette if available (android 12+ only).
///
/// It also defines the system board colors based on the core palette.
void setCorePalette(CorePalette? palette) {
  _corePalette ??= palette;

  if (palette != null) {
    final lightScheme = palette.toColorScheme();
    final darkScheme = palette.toColorScheme(brightness: Brightness.dark);

    _colorSchemes ??= _generateDynamicColourSchemes(lightScheme, darkScheme);

    _systemScheme ??= FlexSchemeData(
      name: 'System',
      description: 'System core palette on Android 12+',
      light: FlexSchemeColor(
        primary: lightScheme.primary,
        primaryContainer: lightScheme.primaryContainer,
        secondary: lightScheme.secondary,
        secondaryContainer: lightScheme.secondaryContainer,
        tertiary: lightScheme.tertiary,
        tertiaryContainer: lightScheme.tertiaryContainer,
        error: lightScheme.error,
        errorContainer: lightScheme.errorContainer,
      ),
      dark: FlexSchemeColor(
        primary: darkScheme.primary,
        primaryContainer: darkScheme.primaryContainer,
        primaryLightRef: lightScheme.primary,
        secondary: darkScheme.secondary,
        secondaryContainer: darkScheme.secondaryContainer,
        secondaryLightRef: lightScheme.secondary,
        tertiary: darkScheme.tertiary,
        tertiaryContainer: darkScheme.tertiaryContainer,
        tertiaryLightRef: lightScheme.tertiary,
        error: darkScheme.error,
        errorContainer: darkScheme.errorContainer,
      ),
    );

    final darkSquare = Color(palette.secondary.get(60));
    final lightSquare = Color(palette.primary.get(95));

    _boardColorScheme ??= ChessboardColorScheme(
      darkSquare: darkSquare,
      lightSquare: lightSquare,
      background: SolidColorChessboardBackground(lightSquare: lightSquare, darkSquare: darkSquare),
      whiteCoordBackground: SolidColorChessboardBackground(
        lightSquare: lightSquare,
        darkSquare: darkSquare,
        coordinates: true,
      ),
      blackCoordBackground: SolidColorChessboardBackground(
        lightSquare: lightSquare,
        darkSquare: darkSquare,
        coordinates: true,
        orientation: Side.black,
      ),
      lastMove: HighlightDetails(
        solidColor: Color(palette.tertiary.get(80)).withValues(alpha: 0.6),
      ),
      selected: HighlightDetails(
        solidColor: Color(palette.neutral.get(40)).withValues(alpha: 0.80),
      ),
      validMoves: Color(palette.neutral.get(40)).withValues(alpha: 0.40),
      validPremoves: Color(palette.error.get(40)).withValues(alpha: 0.30),
    );
  }
}

/// Get the core palette if available (android 12+ only).
CorePalette? getCorePalette() {
  return _corePalette;
}

/// Get the system [FlexSchemeData] if available (android 12+ only).
FlexSchemeData? getSystemScheme() {
  return _systemScheme;
}

/// Get the system color schemes based on the core palette, if available (android 12+).
(ColorScheme light, ColorScheme dark)? getDynamicColorSchemes() {
  return _colorSchemes;
}

/// Get the board colors based on the core palette, if available (android 12+).
ChessboardColorScheme? getBoardColorScheme() {
  return _boardColorScheme;
}

// --

(ColorScheme light, ColorScheme dark) _generateDynamicColourSchemes(
  ColorScheme lightDynamic,
  ColorScheme darkDynamic,
) {
  final lightBase = ColorScheme.fromSeed(seedColor: lightDynamic.primary);
  final darkBase = ColorScheme.fromSeed(
    seedColor: darkDynamic.primary,
    brightness: Brightness.dark,
  );

  final lightAdditionalColours = _extractAdditionalColours(lightBase);
  final darkAdditionalColours = _extractAdditionalColours(darkBase);

  final lightScheme = _insertAdditionalColours(lightBase, lightAdditionalColours);
  final darkScheme = _insertAdditionalColours(darkBase, darkAdditionalColours);

  return (lightScheme.harmonized(), darkScheme.harmonized());
}

List<Color> _extractAdditionalColours(ColorScheme scheme) => [
  scheme.surface,
  scheme.surfaceDim,
  scheme.surfaceBright,
  scheme.surfaceContainerLowest,
  scheme.surfaceContainerLow,
  scheme.surfaceContainer,
  scheme.surfaceContainerHigh,
  scheme.surfaceContainerHighest,
];

ColorScheme _insertAdditionalColours(ColorScheme scheme, List<Color> additionalColours) =>
    scheme.copyWith(
      surface: additionalColours[0],
      surfaceDim: additionalColours[1],
      surfaceBright: additionalColours[2],
      surfaceContainerLowest: additionalColours[3],
      surfaceContainerLow: additionalColours[4],
      surfaceContainer: additionalColours[5],
      surfaceContainerHigh: additionalColours[6],
      surfaceContainerHighest: additionalColours[7],
    );
