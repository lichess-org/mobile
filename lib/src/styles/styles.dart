import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Styles {
  // text
  static const bold = TextStyle(fontWeight: FontWeight.bold);
  static const title = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  static const subtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static final callout = TextStyle(
    fontSize: defaultTargetPlatform == TargetPlatform.iOS ? 20 : 18,
    letterSpacing: defaultTargetPlatform == TargetPlatform.iOS ? -0.41 : null,
    fontWeight: FontWeight.w600,
  );
  static final mainListTileTitle = TextStyle(
    fontSize: defaultTargetPlatform == TargetPlatform.iOS ? 19 : 18,
    letterSpacing: defaultTargetPlatform == TargetPlatform.iOS ? -0.41 : null,
    fontWeight: FontWeight.w500,
  );
  static const mainListTileIconSize = 28.0;
  static final sectionTitle = TextStyle(
    fontSize: defaultTargetPlatform == TargetPlatform.iOS ? 20 : 18,
    letterSpacing: defaultTargetPlatform == TargetPlatform.iOS ? -0.41 : null,
    fontWeight: FontWeight.bold,
  );
  static const boardPreviewTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const subtitleOpacity = 0.7;
  static const timeControl = TextStyle(letterSpacing: 1.2);
  static const formLabel = TextStyle(fontWeight: FontWeight.bold);
  static const formError = TextStyle(color: LichessColors.red);
  static const formDescription = TextStyle(fontSize: 12);
  static const linkStyle = TextStyle(color: Colors.blueAccent, decoration: TextDecoration.none);

  // padding
  static const cupertinoAppBarTrailingWidgetPadding = EdgeInsetsDirectional.only(end: 8.0);
  static const bodyPadding = EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0);
  static const verticalBodyPadding = EdgeInsets.symmetric(vertical: 16.0);
  static const horizontalBodyPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const sectionBottomPadding = EdgeInsets.only(bottom: 16.0);
  static const sectionTopPadding = EdgeInsets.only(top: 16.0);
  static const bodySectionPadding = EdgeInsets.all(16.0);

  /// Horizontal and bottom padding for the body section.
  static const bodySectionBottomPadding = EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0);

  // cards
  static const cardBorderRadius = BorderRadius.all(Radius.circular(12.0));

  // boards
  static const boardBorderRadius = BorderRadius.all(Radius.circular(5.0));

  // colors
  static Color? expansionTileColor(BuildContext context) =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoColors.secondaryLabel.resolveFrom(context)
          : null;

  /// Retrieve the background color for the screens where we display a list of items.
  static Color listingsScreenBackgroundColor(BuildContext context) =>
      ColorScheme.of(context).surfaceContainerLowest;

  static Color backgroundActivated(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light
        ? ColorScheme.of(context).surfaceContainerLow
        : ColorScheme.of(context).surfaceContainerHighest;
  }

  static Color chartColor(BuildContext context) {
    return ColorScheme.of(context).tertiary;
  }

  static const _cupertinoDarkLabelColor = Color(0xFFDCDCDC);
  static const cupertinoTitleColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF000000),
    darkColor: Color(0xFFF5F5F5),
  );
  static const cupertinoSeparatorColor = CupertinoDynamicColor.withBrightness(
    debugLabel: 'separator',
    color: Color.fromARGB(73, 60, 60, 67),
    darkColor: Color.fromARGB(153, 101, 101, 105),
  );

  static const cupertinoAnchorMenuTheme = MenuThemeData(
    style: MenuStyle(
      elevation: WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius)),
    ),
  );

  /// A Material Design text theme with light glyphs based on San Francisco.
  ///
  /// This [TextTheme] provides color but not geometry (font size, weight, etc).
  ///
  /// This theme uses the iOS version of the font names.
  static const TextTheme whiteCupertinoTextTheme = TextTheme(
    displayLarge: TextStyle(
      debugLabel: 'whiteCupertino displayLarge',
      fontFamily: 'CupertinoSystemDisplay',
      color: Color(0xFFF5F5F5),
      decoration: TextDecoration.none,
    ),
    displayMedium: TextStyle(
      debugLabel: 'whiteCupertino displayMedium',
      fontFamily: 'CupertinoSystemDisplay',
      color: Color(0xFFF5F5F5),
      decoration: TextDecoration.none,
    ),
    displaySmall: TextStyle(
      debugLabel: 'whiteCupertino displaySmall',
      fontFamily: 'CupertinoSystemDisplay',
      color: Color(0xFFF5F5F5),
      decoration: TextDecoration.none,
    ),
    headlineLarge: TextStyle(
      debugLabel: 'whiteCupertino headlineLarge',
      fontFamily: 'CupertinoSystemDisplay',
      color: Color(0xFFF5F5F5),
      decoration: TextDecoration.none,
    ),
    headlineMedium: TextStyle(
      debugLabel: 'whiteCupertino headlineMedium',
      fontFamily: 'CupertinoSystemDisplay',
      color: Color(0xFFF5F5F5),
      decoration: TextDecoration.none,
    ),
    headlineSmall: TextStyle(
      debugLabel: 'whiteCupertino headlineSmall',
      fontFamily: 'CupertinoSystemDisplay',
      color: Color(0xFFF5F5F5),
      decoration: TextDecoration.none,
    ),
    titleLarge: TextStyle(
      debugLabel: 'whiteCupertino titleLarge',
      fontFamily: 'CupertinoSystemDisplay',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
    titleMedium: TextStyle(
      debugLabel: 'whiteCupertino titleMedium',
      fontFamily: 'CupertinoSystemText',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
    titleSmall: TextStyle(
      debugLabel: 'whiteCupertino titleSmall',
      fontFamily: 'CupertinoSystemText',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
    bodyLarge: TextStyle(
      debugLabel: 'whiteCupertino bodyLarge',
      fontFamily: 'CupertinoSystemText',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
    bodyMedium: TextStyle(
      debugLabel: 'whiteCupertino bodyMedium',
      fontFamily: 'CupertinoSystemText',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
    bodySmall: TextStyle(
      debugLabel: 'whiteCupertino bodySmall',
      fontFamily: 'CupertinoSystemText',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
    labelLarge: TextStyle(
      debugLabel: 'whiteCupertino labelLarge',
      fontFamily: 'CupertinoSystemText',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
    labelMedium: TextStyle(
      debugLabel: 'whiteCupertino labelMedium',
      fontFamily: 'CupertinoSystemText',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
    labelSmall: TextStyle(
      debugLabel: 'whiteCupertino labelSmall',
      fontFamily: 'CupertinoSystemText',
      color: _cupertinoDarkLabelColor,
      decoration: TextDecoration.none,
    ),
  );
}

/// Retrieve the default text color and apply an opacity to it.
Color? textShade(BuildContext context, double opacity) =>
    DefaultTextStyle.of(context).style.color?.withValues(alpha: opacity);

Color? dividerColor(BuildContext context) =>
    defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.separator.resolveFrom(context)
        : null;

Color darken(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, Colors.black, amount) ?? c;
}

Color lighten(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, Colors.white, amount) ?? c;
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.cyan,
    required this.brag,
    required this.good,
    required this.error,
    required this.fancy,
    required this.purple,
    required this.primary,
  });

  final Color cyan;
  final Color brag;
  final Color good;
  final Color error;
  final Color fancy;
  final Color purple;
  final Color primary;

  @override
  CustomColors copyWith({
    Color? cyan,
    Color? brag,
    Color? good,
    Color? error,
    Color? fancy,
    Color? purple,
    Color? primary,
  }) {
    return CustomColors(
      cyan: cyan ?? this.cyan,
      brag: brag ?? this.brag,
      good: good ?? this.good,
      error: error ?? this.error,
      fancy: fancy ?? this.fancy,
      purple: purple ?? this.purple,
      primary: primary ?? this.primary,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      cyan: Color.lerp(cyan, other.cyan, t) ?? cyan,
      brag: Color.lerp(brag, other.brag, t) ?? brag,
      good: Color.lerp(good, other.good, t) ?? good,
      error: Color.lerp(error, other.error, t) ?? error,
      fancy: Color.lerp(fancy, other.fancy, t) ?? fancy,
      purple: Color.lerp(purple, other.purple, t) ?? purple,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
    );
  }

  CustomColors harmonized(ColorScheme colorScheme) {
    return copyWith(
      cyan: cyan.harmonizeWith(colorScheme.primary),
      brag: brag.harmonizeWith(colorScheme.primary),
      good: good.harmonizeWith(colorScheme.primary),
      error: error.harmonizeWith(colorScheme.primary),
      fancy: fancy.harmonizeWith(colorScheme.primary),
      purple: purple.harmonizeWith(colorScheme.primary),
      primary: primary.harmonizeWith(colorScheme.primary),
    );
  }
}

const lichessCustomColors = CustomColors(
  cyan: LichessColors.cyan,
  brag: LichessColors.brag,
  good: LichessColors.good,
  error: LichessColors.error,
  fancy: LichessColors.fancy,
  purple: LichessColors.purple,
  primary: LichessColors.primary,
);

extension CustomColorsBuildContext on BuildContext {
  CustomColors get lichessColors => Theme.of(this).extension<CustomColors>() ?? lichessCustomColors;
}
