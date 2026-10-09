import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:dynamic_system_colors/test_utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart' as mui;

// This test file compares the system colors we derive from the Android core palette with the ones
// the deprecated `CorePalette.toColorScheme` used to produce, to make sure the migration off
// `CorePalette` did not change any color.
// ignore_for_file: deprecated_member_use

/// Core palettes as the Android OS would send them, generated from a few seed colors.
final sampleCorePalettes = [
  0xFF6750A4,
  0xFF00FF00,
  0xFFB33B15,
  0xFF0000FF,
  0xFF767676,
].map(CorePalette.of).toList();

final sampleCorePalette = sampleCorePalettes.first;

Map<String, material.Color> materialSchemeColors(material.ColorScheme s) => {
  'primary': s.primary,
  'onPrimary': s.onPrimary,
  'primaryContainer': s.primaryContainer,
  'onPrimaryContainer': s.onPrimaryContainer,
  'primaryFixed': s.primaryFixed,
  'primaryFixedDim': s.primaryFixedDim,
  'onPrimaryFixed': s.onPrimaryFixed,
  'onPrimaryFixedVariant': s.onPrimaryFixedVariant,
  'secondary': s.secondary,
  'onSecondary': s.onSecondary,
  'secondaryContainer': s.secondaryContainer,
  'onSecondaryContainer': s.onSecondaryContainer,
  'secondaryFixed': s.secondaryFixed,
  'secondaryFixedDim': s.secondaryFixedDim,
  'onSecondaryFixed': s.onSecondaryFixed,
  'onSecondaryFixedVariant': s.onSecondaryFixedVariant,
  'tertiary': s.tertiary,
  'onTertiary': s.onTertiary,
  'tertiaryContainer': s.tertiaryContainer,
  'onTertiaryContainer': s.onTertiaryContainer,
  'tertiaryFixed': s.tertiaryFixed,
  'tertiaryFixedDim': s.tertiaryFixedDim,
  'onTertiaryFixed': s.onTertiaryFixed,
  'onTertiaryFixedVariant': s.onTertiaryFixedVariant,
  'error': s.error,
  'onError': s.onError,
  'errorContainer': s.errorContainer,
  'onErrorContainer': s.onErrorContainer,
  'surface': s.surface,
  'onSurface': s.onSurface,
  'surfaceDim': s.surfaceDim,
  'surfaceBright': s.surfaceBright,
  'onSurfaceVariant': s.onSurfaceVariant,
  'surfaceContainerLowest': s.surfaceContainerLowest,
  'surfaceContainerLow': s.surfaceContainerLow,
  'surfaceContainer': s.surfaceContainer,
  'surfaceContainerHigh': s.surfaceContainerHigh,
  'surfaceContainerHighest': s.surfaceContainerHighest,
  'inverseSurface': s.inverseSurface,
  'onInverseSurface': s.onInverseSurface,
  'inversePrimary': s.inversePrimary,
  'outline': s.outline,
  'outlineVariant': s.outlineVariant,
};

