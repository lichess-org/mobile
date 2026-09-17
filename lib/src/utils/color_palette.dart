import 'dart:ui';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dynamic_system_colors/dynamic_system_colors.dart' show DynamicColorPlugin;
import 'package:material_color_utilities/material_color_utilities.dart';
// Not exported by the `material_color_utilities` barrel file.
import 'package:material_color_utilities/palettes/core_palettes.dart';
import 'package:material_ui/material_ui.dart' show ColorScheme;

typedef ColorSchemes = ({ColorScheme light, ColorScheme dark});

/// Number of tonal palettes sent by the Android OS in the core palette.
const _corePalettesSize = 5;

/// Number of colors sent by the Android OS for each color scheme.
const _colorSchemeSize = 43;

/// The Material error palette.
///
/// The core palette exposed by the Android OS does not include an error palette, so the Material
/// color system falls back to this fixed one (it is also the default error palette of
/// [DynamicScheme]).
final _errorPalette = TonalPalette.of(25, 84);

CorePalettes? _corePalettes;

ColorSchemes? _dynamicColorSchemes;

ChessboardColorScheme? _boardColorScheme;

/// Loads the system colors, if available (android 12+ only).
///
/// Android 12 and 13 only expose the core palette (a set of tonal palettes), from which the color
/// schemes are derived. Android 14+ additionally exposes fully resolved light and dark color
/// schemes, which are preferred when available.
///
/// This also defines the system board colors, which are always derived from the core palette.
///
/// This is meant to be called once during app initialization, before the first frame is rendered.
Future<void> loadSystemColors() async {
  final results = await Future.wait([
    DynamicColorPlugin.channel.invokeListMethod<int>(DynamicColorPlugin.corePaletteMethodName),
    DynamicColorPlugin.channel.invokeListMethod<int>(DynamicColorPlugin.colorSchemesMethodName),
  ]);

  final corePaletteColors = results[0];
  final colorSchemeColors = results[1];

  final palettes =
      corePaletteColors != null &&
          corePaletteColors.length == _corePalettesSize * TonalPalette.commonSize
      ? _corePalettesFromList(corePaletteColors)
      : null;

  ColorSchemes? schemes =
      colorSchemeColors != null && colorSchemeColors.length == _colorSchemeSize * 2
      ? _colorSchemesFromList(colorSchemeColors)
      : null;

  if (palettes != null) {
    schemes ??= (
      light: _colorSchemeFromPalettes(palettes, Brightness.light),
      dark: _colorSchemeFromPalettes(palettes, Brightness.dark),
    );
  }

  _corePalettes = palettes;
  _dynamicColorSchemes = schemes;
  _boardColorScheme = palettes != null ? _boardColorSchemeFromPalettes(palettes) : null;
}

/// Get the system core palettes if available (android 12+ only).
CorePalettes? getSystemCorePalettes() {
  return _corePalettes;
}

/// Get the system color schemes, if available (android 12+).
ColorSchemes? getDynamicColorSchemes() {
  return _dynamicColorSchemes;
}

/// Get the board colors based on the system core palettes, if available (android 12+).
ChessboardColorScheme? getBoardColorScheme() {
  return _boardColorScheme;
}

// --

CorePalettes _corePalettesFromList(List<int> colors) {
  TonalPalette partition(int index) => TonalPalette.fromList(
    colors.sublist(index * TonalPalette.commonSize, (index + 1) * TonalPalette.commonSize),
  );

  return CorePalettes(partition(0), partition(1), partition(2), partition(3), partition(4));
}

ChessboardColorScheme _boardColorSchemeFromPalettes(CorePalettes palettes) {
  final darkSquare = Color(palettes.secondary.get(60));
  final lightSquare = Color(palettes.primary.get(95));

  return ChessboardColorScheme(
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
    lastMove: HighlightDetails(solidColor: Color(palettes.tertiary.get(80)).withValues(alpha: 0.6)),
    selected: HighlightDetails(solidColor: Color(palettes.neutral.get(40)).withValues(alpha: 0.80)),
    validMoves: Color(palettes.neutral.get(40)).withValues(alpha: 0.40),
    validPremoves: Color(_errorPalette.get(40)).withValues(alpha: 0.30),
  );
}

/// Builds the light and dark color schemes exposed by the Android OS (14+).
///
/// The list contains the light scheme colors followed by the dark scheme colors, in the order
/// defined by the platform plugin. See:
/// https://github.com/hasali19/flutter_dynamic_system_colors/blob/1.9.0/lib/src/color_schemes.dart
ColorSchemes _colorSchemesFromList(List<int> colors) => (
  light: _colorSchemeFromList(colors, 0, Brightness.light),
  dark: _colorSchemeFromList(colors, 1, Brightness.dark),
);

