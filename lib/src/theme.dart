import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';

const kSliderTheme = SliderThemeData(
  // ignore: deprecated_member_use
  year2023: false,
);

ThemeData makeAppTheme(
  BuildContext context,
  GeneralPrefs generalPrefs,
  BoardPrefs boardPrefs,
) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  final brightness = generalPrefs.isForcedDarkMode
      ? Brightness.dark
      : switch (generalPrefs.themeMode) {
          BackgroundThemeMode.light => Brightness.light,
          BackgroundThemeMode.dark => Brightness.dark,
          BackgroundThemeMode.system => MediaQuery.platformBrightnessOf(
            context,
          ),
        };

  if (generalPrefs.backgroundColor == null &&
      generalPrefs.backgroundImage == null) {
    return _makeDefaultTheme(brightness, generalPrefs, boardPrefs, isIOS);
  } else {
    return _makeBackgroundImageTheme(
      baseTheme:
          generalPrefs.backgroundImage?.baseTheme ??
          generalPrefs.backgroundColor!.$1.baseTheme,
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
    return CustomTheme(
      rowEven: rowEven ?? this.rowEven,
      rowOdd: rowOdd ?? this.rowOdd,
    );
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

  CustomTheme get lichessTheme =>
      Theme.of(this).extension<CustomTheme>() ?? _defaultLichessTheme;
}

// --

ThemeData _makeDefaultTheme(
  Brightness brightness,
  GeneralPrefs generalPrefs,
  BoardPrefs boardPrefs,
  bool isIOS,
) {
  final boardTheme = boardPrefs.boardTheme;
  final dynamicColorSchemes = getDynamicColorSchemes();
  final systemScheme = switch (brightness) {
    Brightness.light => dynamicColorSchemes?.light,
    Brightness.dark => dynamicColorSchemes?.dark,
  };
  final hasSystemColors =
      systemScheme != null && generalPrefs.systemColors == true;

  final neutralScheme = ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    brightness: brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.neutral,
  );
  final defaultScheme = ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    brightness: brightness,
  );
  // makes a theme with neutral surfaces and default colors
  final boardScheme = defaultScheme.copyWith(
    surface: neutralScheme.surface,
    onSurface: neutralScheme.onSurface,
    surfaceDim: neutralScheme.surfaceDim,
    surfaceBright: neutralScheme.surfaceBright,
    surfaceContainer: neutralScheme.surfaceContainer,
    surfaceContainerLowest: neutralScheme.surfaceContainerLowest,
    surfaceContainerLow: neutralScheme.surfaceContainerLow,
    surfaceContainerHigh: neutralScheme.surfaceContainerHigh,
    surfaceContainerHighest: neutralScheme.surfaceContainerHighest,
    onSurfaceVariant: neutralScheme.onSurfaceVariant,
    inverseSurface: neutralScheme.inverseSurface,
    onInverseSurface: neutralScheme.onInverseSurface,
    shadow: neutralScheme.shadow,
    scrim: neutralScheme.scrim,
    surfaceTint: neutralScheme.surfaceTint,
  );

  final textTheme = isIOS ? kCupertinoDefaultTextTheme : null;

  final theme = hasSystemColors
      ? ThemeData.from(colorScheme: systemScheme, textTheme: textTheme)
      : ThemeData.from(colorScheme: boardScheme, textTheme: textTheme);

  return theme.copyWith(
    cupertinoOverrideTheme: _makeCupertinoThemeData(
      theme.colorScheme,
      brightness,
    ),
    splashFactory: isIOS ? NoSplash.splashFactory : null,
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: isIOS
          ? theme.colorScheme.surface.withValues(alpha: kCupertinoBarOpacity)
          : null,
      scrolledUnderElevation: isIOS ? 0 : null,
      titleTextStyle: isIOS
          ? const CupertinoTextThemeData().navTitleTextStyle.copyWith(
              color: theme.colorScheme.onSurface,
            )
          : null,
    ),
    navigationBarTheme: isIOS
        ? NavigationBarThemeData(
            backgroundColor: theme.colorScheme.surface.withValues(
              alpha: kCupertinoBarOpacity,
            ),
          )
        : null,
    bottomAppBarTheme: BottomAppBarThemeData(
      color: theme.colorScheme.surface,
      elevation: isIOS ? 0 : null,
    ),
    iconTheme: IconThemeData(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    ),
    listTileTheme: _makeListTileTheme(theme.colorScheme, isIOS),
    cardTheme: isIOS
        ? _kCupertinoCardTheme.copyWith(
            color: theme.colorScheme.surfaceContainerHigh,
          )
        : null,
    inputDecorationTheme: isIOS
        ? _makeCupertinoInputDecorationTheme(theme.colorScheme)
        : null,
    floatingActionButtonTheme: isIOS
        ? FloatingActionButtonThemeData(
            backgroundColor: theme.colorScheme.secondaryFixedDim,
            foregroundColor: theme.colorScheme.onSecondaryFixedVariant,
          )
        : null,
    dialogTheme: isIOS ? _kCupertinoDialogTheme : null,
    filledButtonTheme: isIOS ? _kCupertinoFilledButtonTheme : null,
    outlinedButtonTheme: isIOS ? _kCupertinoOutlinedButtonTheme : null,
    menuTheme: isIOS ? _kCupertinoMenuThemeData : null,
    bottomSheetTheme: isIOS ? _kCupertinoBottomSheetTheme : null,
    sliderTheme: kSliderTheme,
    extensions: [lichessCustomColors.harmonized(theme.colorScheme)],
  );
}

