import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<T?> showAdaptiveModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useRootNavigator = false,
  bool expand = false,
}) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return showCupertinoModalBottomSheet(
      useRootNavigator: useRootNavigator,
      context: context,
      builder: builder,
      expand: expand,
    );
  } else {
    return showMaterialModalBottomSheet(
      useRootNavigator: useRootNavigator,
      context: context,
      builder: builder,
      expand: expand,
    );
  }
}
