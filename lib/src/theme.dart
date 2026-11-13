import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart';

const kSliderTheme = SliderThemeData(
  // ignore: deprecated_member_use
  year2023: false,
);

/// Generates a [ColorScheme] from [seedColor] whose primary color looks like an iOS accent color.
///
/// The scheme is the Material tonal spot one, as on Android, except for the primary color, which is
/// more saturated, like an iOS accent color, and the error color, which is a vibrant red like the
/// iOS system red rather than the pastel one of the Material dark scheme.
ColorScheme makeIOSAccentColorScheme({required Color seedColor, required Brightness brightness}) {
  final isDark = brightness == .dark;
  final sourceHct = Hct.fromInt(seedColor.toARGB32());
  final scheme = ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
  final palette = TonalPalette.of(sourceHct.hue, _kIOSPrimaryChroma);
  final accentTone = isDark ? _kIOSAccentDarkTone : _kIOSAccentLightTone;
  // On the inverse surface, which has the opposite brightness.
  final inverseAccentTone = isDark ? _kIOSAccentLightTone : _kIOSAccentDarkTone;
  Color tone(int t) => Color(palette.get(t));
  return scheme.copyWith(
    primary: tone(accentTone),
    onPrimary: tone(100),
    inversePrimary: tone(inverseAccentTone),
    surfaceTint: tone(accentTone),
    error: Color(materialErrorPalette.get(isDark ? _kIOSErrorDarkTone : _kIOSAccentLightTone)),
    onError: Color(materialErrorPalette.get(100)),
  );
}

/// Chroma of the iOS accent primary palette: tonal spot uses 36, vibrant goes up to the gamut limit.
const _kIOSPrimaryChroma = 48.0;

/// Tone of the iOS accent primary color in light mode: the iOS system colors are around tone 50
/// (e.g. systemBlue is 53), dark enough for white content on top.
const _kIOSAccentLightTone = 50;

/// Tone of the iOS accent primary color in dark mode: the iOS system colors are 3 to 5 tones
/// brighter in dark mode (e.g. systemBlue is 56). A few tones more here, because the dark surfaces
/// are lighter than the iOS ones and the primary color less saturated, which both lower its
/// contrast.
const _kIOSAccentDarkTone = 64;

/// Tone of the iOS error color in dark mode, the one of the iOS dark system red (chroma 90): the
/// Material error palette keeps its full chroma 84 there, while it is clipped to 67 at the accent
/// tone 64, which looks pastel.
const _kIOSErrorDarkTone = 58;

ThemeData makeAppTheme(
  BuildContext context, {
  required BackgroundThemeMode themeMode,
  required (BackgroundColor, bool)? backgroundColor,
  required BackgroundImage? backgroundImage,
  required bool systemColors,
  required BoardTheme boardTheme,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  final isForcedDarkMode = backgroundColor != null || backgroundImage != null;
  final brightness = isForcedDarkMode
      ? Brightness.dark
      : switch (themeMode) {
          BackgroundThemeMode.light => Brightness.light,
          BackgroundThemeMode.dark || BackgroundThemeMode.amoled => Brightness.dark,
          BackgroundThemeMode.system => MediaQuery.platformBrightnessOf(context),
        };

  final theme = backgroundColor == null && backgroundImage == null
      ? _makeDefaultTheme(
          brightness,
          themeMode: themeMode,
          systemColors: systemColors,
          boardTheme: boardTheme,
          isIOS: isIOS,
        )
      : _makeBackgroundImageTheme(
          baseTheme: backgroundImage?.baseTheme ?? backgroundColor!.$1.baseTheme,
          seedColor:
              backgroundImage?.seedColor ??
              (backgroundColor!.$2 ? backgroundColor.$1.darker : backgroundColor.$1.color),
          isIOS: isIOS,
          isBackgroundImage: backgroundImage != null,
        );

  // The elements next to the board don't follow the app color scheme (system colors, background,
  // iOS accent colors): the fidelity variant keeps their colors close to the board ones.
  final boardColorScheme = ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    brightness: brightness,
    dynamicSchemeVariant: .fidelity,
  );
  return theme.copyWith(
    extensions: [...theme.extensions.values, BoardColorScheme(boardColorScheme)],
  );
}