ThemeData _makeBackgroundImageTheme({
  required ThemeData baseTheme,
  required Color seedColor,
  required bool isIOS,
  required bool isBackgroundImage,
}) {
  final baseSurfaceAlpha = isBackgroundImage ? 0.5 : 0.3;

  return baseTheme.copyWith(
    colorScheme: baseTheme.colorScheme.copyWith(
      surface: baseTheme.colorScheme.surface.withValues(
        alpha: baseSurfaceAlpha,
      ),
      surfaceContainerLowest: baseTheme.colorScheme.surfaceContainerLowest
          .withValues(alpha: baseSurfaceAlpha),
      surfaceContainerLow: baseTheme.colorScheme.surfaceContainerLow.withValues(
        alpha: baseSurfaceAlpha,
      ),
      surfaceContainer: baseTheme.colorScheme.surfaceContainer.withValues(
        alpha: baseSurfaceAlpha,
      ),
      surfaceContainerHigh: baseTheme.colorScheme.surfaceContainerHigh
          .withValues(alpha: baseSurfaceAlpha),
      surfaceContainerHighest: baseTheme.colorScheme.surfaceContainerHighest
          .withValues(alpha: baseSurfaceAlpha),
      surfaceDim: baseTheme.colorScheme.surfaceDim.withValues(
        alpha: baseSurfaceAlpha + 1,
      ),
      surfaceBright: baseTheme.colorScheme.surfaceBright.withValues(
        alpha: baseSurfaceAlpha - 2,
      ),
    ),
    cupertinoOverrideTheme: _makeCupertinoThemeData(
      baseTheme.colorScheme,
      baseTheme.brightness,
    ),
    listTileTheme: _makeListTileTheme(baseTheme.colorScheme, isIOS),
    cardTheme: isIOS ? _kCupertinoCardTheme : null,
    inputDecorationTheme: isIOS
        ? _makeCupertinoInputDecorationTheme(baseTheme.colorScheme)
        : null,
    bottomSheetTheme:
        (isIOS ? _kCupertinoBottomSheetTheme : const BottomSheetThemeData())
            .copyWith(
              backgroundColor: isIOS
                  ? lighten(
                      baseTheme.colorScheme.surface,
                      0.1,
                    ).withValues(alpha: 0.9)
                  : baseTheme.colorScheme.surface.withValues(alpha: 0.9),
            ),
    drawerTheme: DrawerThemeData(
      backgroundColor: baseTheme.colorScheme.surfaceContainerLow.withValues(
        alpha: 0.9,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: baseTheme.colorScheme.secondaryFixedDim,
      foregroundColor: baseTheme.colorScheme.onSecondaryFixedVariant,
    ),
    dialogTheme: (isIOS ? _kCupertinoDialogTheme : const DialogThemeData())
        .copyWith(
          backgroundColor: baseTheme.colorScheme.surface.withValues(alpha: 0.9),
        ),
    filledButtonTheme: isIOS ? _kCupertinoFilledButtonTheme : null,
    outlinedButtonTheme: isIOS ? _kCupertinoOutlinedButtonTheme : null,
    menuTheme: isIOS
        ? MenuThemeData(
            style: MenuStyle(
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(
                baseTheme.colorScheme.surfaceContainer.withValues(alpha: 0.8),
              ),
            ),
          )
        : MenuThemeData(
            style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                baseTheme.colorScheme.surfaceContainerLow.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
          ),
    scaffoldBackgroundColor: seedColor.withValues(alpha: 0),
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: isBackgroundImage
          ? null
          : seedColor.withValues(alpha: kCupertinoBarOpacity),
      scrolledUnderElevation: isIOS ? 0 : null,
      titleTextStyle: isIOS
          ? const CupertinoTextThemeData().navTitleTextStyle.copyWith(
              color: baseTheme.colorScheme.onSurface,
            )
          : null,
    ),
    navigationBarTheme: isIOS
        ? NavigationBarThemeData(
            backgroundColor: isBackgroundImage
                ? baseTheme.colorScheme.surface.withValues(
                    alpha: baseSurfaceAlpha,
                  )
                : seedColor.withValues(alpha: kCupertinoBarOpacity),
          )
        : null,
    bottomAppBarTheme: BottomAppBarThemeData(
      color: isBackgroundImage
          ? baseTheme.colorScheme.surface.withValues(alpha: baseSurfaceAlpha)
          : seedColor,
      elevation: isIOS ? 0 : null,
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
}

const _kCupertinoFilledButtonTheme = FilledButtonThemeData(
  style: ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
);

const _kCupertinoOutlinedButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
);

const MenuThemeData _kCupertinoMenuThemeData = MenuThemeData(
  style: MenuStyle(elevation: WidgetStatePropertyAll(0)),
);

ListTileThemeData _makeListTileTheme(ColorScheme colorScheme, bool isIOS) {
  return ListTileThemeData(
    iconColor: colorScheme.onSurface.withValues(alpha: 0.7),
    titleTextStyle: isIOS
        ? TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          )
        : null,
    subtitleTextStyle: TextStyle(
      color: colorScheme.onSurface.withValues(alpha: Styles.subtitleOpacity),
    ),
    contentPadding: isIOS ? const EdgeInsets.symmetric(horizontal: 16) : null,
    minTileHeight: isIOS ? 48.0 : null,
  );
}

