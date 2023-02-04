import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

abstract class Styles {
  // text
  static const bold = TextStyle(fontWeight: FontWeight.bold);
  static const sectionTitle = TextStyle(fontSize: 16);
  static const subtitleOpacity = 0.7;

  // spacing
  static const bodyPadding =
      EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0);
}

/// Retrieve the default text color and apply an opacity to it.
Color? textShade(BuildContext context, double opacity) =>
    DefaultTextStyle.of(context).style.color?.withOpacity(opacity);

Color? dividerColor(BuildContext context) =>
    defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.separator.resolveFrom(context)
        : null;
