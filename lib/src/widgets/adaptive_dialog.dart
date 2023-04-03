import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A dialog modal that adapts to the platform (Android/iOS).
///
Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return showCupertinoDialog(
      context: context,
      builder: builder,
    );
  } else {
    return showDialog(
      context: context,
      builder: builder,
    );
  }
}
