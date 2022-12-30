import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

/// Retrieve the default text color and apply an opacity to it.
Color? textShade(BuildContext context, double opacity) =>
    DefaultTextStyle.of(context).style.color?.withOpacity(opacity);

Color? dividerColor(BuildContext context) =>
    defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoDynamicColor.resolve(CupertinoColors.separator, context)
        : null;