/// A custom theme extension that adds lichess custom properties to the theme.
@immutable
class const CustomTheme({
  required final Color rowEven,
  required final Color rowOdd,

  /// Background of the screens made of a plain list, whose rows are directly on the background
  /// rather than in cards, when it differs from the scaffold background.
  ///
  /// On iOS light mode, the scaffold background is darker so that cards stand out, like the iOS
  /// grouped lists, while plain lists have a lighter background, like the iOS plain lists.
  final Color? plainListBackground,
}) extends ThemeExtension<CustomTheme> {
  @override
  CustomTheme copyWith({Color? rowEven, Color? rowOdd, Color? plainListBackground}) {
    return CustomTheme(
      rowEven: rowEven ?? this.rowEven,
      rowOdd: rowOdd ?? this.rowOdd,
      plainListBackground: plainListBackground ?? this.plainListBackground,
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
      plainListBackground: Color.lerp(plainListBackground, other.plainListBackground, t),
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

ThemeData _makeDefaultTheme(
  Brightness brightness, {
  required BackgroundThemeMode themeMode,
  required bool systemColors,
  required BoardTheme boardTheme,
  required bool isIOS,
}) {
  final dynamicColorSchemes = getDynamicColorSchemes();
  final systemScheme = switch (brightness) {
    .light => dynamicColorSchemes?.light,
    .dark => dynamicColorSchemes?.dark,
  };
  final hasSystemColors = systemScheme != null && systemColors;

  final neutralScheme = ColorScheme.fromSeed(
    seedColor: boardTheme.colors.darkSquare,
    brightness: brightness,
    dynamicSchemeVariant: isIOS ? .monochrome : .neutral,
  );
  final defaultScheme = isIOS
      ? makeIOSAccentColorScheme(seedColor: boardTheme.colors.darkSquare, brightness: brightness)
      : ColorScheme.fromSeed(seedColor: boardTheme.colors.darkSquare, brightness: brightness);
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

  final baseScheme = hasSystemColors ? systemScheme : boardScheme;

  // On iOS light mode, like the iOS grouped lists, cards stand out brighter on a darker background.
  final isIOSLight = isIOS && brightness == .light;
  final theme = ThemeData.from(
    colorScheme: isIOSLight
        ? baseScheme.copyWith(surface: baseScheme.surfaceContainer)
        : baseScheme,
    textTheme: textTheme,
  );
  final cupertinoCardColor = isIOSLight
      ? Color.lerp(baseScheme.surface, baseScheme.surfaceContainerLowest, 0.75)
      : theme.colorScheme.surfaceContainerHigh;

  final isAmoled = themeMode == .amoled;

  final finalTheme = theme.copyWith(
    cupertinoOverrideTheme: _makeCupertinoThemeData(theme.colorScheme, brightness),
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
            backgroundColor: theme.colorScheme.surface.withValues(alpha: kCupertinoBarOpacity),
          )
        : null,
    bottomAppBarTheme: BottomAppBarThemeData(
      color: theme.colorScheme.surface,
      elevation: isIOS ? 0 : null,
    ),
    searchBarTheme: isIOS ? _kCupertinoSearchBarTheme : null,
    iconTheme: IconThemeData(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
    listTileTheme: _makeListTileTheme(theme.colorScheme, theme.textTheme, isIOS),
    cardTheme: isIOS ? _kCupertinoCardTheme.copyWith(color: cupertinoCardColor) : null,
    inputDecorationTheme: isIOS ? _makeCupertinoInputDecorationTheme(theme.colorScheme) : null,
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
    extensions: [
      lichessCustomColors.harmonized(theme.colorScheme),
      // The rows are brighter than the background, like the cards, so that a card of rows still
      // stands out from it.
      if (isIOSLight)
        CustomTheme(
          rowEven: cupertinoCardColor!,
          rowOdd: baseScheme.surfaceContainerLow,
          plainListBackground: baseScheme.surfaceContainerLowest,
        ),
    ],
  );

  if (!isAmoled) return finalTheme;

  return finalTheme.copyWith(
    scaffoldBackgroundColor: const Color(0xFF000000),
    appBarTheme: finalTheme.appBarTheme.copyWith(
      backgroundColor: const Color(0xFF000000),
      surfaceTintColor: Colors.transparent,
    ),
    bottomAppBarTheme: finalTheme.bottomAppBarTheme.copyWith(color: const Color(0xFF000000)),
    colorScheme: finalTheme.colorScheme.copyWith(
      surface: const Color(0xFF000000),
      surfaceContainerLowest: const Color(0xFF000000),
      surfaceContainerLow: const Color(0xFF000000),
      surfaceContainer: const Color(0xFF000000),
      surfaceTint: Colors.transparent,
    ),
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
    cupertinoOverrideTheme: _makeCupertinoThemeData(baseTheme.colorScheme, baseTheme.brightness),
    listTileTheme: _makeListTileTheme(baseTheme.colorScheme, baseTheme.textTheme, isIOS),
    cardTheme: isIOS ? _kCupertinoCardTheme : null,
    inputDecorationTheme: isIOS ? _makeCupertinoInputDecorationTheme(baseTheme.colorScheme) : null,
    bottomSheetTheme: (isIOS ? _kCupertinoBottomSheetTheme : const BottomSheetThemeData()).copyWith(
      backgroundColor: isIOS
          ? lighten(baseTheme.colorScheme.surface, 0.1).withValues(alpha: 0.9)
          : baseTheme.colorScheme.surface.withValues(alpha: 0.9),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: baseTheme.colorScheme.surfaceContainerLow.withValues(alpha: 0.9),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: baseTheme.colorScheme.secondaryFixedDim,
      foregroundColor: baseTheme.colorScheme.onSecondaryFixedVariant,
    ),
    dialogTheme: (isIOS ? _kCupertinoDialogTheme : const DialogThemeData()).copyWith(
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
                baseTheme.colorScheme.surfaceContainerLow.withValues(alpha: 0.8),
              ),
            ),
          ),
    scaffoldBackgroundColor: seedColor.withValues(alpha: 0),
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: isBackgroundImage ? null : seedColor.withValues(alpha: kCupertinoBarOpacity),
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
                ? baseTheme.colorScheme.surface.withValues(alpha: baseSurfaceAlpha)
                : seedColor.withValues(alpha: kCupertinoBarOpacity),
          )
        : null,
    bottomAppBarTheme: BottomAppBarThemeData(
      color: isBackgroundImage
          ? baseTheme.colorScheme.surface.withValues(alpha: baseSurfaceAlpha)
          : seedColor,
      elevation: isIOS ? 0 : null,
    ),
    searchBarTheme: isIOS ? _kCupertinoSearchBarTheme : null,
    splashFactory: isIOS ? NoSplash.splashFactory : null,
    sliderTheme: kSliderTheme,
    extensions: [lichessCustomColors.harmonized(baseTheme.colorScheme)],
  );
}

