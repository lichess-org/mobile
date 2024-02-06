import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Push a new route using Navigator
///
/// Will use [MaterialPageRoute] on Android and [CupertinoPageRoute] on iOS.
Future<void> pushPlatformRoute(
  BuildContext context, {
  required WidgetBuilder builder,
  bool rootNavigator = false,
  bool fullscreenDialog = false,
  String? title,
}) {
  return Navigator.of(
    context,
    rootNavigator: rootNavigator,
  ).push<void>(
    Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoPageRoute(
            builder: builder,
            title: title,
            fullscreenDialog: fullscreenDialog,
          )
        : MaterialPageRoute(
            builder: builder,
            fullscreenDialog: fullscreenDialog,
          ),
  );
}

Future<void> pushReplacementPlatformRoute(
  BuildContext context, {
  required WidgetBuilder builder,
  bool rootNavigator = false,
  bool fullscreenDialog = false,
  String? title,
}) {
  return Navigator.of(
    context,
    rootNavigator: rootNavigator,
  ).pushReplacement<void, void>(
    Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoPageRoute(
            builder: builder,
            title: title,
            fullscreenDialog: fullscreenDialog,
          )
        : MaterialPageRoute(
            builder: builder,
            fullscreenDialog: fullscreenDialog,
          ),
  );
}
