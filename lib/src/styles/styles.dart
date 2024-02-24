import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Styles {
  // text
  static const bold = TextStyle(fontWeight: FontWeight.bold);
  static const title = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
  static const callout = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );
  static TextStyle get sectionTitle => TextStyle(
        fontSize: defaultTargetPlatform == TargetPlatform.iOS ? 20 : 18,
        letterSpacing:
            defaultTargetPlatform == TargetPlatform.iOS ? -0.41 : null,
        fontWeight: FontWeight.bold,
      );
  static const boardPreviewTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const subtitleOpacity = 0.7;
  static const timeControl = TextStyle(
    letterSpacing: 1.2,
  );
  static const formLabel = TextStyle(
    fontWeight: FontWeight.bold,
  );
  static const formError = TextStyle(
    color: LichessColors.red,
  );
  static const formDescription = TextStyle(fontSize: 12);

  // padding
  static const cupertinoAppBarTrailingWidgetPadding =
      EdgeInsetsDirectional.only(
    end: 8.0,
  );
  static const bodyPadding =
      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0);
  static const verticalBodyPadding = EdgeInsets.symmetric(vertical: 16.0);

  // colors
  static Color? expansionTileColor(BuildContext context) =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoColors.secondaryLabel.resolveFrom(context)
          : null;

  /// Gets horizontal padding according to platform.
  static const horizontalBodyPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const sectionBottomPadding = EdgeInsets.only(bottom: 16);
  static const sectionTopPadding = EdgeInsets.only(top: 16);

  /// Horizontal and bottom padding for a body section
  static EdgeInsetsGeometry get bodySectionPadding =>
      horizontalBodyPadding.add(sectionBottomPadding).add(sectionTopPadding);

  static EdgeInsetsGeometry get bodySectionBottomPadding =>
      horizontalBodyPadding.add(sectionBottomPadding);

  // from:
  // https://github.com/flutter/flutter/blob/796c8ef79279f9c774545b3771238c3098dbefab/packages/flutter/lib/src/cupertino/bottom_tab_bar.dart#L17
  static const Color cupertinoDefaultTabBarBorderColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0x4D000000),
    darkColor: Color(0x29000000),
  );
}

/// Retrieve the default text color and apply an opacity to it.
Color? textShade(BuildContext context, double opacity) =>
    DefaultTextStyle.of(context).style.color?.withOpacity(opacity);

Color? dividerColor(BuildContext context) =>
    defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.separator.resolveFrom(context)
        : null;

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.brag,
    required this.good,
    required this.error,
    required this.fancy,
  });

  final Color brag;
  final Color good;
  final Color error;
  final Color fancy;

  @override
  CustomColors copyWith({
    Color? brag,
    Color? good,
    Color? error,
    Color? fancy,
  }) {
    return CustomColors(
      brag: brag ?? this.brag,
      good: good ?? this.good,
      error: error ?? this.error,
      fancy: fancy ?? this.fancy,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      brag: Color.lerp(brag, other.brag, t) ?? brag,
      good: Color.lerp(good, other.good, t) ?? good,
      error: Color.lerp(error, other.error, t) ?? error,
      fancy: Color.lerp(fancy, other.fancy, t) ?? fancy,
    );
  }

  CustomColors harmonized(ColorScheme colorScheme) {
    return copyWith(
      brag: brag.harmonizeWith(colorScheme.primary),
      good: good.harmonizeWith(colorScheme.primary),
      error: error.harmonizeWith(colorScheme.primary),
      fancy: fancy.harmonizeWith(colorScheme.primary),
    );
  }
}

const lichessCustomColors = CustomColors(
  brag: LichessColors.brag,
  good: LichessColors.good,
  error: LichessColors.error,
  fancy: LichessColors.fancy,
);

extension CustomColorsBuildContext on BuildContext {
  CustomColors get lichessColors =>
      Theme.of(this).extension<CustomColors>() ?? lichessCustomColors;
}
