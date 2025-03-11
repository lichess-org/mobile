import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';

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

  if (generalPrefs.backgroundColor == null && generalPrefs.backgroundImage == null) {
    return _makeDefaultTheme(context, generalPrefs, boardPrefs, isIOS);
  } else {
    return _makeBackgroundImageTheme(
      context,
      baseTheme:
          generalPrefs.backgroundImage?.baseTheme ?? generalPrefs.backgroundColor!.$1.baseTheme,
      seedColor:
          generalPrefs.backgroundImage?.seedColor ??
          (generalPrefs.backgroundColor!.$2
              ? generalPrefs.backgroundColor!.$1.darker
              : generalPrefs.backgroundColor!.$1.color),
      isIOS: isIOS,
      isBackgroundImage: generalPrefs.backgroundImage != null,
    );
  }
}

/// A custom theme extension that adds lichess custom properties to the theme.
@immutable
class CustomTheme extends ThemeExtension<CustomTheme> {
  const CustomTheme({required this.rowEven, required this.rowOdd});

  final Color rowEven;
  final Color rowOdd;

  @override
  CustomTheme copyWith({Color? rowEven, Color? rowOdd}) {
    return CustomTheme(rowEven: rowEven ?? this.rowEven, rowOdd: rowOdd ?? this.rowOdd);
  }

  @override
  CustomTheme lerp(ThemeExtension<CustomTheme>? other, double t) {
    if (other is! CustomTheme) {
      return this;
    }
    return CustomTheme(
      rowEven: Color.lerp(rowEven, other.rowEven, t) ?? rowEven,
      rowOdd: Color.lerp(rowOdd, other.rowOdd, t) ?? rowOdd,
    );
  }
}

/// A [BuildContext] extension that provides the [lichessTheme] property.
extension CustomThemeBuildContext on BuildContext {
  CustomTheme get _defaultLichessTheme => CustomTheme(
    rowEven: ColorScheme.of(this).surfaceContainer,
    rowOdd: ColorScheme.of(this).surfaceContainerHigh,
  );

  CustomTheme get lichessTheme => Theme.of(this).extension<CustomTheme>() ?? _defaultLichessTheme;
}

// --

({ThemeData light, ThemeData dark}) _makeDefaultTheme(
  BuildContext context,
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
    scaffoldBackgroundColor: const Color.fromARGB(255, 237, 235, 233),
    barBackgroundColor: const Color(0xE6F9F9F9),
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

  final cupertinoFloatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: themeLight.colorScheme.secondaryFixedDim,
    foregroundColor: themeLight.colorScheme.onSecondaryFixedVariant,
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
              ? BottomSheetThemeData(backgroundColor: lightCupertino.scaffoldBackgroundColor)
              : null,
      floatingActionButtonTheme: isIOS ? cupertinoFloatingActionButtonTheme : null,
      menuTheme:
          isIOS ? _makeCupertinoMenuThemeData(themeLight.colorScheme.surfaceContainerLowest) : null,
      sliderTheme: kSliderTheme,
      extensions: [
        lichessCustomColors.harmonized(themeLight.colorScheme),
        if (isIOS)
          const CustomTheme(rowEven: Colors.white, rowOdd: Color.fromARGB(255, 247, 246, 245)),
      ],
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
      bottomSheetTheme:
          isIOS
              ? BottomSheetThemeData(backgroundColor: darkCupertino.scaffoldBackgroundColor)
              : null,
      floatingActionButtonTheme: isIOS ? cupertinoFloatingActionButtonTheme : null,
      menuTheme: isIOS ? _makeCupertinoMenuThemeData(themeDark.colorScheme.surface) : null,
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
  required bool isBackgroundImage,
}) {
  final primary = baseTheme.colorScheme.primary;
  final onPrimary = baseTheme.colorScheme.onPrimary;
  final cupertinoTheme = CupertinoThemeData(
    primaryColor: primary,
    primaryContrastingColor: onPrimary,
    brightness: Brightness.dark,
    textTheme: cupertinoTextTheme(baseTheme.colorScheme),
    scaffoldBackgroundColor: baseTheme.scaffoldBackgroundColor.withValues(alpha: 0),
    barBackgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.6),
    applyThemeToAll: true,
  );

  final baseSurfaceAlpha = isBackgroundImage ? 0.5 : 0.3;

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
      backgroundColor:
          isIOS
              ? lighten(baseTheme.colorScheme.surface, 0.1).withValues(alpha: 0.9)
              : baseTheme.colorScheme.surface.withValues(alpha: 0.9),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: baseTheme.colorScheme.secondaryFixedDim,
      foregroundColor: baseTheme.colorScheme.onSecondaryFixedVariant,
    ),
    dialogTheme: DialogTheme(backgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.9)),
    menuTheme:
        isIOS
            ? _makeCupertinoMenuThemeData(
              baseTheme.colorScheme.surfaceContainerLow.withValues(alpha: 0.8),
            )
            : MenuThemeData(
              style: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(
                  baseTheme.colorScheme.surfaceContainerLow.withValues(alpha: 0.8),
                ),
              ),
            ),
    scaffoldBackgroundColor: seedColor.withValues(alpha: 0),
    appBarTheme: baseTheme.appBarTheme.copyWith(backgroundColor: seedColor.withValues(alpha: 0.5)),
    splashFactory: isIOS ? NoSplash.splashFactory : null,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(
          backgroundColor: seedColor.withValues(alpha: 0),
        ),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
      },
    ),

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
