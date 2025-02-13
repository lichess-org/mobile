import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';

const kPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);

const kProgressIndicatorTheme = ProgressIndicatorThemeData(
  // ignore: deprecated_member_use
  year2023: false,
);

const kSliderTheme = SliderThemeData(
  // ignore: deprecated_member_use
  year2023: false,
);

/// Makes the app theme based on the given [generalPrefs] and [boardPrefs] and the current [context].
({ThemeData light, ThemeData dark}) makeAppTheme(
  BuildContext context,
  GeneralPrefs generalPrefs,
  BoardPrefs boardPrefs,
) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  if (generalPrefs.backgroundTheme == null && generalPrefs.backgroundImage == null) {
    return _makeDefaultTheme(context, generalPrefs, boardPrefs, isIOS);
  } else {
    return _makeBackgroundImageTheme(
      context,
      baseTheme: generalPrefs.backgroundImage?.baseTheme ?? generalPrefs.backgroundTheme!.baseTheme,
      seedColor: generalPrefs.backgroundImage?.seedColor ?? generalPrefs.backgroundTheme!.color,
      isIOS: isIOS,
    );
  }
}

({ThemeData light, ThemeData dark}) _makeDefaultTheme(
  BuildContext context,
  GeneralPrefs generalPrefs,
  BoardPrefs boardPrefs,
  bool isIOS,
) {
  final boardTheme = boardPrefs.boardTheme;
  final systemScheme = getDynamicColorSchemes();
  final hasSystemColors = systemScheme != null && generalPrefs.systemColors == true;
  final defaultLight = ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    dynamicSchemeVariant: isIOS ? DynamicSchemeVariant.fidelity : DynamicSchemeVariant.tonalSpot,
  );
  final defaultDark = ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    dynamicSchemeVariant: isIOS ? DynamicSchemeVariant.fidelity : DynamicSchemeVariant.tonalSpot,
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
      cardTheme:
          isIOS
              ? CardTheme(
                color: themeLight.colorScheme.surfaceContainerLowest,
                elevation: 0,
                margin: EdgeInsets.zero,
              )
              : null,
      listTileTheme: isIOS ? _cupertinoListTileTheme(lightCupertino) : null,
      bottomSheetTheme:
          isIOS
              ? BottomSheetThemeData(backgroundColor: themeLight.colorScheme.surfaceContainerLowest)
              : null,
      menuTheme: _makeCupertinoMenuThemeData(themeLight.colorScheme.surfaceContainerLow),
      pageTransitionsTheme: kPageTransitionsTheme,
      progressIndicatorTheme: kProgressIndicatorTheme,
      sliderTheme: kSliderTheme,
      extensions: [lichessCustomColors.harmonized(themeLight.colorScheme)],
    ),
    dark: themeDark.copyWith(
      cupertinoOverrideTheme: darkCupertino,
      splashFactory: isIOS ? NoSplash.splashFactory : null,
      cardTheme:
          isIOS
              ? CardTheme(
                color: themeDark.colorScheme.surfaceContainerHigh,
                elevation: 0,
                margin: EdgeInsets.zero,
              )
              : null,
      listTileTheme: isIOS ? _cupertinoListTileTheme(darkCupertino) : null,
      menuTheme: _makeCupertinoMenuThemeData(themeDark.colorScheme.surface),
      pageTransitionsTheme: kPageTransitionsTheme,
      progressIndicatorTheme: kProgressIndicatorTheme,
      sliderTheme: kSliderTheme,
      extensions: [lichessCustomColors.harmonized(themeDark.colorScheme)],
    ),
  );
}

({ThemeData light, ThemeData dark}) _makeBackgroundImageTheme(
  BuildContext context, {
  required ThemeData baseTheme,
  required Color seedColor,
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
      surfaceContainer: baseTheme.colorScheme.surfaceContainer.withValues(alpha: baseSurfaceAlpha),
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
    cardTheme: isIOS ? const CardTheme(elevation: 0, margin: EdgeInsets.zero) : null,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.8),
    ),
    dialogTheme: DialogTheme(backgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.8)),
    menuTheme: _makeCupertinoMenuThemeData(
      baseTheme.colorScheme.surfaceContainerLow.withValues(alpha: 0.8),
    ),
    scaffoldBackgroundColor: seedColor.withValues(alpha: 0),
    appBarTheme: baseTheme.appBarTheme.copyWith(backgroundColor: seedColor.withValues(alpha: 0.5)),
    splashFactory: isIOS ? NoSplash.splashFactory : null,
    pageTransitionsTheme: kPageTransitionsTheme,
    progressIndicatorTheme: kProgressIndicatorTheme,
    sliderTheme: kSliderTheme,
    extensions: [lichessCustomColors.harmonized(baseTheme.colorScheme)],
  );

  return (light: theme, dark: theme);
}

MenuThemeData _makeCupertinoMenuThemeData(Color backgroundColor) {
  return MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
      elevation: const WidgetStatePropertyAll(0),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius),
      ),
    ),
  );
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
