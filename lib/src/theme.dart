import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@riverpod
class ApplicationTheme extends _$ApplicationTheme {
  @override
  ({ThemeData light, ThemeData dark}) build() {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    if (generalPrefs.backgroundTheme == null && generalPrefs.backgroundImage == null) {
      return _makeDefaultTheme(generalPrefs, boardPrefs, isIOS);
    } else if (generalPrefs.backgroundImage != null) {
      return _makeBackgroundImageTheme(
        baseTheme: generalPrefs.backgroundImage!.baseTheme,
        isIOS: isIOS,
      );
    } else {
      return _makeBackgroundImageTheme(
        baseTheme: generalPrefs.backgroundTheme!.baseTheme,
        isIOS: isIOS,
      );
    }
  }

  ({ThemeData light, ThemeData dark}) _makeDefaultTheme(
    GeneralPrefs generalPrefs,
    BoardPrefs boardPrefs,
    bool isIOS,
  ) {
    final boardTheme = boardPrefs.boardTheme;
    final systemScheme = getDynamicColorSchemes();
    final hasSystemColors = systemScheme != null && generalPrefs.systemColors == true;
    final defaultLight = ColorScheme.fromSeed(seedColor: boardTheme.colors.darkSquare);
    final defaultDark = ColorScheme.fromSeed(
      seedColor: boardTheme.colors.darkSquare,
      brightness: Brightness.dark,
    );

    final themeLight =
        hasSystemColors
            ? ThemeData.from(colorScheme: systemScheme.light)
            : ThemeData.from(colorScheme: defaultLight);
    final themeDark =
        hasSystemColors
            ? ThemeData.from(colorScheme: systemScheme.dark)
            : ThemeData.from(colorScheme: defaultDark);

    final lightCupertino = CupertinoThemeData(
      applyThemeToAll: true,
      primaryColor: themeLight.colorScheme.primary,
      primaryContrastingColor: themeLight.colorScheme.onPrimary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: darken(themeLight.scaffoldBackgroundColor, 0.05),
      barBackgroundColor: themeLight.colorScheme.surface.withValues(alpha: 0.9),
      textTheme: cupertinoTextTheme(themeLight.colorScheme),
    );

    final darkCupertino = CupertinoThemeData(
      applyThemeToAll: true,
      primaryColor: themeDark.colorScheme.primary,
      primaryContrastingColor: themeDark.colorScheme.onPrimary,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: lighten(themeDark.scaffoldBackgroundColor, 0.04),
      barBackgroundColor: themeDark.colorScheme.surface.withValues(alpha: 0.9),
      textTheme: cupertinoTextTheme(themeDark.colorScheme),
    );

    return (
      light: themeLight.copyWith(
        cupertinoOverrideTheme: lightCupertino,
        splashFactory: isIOS ? NoSplash.splashFactory : null,
        textTheme: isIOS ? Typography.blackCupertino : null,
        listTileTheme: isIOS ? _cupertinoListTileTheme(lightCupertino) : null,
        menuTheme: isIOS ? Styles.cupertinoAnchorMenuTheme : null,
        extensions: [lichessCustomColors.harmonized(themeLight.colorScheme)],
      ),
      dark: themeDark.copyWith(
        cupertinoOverrideTheme: darkCupertino,
        splashFactory: isIOS ? NoSplash.splashFactory : null,
        textTheme: isIOS ? Typography.whiteCupertino : null,
        listTileTheme: isIOS ? _cupertinoListTileTheme(darkCupertino) : null,
        menuTheme: isIOS ? Styles.cupertinoAnchorMenuTheme : null,
        extensions: [lichessCustomColors.harmonized(themeDark.colorScheme)],
      ),
    );
  }

  ({ThemeData light, ThemeData dark}) _makeBackgroundImageTheme({
    required ThemeData baseTheme,
    required bool isIOS,
  }) {
    final primary = baseTheme.colorScheme.primary;
    final onPrimary = baseTheme.colorScheme.onPrimary;
    final cupertinoTheme = CupertinoThemeData(
      primaryColor: primary,
      primaryContrastingColor: onPrimary,
      brightness: Brightness.dark,
      textTheme: cupertinoTextTheme(baseTheme.colorScheme),
      scaffoldBackgroundColor: baseTheme.scaffoldBackgroundColor.withValues(alpha: 0),
      barBackgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.5),
      applyThemeToAll: true,
    );

    const baseSurfaceAlpha = 0.7;

    final theme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        surface: baseTheme.colorScheme.surface.withValues(alpha: baseSurfaceAlpha),
        surfaceContainerLowest: baseTheme.colorScheme.surfaceContainerLowest.withValues(
          alpha: baseSurfaceAlpha,
        ),
        surfaceContainerLow: baseTheme.colorScheme.surfaceContainerLow.withValues(
          alpha: baseSurfaceAlpha,
        ),
        surfaceContainer: baseTheme.colorScheme.surfaceContainer.withValues(
          alpha: baseSurfaceAlpha,
        ),
        surfaceContainerHigh: baseTheme.colorScheme.surfaceContainerHigh.withValues(
          alpha: baseSurfaceAlpha,
        ),
        surfaceContainerHighest: baseTheme.colorScheme.surfaceContainerHighest.withValues(
          alpha: baseSurfaceAlpha,
        ),
        surfaceDim: baseTheme.colorScheme.surfaceDim.withValues(alpha: baseSurfaceAlpha + 1),
        surfaceBright: baseTheme.colorScheme.surfaceBright.withValues(alpha: baseSurfaceAlpha - 2),
      ),
      cupertinoOverrideTheme: cupertinoTheme,
      listTileTheme: isIOS ? _cupertinoListTileTheme(cupertinoTheme) : null,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.8),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.8),
      ),
      menuTheme: isIOS ? Styles.cupertinoAnchorMenuTheme : null,
      scaffoldBackgroundColor: baseTheme.scaffoldBackgroundColor.withValues(alpha: 0),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: baseTheme.scaffoldBackgroundColor.withValues(alpha: 0),
      ),
      splashFactory: isIOS ? NoSplash.splashFactory : null,
      textTheme: isIOS ? Typography.whiteCupertino : null,
      extensions: [lichessCustomColors.harmonized(baseTheme.colorScheme)],
    );

    return (light: theme, dark: theme);
  }
}

/// Makes a Cupertino text theme based on the given [colors].
CupertinoTextThemeData cupertinoTextTheme(ColorScheme colors) =>
    const CupertinoThemeData().textTheme.copyWith(
      primaryColor: colors.primary,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(color: colors.onSurface),
      navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle.copyWith(
        color: colors.onSurface,
      ),
      navLargeTitleTextStyle: const CupertinoThemeData().textTheme.navLargeTitleTextStyle.copyWith(
        color: colors.onSurface,
      ),
    );

ListTileThemeData _cupertinoListTileTheme(CupertinoThemeData cupertinoTheme) => ListTileThemeData(
  titleTextStyle: cupertinoTheme.textTheme.textStyle,
  subtitleTextStyle: cupertinoTheme.textTheme.textStyle,
  leadingAndTrailingTextStyle: cupertinoTheme.textTheme.textStyle,
);