const _appBarTheme = AppBarTheme(actionsPadding: EdgeInsets.only(right: 8.0));

const _kCupertinoBottomSheetTheme = BottomSheetThemeData(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
  ),
);

const _kCupertinoDialogTheme = DialogThemeData(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
  ),
);

const _kCupertinoCardTheme = CardThemeData(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius),
);

InputDecorationTheme _makeCupertinoInputDecorationTheme(
  ColorScheme colorScheme,
) {
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

CupertinoThemeData _makeCupertinoThemeData(
  ColorScheme colorScheme,
  Brightness brightness,
) {
  return CupertinoThemeData(
    applyThemeToAll: true,
    primaryColor: colorScheme.primary,
    primaryContrastingColor: colorScheme.onPrimary,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: colorScheme.primary,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
        color: colorScheme.onSurface,
      ),
      navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle
          .copyWith(color: colorScheme.onSurface),
      navLargeTitleTextStyle: const CupertinoThemeData()
          .textTheme
          .navLargeTitleTextStyle
          .copyWith(color: colorScheme.onSurface),
    ),
    brightness: brightness,
  );
}

// Letter spacing value taken from:
// https://github.com/flutter/flutter/blob/ea121f8859e4b13e47a8f845e4586164519588bc/packages/flutter/lib/src/cupertino/text_theme.dart#L106
const TextStyle _kCupertinoDefaultTextStyle = TextStyle(letterSpacing: -0.41);

const TextTheme kCupertinoDefaultTextTheme = TextTheme(
  // titleLarge: _kCupertinoDefaultTextStyle,
  titleMedium: _kCupertinoDefaultTextStyle,
  titleSmall: _kCupertinoDefaultTextStyle,
  bodyLarge: _kCupertinoDefaultTextStyle,
  bodyMedium: _kCupertinoDefaultTextStyle,
  bodySmall: _kCupertinoDefaultTextStyle,
  labelLarge: _kCupertinoDefaultTextStyle,
  labelMedium: _kCupertinoDefaultTextStyle,
  labelSmall: _kCupertinoDefaultTextStyle,
);
