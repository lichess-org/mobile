import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Styles {
  // text
  static const bold = TextStyle(fontWeight: FontWeight.bold);
  static const title = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  static const subtitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const callout = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const mainListTileTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static const mainListTileIconSize = 28.0;
  static const sectionTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const boardPreviewTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const subtitleOpacity = 0.7;
  static const timeControl = TextStyle(letterSpacing: 1.2);
  static const formLabel = TextStyle(fontWeight: FontWeight.bold);
  static const formError = TextStyle(color: LichessColors.red);
  static const formDescription = TextStyle(fontSize: 12);
  static const linkStyle = TextStyle(color: Colors.blueAccent, decoration: TextDecoration.none);

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

  static Color chartColor(BuildContext context) {
    return ColorScheme.of(context).tertiary;
  }
}

/// Retrieve the default text color and apply an opacity to it.
Color? textShade(BuildContext context, double opacity) =>
    DefaultTextStyle.of(context).style.color?.withValues(alpha: opacity);

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
