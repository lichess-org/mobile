import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Styles {
  // text
  static const bold = TextStyle(fontWeight: FontWeight.bold);
  static const sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const subtitleOpacity = 0.7;

  // padding
  static const bodyPadding =
      EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0);

  static const verticalBodyPadding = EdgeInsets.symmetric(vertical: 16.0);

  /// Gets horizontal padding according to platform.
  static EdgeInsets get horizontalBodyPadding =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? const EdgeInsets.symmetric(horizontal: 20.0)
          : const EdgeInsets.symmetric(horizontal: 16.0);

  // spacing
  static const sectionBottomPadding = EdgeInsets.only(bottom: 16);
}

/// Retrieve the default text color and apply an opacity to it.
Color? textShade(BuildContext context, double opacity) =>
    DefaultTextStyle.of(context).style.color?.withOpacity(opacity);

Color? dividerColor(BuildContext context) =>
    defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.separator.resolveFrom(context)
        : null;
