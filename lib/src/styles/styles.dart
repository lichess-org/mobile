import 'dart:math';

import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart';

/// The opacity of the blog and broadcast carousel cards.
const kDefaultCardOpacity = 0.9;

/// The opacity of the blog and broadcast carousel card images on a dark background, where their
/// light colors would otherwise stand out too much.
const kDarkCardImageOpacity = 0.80;

/// The opacity of the blog and broadcast carousel card backgrounds on a dark background: higher
/// than [kDarkCardImageOpacity] so that the text on it keeps enough contrast.
const kDarkCardBackgroundOpacity = 0.9;

// ignore: avoid_classes_with_only_static_members
abstract class Styles() {
  // text
  static const bold = TextStyle(fontWeight: FontWeight.bold);
  static const title = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  static const subtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const callout = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const mainListTileTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static const sectionTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const boardPreviewTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const subtitleOpacity = 0.7;
  static const timeControl = TextStyle(letterSpacing: 1.2);
  static const formLabel = TextStyle(fontWeight: FontWeight.bold);
  static const formDescription = TextStyle(fontSize: 12);
  static const noResultTextStyle = TextStyle(color: Colors.grey, fontSize: 20.0);

  // padding
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

  static const thumbnailBorderRadius = BorderRadius.all(Radius.circular(5.0));

  static TextStyle linkStyle(BuildContext context) {
    final primary = ColorScheme.of(context).primary;
    return TextStyle(color: primary, decoration: TextDecoration.none, decorationColor: primary);
  }

  static Color chartColor(BuildContext context) {
    return ColorScheme.of(context).tertiary;
  }

  /// Minimum chroma of [chartColors], so that colors of a muted scheme stay apart.
  static const _minChartColorsChroma = 40.0;

  /// [count] distinct colors for the series of a chart, which fit in the color scheme.
  ///
  /// The hue of [chartColor] is rotated in equal steps in the HCT color space, the way Material
  /// derives the scheme's own accent colors. Its tone is kept, so the colors have the same contrast
  /// with the surface.
  static List<Color> chartColors(BuildContext context, int count) {
    final base = Hct.fromInt(chartColor(context).toARGB32());
    final chroma = max(base.chroma, _minChartColorsChroma);
    return [
      for (var i = 0; i < count; i++)
        Color(Hct.from((base.hue + i * 360 / count) % 360, chroma, base.tone).toInt()),
    ];
  }
}

/// Retrieve the default text color and apply an opacity to it.
Color? textShade(BuildContext context, double opacity) =>
    DefaultTextStyle.of(context).style.color?.withValues(alpha: opacity);

/// The color of the perf icons (perf cards, game list tiles, activity).
Color perfIconColor(BuildContext context) =>
    ColorScheme.of(context).onSurface.withValues(alpha: 0.6);

Color darken(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, Colors.black, amount) ?? c;
}

Color lighten(Color c, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  return Color.lerp(c, Colors.white, amount) ?? c;
}

@immutable
class const LichessCustomColors({
  required final Color cyan,
  required final Color brag,
  required final Color green,
  required final Color red,
  required final Color fancy,
  required final Color purple,
  required final Color primary,
}) extends ThemeExtension<LichessCustomColors> {
  @override
  LichessCustomColors copyWith({
    Color? cyan,
    Color? brag,
    Color? green,
    Color? red,
    Color? fancy,
    Color? purple,
    Color? primary,
  }) {
    return LichessCustomColors(
      cyan: cyan ?? this.cyan,
      brag: brag ?? this.brag,
      green: green ?? this.green,
      red: red ?? this.red,
      fancy: fancy ?? this.fancy,
      purple: purple ?? this.purple,
      primary: primary ?? this.primary,
    );
  }

  @override
  LichessCustomColors lerp(ThemeExtension<LichessCustomColors>? other, double t) {
    if (other is! LichessCustomColors) {
      return this;
    }
    return LichessCustomColors(
      cyan: Color.lerp(cyan, other.cyan, t) ?? cyan,
      brag: Color.lerp(brag, other.brag, t) ?? brag,
      green: Color.lerp(green, other.green, t) ?? green,
      red: Color.lerp(red, other.red, t) ?? red,
      fancy: Color.lerp(fancy, other.fancy, t) ?? fancy,
      purple: Color.lerp(purple, other.purple, t) ?? purple,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
    );
  }

  LichessCustomColors harmonized(ColorScheme colorScheme) {
    return copyWith(
      cyan: cyan.harmonizeWith(colorScheme.primary),
      brag: brag.harmonizeWith(colorScheme.primary),
      green: green.harmonizeWith(colorScheme.primary),
      red: red.harmonizeWith(colorScheme.primary),
      fancy: fancy.harmonizeWith(colorScheme.primary),
      purple: purple.harmonizeWith(colorScheme.primary),
      primary: primary.harmonizeWith(colorScheme.primary),
    );
  }
}

const lichessCustomColors = LichessCustomColors(
  cyan: LichessColors.cyan,
  brag: LichessColors.brag,
  green: LichessColors.green,
  red: LichessColors.red,
  fancy: LichessColors.fancy,
  purple: LichessColors.purple,
  primary: LichessColors.primary,
);

/// The color scheme of the elements that sit next to the board, such as the eval gauge, so that
/// they match the board colors whatever the app color scheme.
@immutable
class const BoardColorScheme(final ColorScheme colorScheme)
    extends ThemeExtension<BoardColorScheme> {
  @override
  BoardColorScheme copyWith({ColorScheme? colorScheme}) =>
      BoardColorScheme(colorScheme ?? this.colorScheme);

  @override
  BoardColorScheme lerp(ThemeExtension<BoardColorScheme>? other, double t) {
    if (other is! BoardColorScheme) {
      return this;
    }
    return BoardColorScheme(ColorScheme.lerp(colorScheme, other.colorScheme, t));
  }
}

extension CustomColorsBuildContext on BuildContext {
  LichessCustomColors get lichessColors =>
      Theme.of(this).extension<LichessCustomColors>() ?? lichessCustomColors;

  /// The color scheme of the elements that sit next to the board, see [BoardColorScheme].
  ///
  /// Defaults to the app color scheme.
  ColorScheme get boardColorScheme =>
      Theme.of(this).extension<BoardColorScheme>()?.colorScheme ?? ColorScheme.of(this);
}
