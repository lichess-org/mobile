import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A modal bottom sheet that adapts to the platform (Android/iOS).
Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool useRootNavigator = true,
  bool useSafeArea = true,
  bool? showDragHandle,
  BoxConstraints? constraints,
}) async {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    showDragHandle: showDragHandle,
    isScrollControlled: true,
    useRootNavigator: useRootNavigator,
    useSafeArea: useSafeArea,
    backgroundColor: defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoDynamicColor.resolve(
            CupertinoColors.secondarySystemBackground,
            context,
          )
        : null,
    elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0 : null,
    builder: builder,
  );
}