Map<String, material.Color> muiSchemeColors(mui.ColorScheme s) => {
  'primary': s.primary,
  'onPrimary': s.onPrimary,
  'primaryContainer': s.primaryContainer,
  'onPrimaryContainer': s.onPrimaryContainer,
  'primaryFixed': s.primaryFixed,
  'primaryFixedDim': s.primaryFixedDim,
  'onPrimaryFixed': s.onPrimaryFixed,
  'onPrimaryFixedVariant': s.onPrimaryFixedVariant,
  'secondary': s.secondary,
  'onSecondary': s.onSecondary,
  'secondaryContainer': s.secondaryContainer,
  'onSecondaryContainer': s.onSecondaryContainer,
  'secondaryFixed': s.secondaryFixed,
  'secondaryFixedDim': s.secondaryFixedDim,
  'onSecondaryFixed': s.onSecondaryFixed,
  'onSecondaryFixedVariant': s.onSecondaryFixedVariant,
  'tertiary': s.tertiary,
  'onTertiary': s.onTertiary,
  'tertiaryContainer': s.tertiaryContainer,
  'onTertiaryContainer': s.onTertiaryContainer,
  'tertiaryFixed': s.tertiaryFixed,
  'tertiaryFixedDim': s.tertiaryFixedDim,
  'onTertiaryFixed': s.onTertiaryFixed,
  'onTertiaryFixedVariant': s.onTertiaryFixedVariant,
  'error': s.error,
  'onError': s.onError,
  'errorContainer': s.errorContainer,
  'onErrorContainer': s.onErrorContainer,
  'surface': s.surface,
  'onSurface': s.onSurface,
  'surfaceDim': s.surfaceDim,
  'surfaceBright': s.surfaceBright,
  'onSurfaceVariant': s.onSurfaceVariant,
  'surfaceContainerLowest': s.surfaceContainerLowest,
  'surfaceContainerLow': s.surfaceContainerLow,
  'surfaceContainer': s.surfaceContainer,
  'surfaceContainerHigh': s.surfaceContainerHigh,
  'surfaceContainerHighest': s.surfaceContainerHighest,
  'inverseSurface': s.inverseSurface,
  'onInverseSurface': s.onInverseSurface,
  'inversePrimary': s.inversePrimary,
  'outline': s.outline,
  'outlineVariant': s.outlineVariant,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadSystemColors', () {
    test('derives the same color schemes as the deprecated CorePalette API', () async {
      for (final corePalette in sampleCorePalettes) {
        DynamicColorTestingUtils.setMockDynamicColors(corePalette: corePalette);

        await loadSystemColors();

        final schemes = getDynamicColorSchemes();
        expect(schemes, isNotNull);
        expect(muiSchemeColors(schemes!.light), materialSchemeColors(corePalette.toColorScheme()));
        expect(
          muiSchemeColors(schemes.dark),
          materialSchemeColors(corePalette.toColorScheme(brightness: material.Brightness.dark)),
        );
        expect(schemes.light.brightness, material.Brightness.light);
        expect(schemes.dark.brightness, material.Brightness.dark);
      }
    });

    test('derives the board colors from the core palette', () async {
      for (final corePalette in sampleCorePalettes) {
        DynamicColorTestingUtils.setMockDynamicColors(corePalette: corePalette);

        await loadSystemColors();

        final boardColors = getBoardColorScheme();
        expect(boardColors, isNotNull);
        expect(boardColors!.darkSquare, material.Color(corePalette.secondary.get(60)));
        expect(boardColors.lightSquare, material.Color(corePalette.primary.get(95)));
        expect(
          boardColors.lastMove.solidColor,
          material.Color(corePalette.tertiary.get(80)).withValues(alpha: 0.6),
        );
        expect(
          boardColors.selected.solidColor,
          material.Color(corePalette.neutral.get(40)).withValues(alpha: 0.80),
        );
        expect(
          boardColors.validMoves,
          material.Color(corePalette.neutral.get(40)).withValues(alpha: 0.40),
        );
        expect(
          boardColors.validPremoves,
          material.Color(corePalette.error.get(40)).withValues(alpha: 0.30),
        );
      }
    });

    test('prefers the color schemes exposed by the OS over the core palette', () async {
      final osColorSchemes = List.generate(86, (i) => 0xFF000000 + i);
      DynamicColorTestingUtils.setMockDynamicColors(
        corePalette: sampleCorePalette,
        colorSchemes: osColorSchemes,
      );

      await loadSystemColors();

      final schemes = getDynamicColorSchemes();
      expect(schemes, isNotNull);
      final expected = (await DynamicColorPlugin.getColorSchemes())!;
      expect(muiSchemeColors(schemes!.light), materialSchemeColors(expected.light));
      expect(muiSchemeColors(schemes.dark), materialSchemeColors(expected.dark));
      // the board colors still come from the core palette
      expect(
        getBoardColorScheme()?.darkSquare,
        material.Color(sampleCorePalette.secondary.get(60)),
      );
    });

    test('leaves the colors unset when the system does not provide any', () async {
      DynamicColorTestingUtils.setMockDynamicColors();

      await loadSystemColors();

      expect(getSystemCorePalettes(), isNull);
      expect(getDynamicColorSchemes(), isNull);
      expect(getBoardColorScheme(), isNull);
    });
  });
}