ColorScheme _colorSchemeFromList(List<int> colors, int index, Brightness brightness) {
  final offset = _colorSchemeSize * index;
  return ColorScheme(
    brightness: brightness,
    primary: Color(colors[offset + 0]),
    onPrimary: Color(colors[offset + 1]),
    primaryContainer: Color(colors[offset + 2]),
    onPrimaryContainer: Color(colors[offset + 3]),
    primaryFixed: Color(colors[offset + 4]),
    primaryFixedDim: Color(colors[offset + 5]),
    onPrimaryFixed: Color(colors[offset + 6]),
    onPrimaryFixedVariant: Color(colors[offset + 7]),
    secondary: Color(colors[offset + 8]),
    onSecondary: Color(colors[offset + 9]),
    secondaryContainer: Color(colors[offset + 10]),
    onSecondaryContainer: Color(colors[offset + 11]),
    secondaryFixed: Color(colors[offset + 12]),
    secondaryFixedDim: Color(colors[offset + 13]),
    onSecondaryFixed: Color(colors[offset + 14]),
    onSecondaryFixedVariant: Color(colors[offset + 15]),
    tertiary: Color(colors[offset + 16]),
    onTertiary: Color(colors[offset + 17]),
    tertiaryContainer: Color(colors[offset + 18]),
    onTertiaryContainer: Color(colors[offset + 19]),
    tertiaryFixed: Color(colors[offset + 20]),
    tertiaryFixedDim: Color(colors[offset + 21]),
    onTertiaryFixed: Color(colors[offset + 22]),
    onTertiaryFixedVariant: Color(colors[offset + 23]),
    error: Color(colors[offset + 24]),
    onError: Color(colors[offset + 25]),
    errorContainer: Color(colors[offset + 26]),
    onErrorContainer: Color(colors[offset + 27]),
    surface: Color(colors[offset + 28]),
    onSurface: Color(colors[offset + 29]),
    surfaceDim: Color(colors[offset + 30]),
    surfaceBright: Color(colors[offset + 31]),
    onSurfaceVariant: Color(colors[offset + 32]),
    surfaceContainerLowest: Color(colors[offset + 33]),
    surfaceContainerLow: Color(colors[offset + 34]),
    surfaceContainer: Color(colors[offset + 35]),
    surfaceContainerHigh: Color(colors[offset + 36]),
    surfaceContainerHighest: Color(colors[offset + 37]),
    inverseSurface: Color(colors[offset + 38]),
    onInverseSurface: Color(colors[offset + 39]),
    inversePrimary: Color(colors[offset + 40]),
    outline: Color(colors[offset + 41]),
    outlineVariant: Color(colors[offset + 42]),
  );
}

