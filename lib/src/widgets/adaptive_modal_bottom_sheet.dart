import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<T?> showAdaptiveModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool expand = false,
}) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return showCupertinoModalBottomSheet(
      context: context,
      builder: builder,
      expand: expand,
    );
  } else {
    return showMaterialModalBottomSheet(
      context: context,
      builder: builder,
      expand: expand,
    );
  }
}
