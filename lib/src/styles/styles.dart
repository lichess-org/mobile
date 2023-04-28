import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Styles {
  // text
  static const bold = TextStyle(fontWeight: FontWeight.bold);
  static TextStyle get sectionTitle => TextStyle(
        fontSize: defaultTargetPlatform == TargetPlatform.iOS ? 20 : 18,
        fontWeight: FontWeight.bold,
      );
  static const subtitleOpacity = 0.7;

  // padding
  static const bodyPadding =
      EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0);

  static const verticalBodyPadding = EdgeInsets.symmetric(vertical: 16.0);

  /// Gets horizontal padding according to platform.
  static const horizontalBodyPadding = EdgeInsets.symmetric(horizontal: 16.0);

  static const sectionBottomPadding = EdgeInsets.only(bottom: 16);
  static const sectionTopPadding = EdgeInsets.only(top: 16);

  /// Horizontal and bottom padding for a body section
  static EdgeInsetsGeometry get bodySectionPadding =>
      horizontalBodyPadding.add(sectionBottomPadding).add(sectionTopPadding);

  static EdgeInsetsGeometry get bodySectionBottomPadding =>
      horizontalBodyPadding.add(sectionBottomPadding);
}

/// Retrieve the default text color and apply an opacity to it.
Color? textShade(BuildContext context, double opacity) =>
    DefaultTextStyle.of(context).style.color?.withOpacity(opacity);

Color? dividerColor(BuildContext context) =>
    defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.separator.resolveFrom(context)
        : null;
