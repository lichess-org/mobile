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
    rowOdd: ColorScheme.of(this).surfaceContainerLow,
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
  final defaultLight = ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    dynamicSchemeVariant: DynamicSchemeVariant.neutral,
  );
  final defaultDark = ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    brightness: Brightness.dark,
    dynamicSchemeVariant: DynamicSchemeVariant.neutral,
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
  );

  final darkCupertino = CupertinoThemeData(
    applyThemeToAll: true,
    primaryColor: themeDark.colorScheme.primary,
    primaryContrastingColor: themeDark.colorScheme.onPrimary,
    brightness: Brightness.dark,
  );

  final cupertinoFloatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: themeLight.colorScheme.secondaryFixedDim,
    foregroundColor: themeLight.colorScheme.onSecondaryFixedVariant,
  );

  return (
    light: themeLight.copyWith(
      cupertinoOverrideTheme: lightCupertino,
      typography: Typography.material2021(
        platform: isIOS ? TargetPlatform.iOS : TargetPlatform.android,
        colorScheme: themeLight.colorScheme,
      ),
      splashFactory: isIOS ? NoSplash.splashFactory : null,
      appBarTheme: isIOS ? _makeCupertinoAppBarTheme(context) : null,
      iconTheme: IconThemeData(color: themeLight.colorScheme.onSurface.withValues(alpha: 0.7)),
      listTileTheme: _makeListTileTheme(themeLight.colorScheme, isIOS),
      cardTheme:
          isIOS
              ? _kCupertinoCardTheme.copyWith(color: themeLight.colorScheme.surfaceContainerHigh)
              : null,
      inputDecorationTheme:
          isIOS ? _makeCupertinoInputDecorationTheme(themeLight.colorScheme) : null,
      floatingActionButtonTheme: isIOS ? cupertinoFloatingActionButtonTheme : null,
      menuTheme: isIOS ? _makeCupertinoMenuThemeData() : null,
      sliderTheme: kSliderTheme,
      extensions: [lichessCustomColors.harmonized(themeLight.colorScheme)],
    ),
    dark: themeDark.copyWith(
      cupertinoOverrideTheme: darkCupertino,
      typography: Typography.material2021(
        platform: isIOS ? TargetPlatform.iOS : TargetPlatform.android,
        colorScheme: themeDark.colorScheme,
      ),
      splashFactory: isIOS ? NoSplash.splashFactory : null,
      appBarTheme: isIOS ? _makeCupertinoAppBarTheme(context) : null,
      iconTheme: IconThemeData(color: themeDark.colorScheme.onSurface.withValues(alpha: 0.7)),
      listTileTheme: _makeListTileTheme(themeDark.colorScheme, isIOS),
      cardTheme:
          isIOS
              ? _kCupertinoCardTheme.copyWith(color: themeDark.colorScheme.surfaceContainerHigh)
              : null,
      inputDecorationTheme:
          isIOS ? _makeCupertinoInputDecorationTheme(themeDark.colorScheme) : null,
      floatingActionButtonTheme: isIOS ? cupertinoFloatingActionButtonTheme : null,
      menuTheme: isIOS ? _makeCupertinoMenuThemeData() : null,
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
    listTileTheme: _makeListTileTheme(baseTheme.colorScheme, isIOS),
    cardTheme: isIOS ? _kCupertinoCardTheme : null,
    inputDecorationTheme: isIOS ? _makeCupertinoInputDecorationTheme(baseTheme.colorScheme) : null,
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
    dialogTheme: DialogThemeData(
      backgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.9),
    ),
    menuTheme:
        isIOS
            ? _makeCupertinoMenuThemeData()
            : MenuThemeData(
              style: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(
                  baseTheme.colorScheme.surfaceContainerLow.withValues(alpha: 0.8),
                ),
              ),
            ),
    scaffoldBackgroundColor: seedColor.withValues(alpha: 0),
    appBarTheme: (isIOS ? _makeCupertinoAppBarTheme(context) : const AppBarTheme()).copyWith(
      backgroundColor: baseTheme.colorScheme.surfaceContainer.withValues(alpha: 0.0),
    ),
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

MenuThemeData _makeCupertinoMenuThemeData() {
  return const MenuThemeData(
    style: MenuStyle(
      elevation: WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius)),
    ),
  );
}

ListTileThemeData _makeListTileTheme(ColorScheme colorScheme, bool isIOS) {
  return ListTileThemeData(
    iconColor: colorScheme.onSurface.withValues(alpha: 0.7),
    subtitleTextStyle: TextStyle(
      color: colorScheme.onSurface.withValues(alpha: Styles.subtitleOpacity),
    ),
    contentPadding: isIOS ? const EdgeInsets.symmetric(horizontal: 16) : null,
  );
}

AppBarTheme _makeCupertinoAppBarTheme(BuildContext context) => AppBarTheme(
  toolbarHeight: kMinInteractiveDimensionCupertino,
  titleTextStyle: AppBarTheme.of(
    context,
  ).titleTextStyle?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
);

const _kCupertinoCardTheme = CardThemeData(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius),
);

InputDecorationTheme _makeCupertinoInputDecorationTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceContainer.withValues(alpha: 0.7),
    border: const OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.outline),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
  );
}
