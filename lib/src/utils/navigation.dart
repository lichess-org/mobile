import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A page route that always builds the same screen widget.
///
/// This is useful to inspect new screens being pushed to the Navigator in tests.
abstract class ScreenRoute<T extends Object?> extends PageRoute<T> {
  /// The widget that this page route always builds.
  Widget get screen;
}

/// A [MaterialPageRoute] that always builds the same screen widget.
///
/// This is useful to test new screens being pushed to the Navigator.
class MaterialScreenRoute<T extends Object?> extends MaterialPageRoute<T>
    implements ScreenRoute<T> {
  MaterialScreenRoute({
    required this.screen,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
  }) : super(builder: (_) => screen);

  @override
  final Widget screen;
}

/// A [CupertinoPageRoute] that always builds the same screen widget.
///
/// This is useful to test new screens being pushed to the Navigator.
class CupertinoScreenRoute<T extends Object?> extends CupertinoPageRoute<T>
    implements ScreenRoute<T> {
  CupertinoScreenRoute({
    required this.screen,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
    super.title,
  }) : super(builder: (_) => screen);

  @override
  final Widget screen;
}

/// Push a new route using Navigator.
///
/// {@macro lichess.navigation.builder_or_screen}
Future<void> pushPlatformRoute(
  BuildContext context, {
  Widget? screen,
  WidgetBuilder? builder,
  bool rootNavigator = false,
  bool fullscreenDialog = false,
  String? title,
}) {
  assert(screen != null || builder != null, 'Either screen or builder must be provided.');

  return Navigator.of(context, rootNavigator: rootNavigator).push<void>(
    createPlatformRoute(
      context,
      builder: builder,
      screen: screen,
      fullscreenDialog: fullscreenDialog,
      title: title,
    ),
  );
}

/// Push a new route using Navigator and replace the current route.
///
/// {@macro lichess.navigation.builder_or_screen}
Future<void> pushReplacementPlatformRoute(
  BuildContext context, {
  WidgetBuilder? builder,
  Widget? screen,
  bool rootNavigator = false,
  bool fullscreenDialog = false,
  String? title,
}) {
  return Navigator.of(context, rootNavigator: rootNavigator).pushReplacement<void, void>(
    createPlatformRoute(
      context,
      builder: builder,
      screen: screen,
      fullscreenDialog: fullscreenDialog,
      title: title,
    ),
  );
}

/// Create a route from either [builder] or [screen].
///
/// {@template lichess.navigation.builder_or_screen}
/// If [builder] is provided, it will return a [MaterialPageRoute] on Android and
/// a [CupertinoPageRoute] on iOS.
///
/// If [screen] is provided, it will return a [MaterialScreenRoute] on Android and
/// a [CupertinoScreenRoute] on iOS.
/// {@endtemplate}
Route<dynamic> createPlatformRoute(
  BuildContext context, {
  Widget? screen,
  WidgetBuilder? builder,
  bool fullscreenDialog = false,
  String? title,
}) {
  assert(screen != null || builder != null, 'Either screen or builder must be provided.');

  return Theme.of(context).platform == TargetPlatform.iOS
      ? builder != null
          ? CupertinoPageRoute(builder: builder, title: title, fullscreenDialog: fullscreenDialog)
          : CupertinoScreenRoute(screen: screen!, title: title, fullscreenDialog: fullscreenDialog)
      : builder != null
      ? MaterialPageRoute(builder: builder, fullscreenDialog: fullscreenDialog)
      : MaterialScreenRoute(screen: screen!, fullscreenDialog: fullscreenDialog);
}