/// Derives a [ColorScheme] from the core palettes exposed by the Android OS (12+).
///
/// Used as a fallback on Android 12 and 13, where the OS does not expose fully resolved color
/// schemes. The tone mapping replicates the one of `CorePalette.toColorScheme` from the
/// `dynamic_system_colors` package, which relied on the deprecated `CorePalette` class. See:
/// https://github.com/hasali19/flutter_dynamic_system_colors/blob/1.9.0/lib/src/corepalette_to_colorscheme.dart
///
/// Tones that are not part of [TonalPalette.commonTones] are not sent by the OS: [TonalPalette]
/// generates them from the hue and chroma deduced from the tones it received.
ColorScheme _colorSchemeFromPalettes(CorePalettes palettes, Brightness brightness) =>
    switch (brightness) {
      Brightness.light => ColorScheme(
        brightness: Brightness.light,
        primary: Color(palettes.primary.get(40)),
        onPrimary: Color(palettes.primary.get(100)),
        primaryContainer: Color(palettes.primary.get(90)),
        onPrimaryContainer: Color(palettes.primary.get(10)),
        primaryFixed: Color(palettes.primary.get(90)),
        primaryFixedDim: Color(palettes.primary.get(80)),
        onPrimaryFixed: Color(palettes.primary.get(10)),
        onPrimaryFixedVariant: Color(palettes.primary.get(30)),
        secondary: Color(palettes.secondary.get(40)),
        onSecondary: Color(palettes.secondary.get(100)),
        secondaryContainer: Color(palettes.secondary.get(90)),
        onSecondaryContainer: Color(palettes.secondary.get(10)),
        secondaryFixed: Color(palettes.secondary.get(90)),
        secondaryFixedDim: Color(palettes.secondary.get(80)),
        onSecondaryFixed: Color(palettes.secondary.get(10)),
        onSecondaryFixedVariant: Color(palettes.secondary.get(30)),
        tertiary: Color(palettes.tertiary.get(40)),
        onTertiary: Color(palettes.tertiary.get(100)),
        tertiaryContainer: Color(palettes.tertiary.get(90)),
        onTertiaryContainer: Color(palettes.tertiary.get(10)),
        tertiaryFixed: Color(palettes.tertiary.get(90)),
        tertiaryFixedDim: Color(palettes.tertiary.get(80)),
        onTertiaryFixed: Color(palettes.tertiary.get(10)),
        onTertiaryFixedVariant: Color(palettes.tertiary.get(30)),
        error: Color(_errorPalette.get(40)),
        onError: Color(_errorPalette.get(100)),
        errorContainer: Color(_errorPalette.get(90)),
        onErrorContainer: Color(_errorPalette.get(10)),
        surface: Color(palettes.neutral.get(98)),
        onSurface: Color(palettes.neutral.get(10)),
        surfaceDim: Color(palettes.neutral.get(87)),
        surfaceBright: Color(palettes.neutral.get(98)),
        onSurfaceVariant: Color(palettes.neutralVariant.get(30)),
        surfaceContainerLowest: Color(palettes.neutral.get(100)),
        surfaceContainerLow: Color(palettes.neutral.get(96)),
        surfaceContainer: Color(palettes.neutral.get(94)),
        surfaceContainerHigh: Color(palettes.neutral.get(92)),
        surfaceContainerHighest: Color(palettes.neutral.get(90)),
        inverseSurface: Color(palettes.neutral.get(20)),
        onInverseSurface: Color(palettes.neutral.get(95)),
        inversePrimary: Color(palettes.primary.get(80)),
        outline: Color(palettes.neutralVariant.get(50)),
        outlineVariant: Color(palettes.neutralVariant.get(80)),
      ),
      Brightness.dark => ColorScheme(
        brightness: Brightness.dark,
        primary: Color(palettes.primary.get(80)),
        onPrimary: Color(palettes.primary.get(20)),
        primaryContainer: Color(palettes.primary.get(30)),
        onPrimaryContainer: Color(palettes.primary.get(90)),
        primaryFixed: Color(palettes.primary.get(90)),
        primaryFixedDim: Color(palettes.primary.get(80)),
        onPrimaryFixed: Color(palettes.primary.get(10)),
        onPrimaryFixedVariant: Color(palettes.primary.get(30)),
        secondary: Color(palettes.secondary.get(80)),
        onSecondary: Color(palettes.secondary.get(20)),
        secondaryContainer: Color(palettes.secondary.get(30)),
        onSecondaryContainer: Color(palettes.secondary.get(90)),
        secondaryFixed: Color(palettes.secondary.get(90)),
        secondaryFixedDim: Color(palettes.secondary.get(80)),
        onSecondaryFixed: Color(palettes.secondary.get(10)),
        onSecondaryFixedVariant: Color(palettes.secondary.get(30)),
        tertiary: Color(palettes.tertiary.get(80)),
        onTertiary: Color(palettes.tertiary.get(20)),
        tertiaryContainer: Color(palettes.tertiary.get(30)),
        onTertiaryContainer: Color(palettes.tertiary.get(90)),
        tertiaryFixed: Color(palettes.tertiary.get(90)),
        tertiaryFixedDim: Color(palettes.tertiary.get(80)),
        onTertiaryFixed: Color(palettes.tertiary.get(10)),
        onTertiaryFixedVariant: Color(palettes.tertiary.get(30)),
        error: Color(_errorPalette.get(80)),
        onError: Color(_errorPalette.get(20)),
        errorContainer: Color(_errorPalette.get(30)),
        onErrorContainer: Color(_errorPalette.get(90)),
        surface: Color(palettes.neutral.get(6)),
        onSurface: Color(palettes.neutral.get(90)),
        surfaceDim: Color(palettes.neutral.get(6)),
        surfaceBright: Color(palettes.neutral.get(24)),
        onSurfaceVariant: Color(palettes.neutralVariant.get(80)),
        surfaceContainerLowest: Color(palettes.neutral.get(4)),
        surfaceContainerLow: Color(palettes.neutral.get(10)),
        surfaceContainer: Color(palettes.neutral.get(12)),
        surfaceContainerHigh: Color(palettes.neutral.get(17)),
        surfaceContainerHighest: Color(palettes.neutral.get(22)),
        inverseSurface: Color(palettes.neutral.get(90)),
        onInverseSurface: Color(palettes.neutral.get(20)),
        inversePrimary: Color(palettes.primary.get(40)),
        outline: Color(palettes.neutralVariant.get(60)),
        outlineVariant: Color(palettes.neutralVariant.get(30)),
      ),
    };
