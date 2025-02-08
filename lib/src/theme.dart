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

    if (boardPrefs.backgroundTheme == null && boardPrefs.backgroundImage == null) {
      return _makeDefaultTheme(generalPrefs, boardPrefs, isIOS);
    } else if (boardPrefs.backgroundImage != null) {
      return makeBackgroundImageTheme(
        baseTheme: boardPrefs.backgroundImage!.baseTheme,
        isIOS: isIOS,
      );
    } else {
      return makeBackgroundImageTheme(
        baseTheme: boardPrefs.backgroundTheme!.baseTheme,
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
      textTheme: _cupertinoTextTheme(themeLight.colorScheme),
    );

    final darkCupertino = CupertinoThemeData(
      applyThemeToAll: true,
      primaryColor: themeDark.colorScheme.primary,
      primaryContrastingColor: themeDark.colorScheme.onPrimary,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: themeDark.scaffoldBackgroundColor,
      barBackgroundColor: themeDark.colorScheme.surface.withValues(alpha: 0.9),
      textTheme: _cupertinoTextTheme(themeDark.colorScheme),
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
}

({ThemeData light, ThemeData dark}) makeBackgroundImageTheme({
  required ThemeData baseTheme,
  required bool isIOS,
}) {
  final theme = _makeBackgroundTheme(
    theme: baseTheme,
    brightness: Brightness.dark,
    isIOS: isIOS,
    transparentScaffold: true,
  );
  return (light: theme, dark: theme);
}

ThemeData _makeBackgroundTheme({
  required ThemeData theme,
  required bool isIOS,
  Brightness brightness = Brightness.dark,
  bool transparentScaffold = true,
}) {
  final cupertinoTheme = _makeCupertinoBackgroundTheme(
    theme,
    brightness: brightness,
    transparentScaffold: transparentScaffold,
  );

  const baseSurfaceAlpha = 0.7;

  return theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(
      surface: theme.colorScheme.surface.withValues(
        alpha: transparentScaffold ? baseSurfaceAlpha : 1,
      ),
      surfaceContainerLowest: theme.colorScheme.surfaceContainerLowest.withValues(
        alpha: transparentScaffold ? baseSurfaceAlpha : 1,
      ),
      surfaceContainerLow: theme.colorScheme.surfaceContainerLow.withValues(
        alpha: transparentScaffold ? baseSurfaceAlpha : 1,
      ),
      surfaceContainer: theme.colorScheme.surfaceContainer.withValues(
        alpha: transparentScaffold ? baseSurfaceAlpha : 1,
      ),
      surfaceContainerHigh: theme.colorScheme.surfaceContainerHigh.withValues(
        alpha: transparentScaffold ? baseSurfaceAlpha : 1,
      ),
      surfaceContainerHighest: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: transparentScaffold ? baseSurfaceAlpha : 1,
      ),
      surfaceDim: theme.colorScheme.surfaceDim.withValues(
        alpha: transparentScaffold ? baseSurfaceAlpha + 1 : 1,
      ),
      surfaceBright: theme.colorScheme.surfaceBright.withValues(
        alpha: transparentScaffold ? baseSurfaceAlpha - 2 : 1,
      ),
    ),
    cupertinoOverrideTheme: cupertinoTheme,
    listTileTheme: isIOS ? _cupertinoListTileTheme(cupertinoTheme) : null,
    menuTheme: isIOS ? Styles.cupertinoAnchorMenuTheme : null,
    scaffoldBackgroundColor: theme.scaffoldBackgroundColor.withValues(
      alpha: transparentScaffold ? 0 : 1,
    ),
    appBarTheme:
        transparentScaffold
            ? theme.appBarTheme.copyWith(
              backgroundColor: theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.5),
            )
            : null,
    splashFactory: isIOS ? NoSplash.splashFactory : null,
    textTheme:
        isIOS
            ? brightness == Brightness.light
                ? Typography.blackCupertino
                : Typography.whiteCupertino
            : null,
    extensions: [lichessCustomColors.harmonized(theme.colorScheme)],
  );
}

CupertinoTextThemeData _cupertinoTextTheme(ColorScheme colors) =>
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

CupertinoThemeData _makeCupertinoBackgroundTheme(
  ThemeData theme, {
  required Brightness brightness,
  bool transparentScaffold = false,
}) {
  final primary = theme.colorScheme.primary;
  final onPrimary = theme.colorScheme.onPrimary;
  return CupertinoThemeData(
    primaryColor: primary,
    primaryContrastingColor: onPrimary,
    brightness: brightness,
    textTheme: _cupertinoTextTheme(theme.colorScheme),
    scaffoldBackgroundColor: theme.scaffoldBackgroundColor.withValues(
      alpha: transparentScaffold ? 0 : 1,
    ),
    barBackgroundColor: theme.colorScheme.surface.withValues(
      alpha: transparentScaffold ? 0.5 : 0.9,
    ),
    applyThemeToAll: true,
  );
}