/// Capsule buttons with a semibold 15pt label, like the UIKit buttons of the default (medium) size.
const _kCupertinoFilledButtonTheme = FilledButtonThemeData(
  style: ButtonStyle(
    shape: WidgetStatePropertyAll(StadiumBorder()),
    textStyle: WidgetStatePropertyAll(
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.23),
    ),
    minimumSize: WidgetStatePropertyAll(Size(64, 44)),
    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
  ),
);

const _kCupertinoOutlinedButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(shape: WidgetStatePropertyAll(StadiumBorder())),
);

const MenuThemeData _kCupertinoMenuThemeData = MenuThemeData(
  style: MenuStyle(elevation: WidgetStatePropertyAll(0)),
);

ListTileThemeData _makeListTileTheme(ColorScheme colorScheme, TextTheme textTheme, bool isIOS) {
  return ListTileThemeData(
    iconColor: colorScheme.onSurface.withValues(alpha: 0.7),
    // A complete style (`inherit: false`), like the Material default it replaces: [ListTile]
    // animates its title style, and text styles with different `inherit` values cannot be
    // interpolated when the platform changes at runtime (in the device preview).
    titleTextStyle: isIOS
        ? textTheme.bodyMedium!
              .merge(
                TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500, fontSize: 16),
              )
              .copyWith(inherit: false)
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
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
);

const _kCupertinoDialogTheme = DialogThemeData(
  elevation: 0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
);

const _kCupertinoCardTheme = CardThemeData(
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius),
);

const _kCupertinoSearchBarTheme = SearchBarThemeData(
  elevation: WidgetStatePropertyAll(0),
  shape: WidgetStatePropertyAll(StadiumBorder()),
  constraints: BoxConstraints(minHeight: 40, maxHeight: 40),
  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 7)),
);

/// The corner radius of text fields on iOS.
///
/// A radius is clamped to half the height of the field: a single line field is a capsule, like the
/// iOS 26 search and message fields, and a multiline one a rounded rectangle.
const _kCupertinoInputBorderRadius = BorderRadius.all(Radius.circular(28));

InputDecorationTheme _makeCupertinoInputDecorationTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    filled: true,
    // In light mode, a translucent darkening like the iOS system fills, which shows on both the
    // background and the brighter cards.
    fillColor: colorScheme.brightness == Brightness.light
        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.12)
        : colorScheme.surfaceContainer.withValues(alpha: 0.7),
    border: const OutlineInputBorder(borderRadius: _kCupertinoInputBorderRadius),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.outline),
      borderRadius: _kCupertinoInputBorderRadius,
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
      borderRadius: _kCupertinoInputBorderRadius,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
      borderRadius: _kCupertinoInputBorderRadius,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
      borderRadius: _kCupertinoInputBorderRadius,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error),
      borderRadius: _kCupertinoInputBorderRadius,
    ),
  );
}

CupertinoThemeData _makeCupertinoThemeData(ColorScheme colorScheme, Brightness brightness) {
  return CupertinoThemeData(
    applyThemeToAll: true,
    primaryColor: colorScheme.primary,
    primaryContrastingColor: colorScheme.onPrimary,
    textTheme: const CupertinoThemeData().textTheme.copyWith(
      primaryColor: colorScheme.primary,
      textStyle: const CupertinoThemeData().textTheme.textStyle.copyWith(
        color: colorScheme.onSurface,
      ),
      navTitleTextStyle: const CupertinoThemeData().textTheme.navTitleTextStyle.copyWith(
        color: colorScheme.onSurface,
      ),
      // Smaller than the iOS large title (34pt), so that longer (translated) titles fit on one line.
      navLargeTitleTextStyle: const CupertinoThemeData().textTheme.navLargeTitleTextStyle.copyWith(
        color: colorScheme.onSurface,
        fontSize: 29.0,
      ),
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
