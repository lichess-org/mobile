import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute<void>> watchRouteObserver =
    RouteObserver<PageRoute<void>>();

/// Push a new route using Navigator
///
/// Will use [MaterialPageRoute] on Android and [CupertinoPageRoute] on iOS.
Future<void> pushPlatformRoute(
  BuildContext context, {
  required WidgetBuilder builder,
  bool rootNavigator = false,
  String? title,
}) {
  return Navigator.of(context, rootNavigator: rootNavigator).push<void>(
    defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoPageRoute(builder: builder, title: title)
        : MaterialPageRoute(
            builder: builder,
          ),
  );
}
