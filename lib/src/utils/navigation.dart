import 'package:lichess_mobile/src/widgets/background.dart';
import 'package:material_ui/material_ui.dart';

/// A page route that always builds the same screen widget.
///
/// This is useful to inspect new screens being pushed to the Navigator in tests.
abstract class ScreenRoute<T extends Object?>() extends PageRoute<T> {
  /// The widget that this page route always builds.
  Widget get screen;
}

/// A [MaterialPageRoute] that always builds the same screen widget.
///
/// This route wraps the [screen] with a [FullScreenBackground] to ensure that the background
/// is always filled with the configured app's background color or image.
class MaterialScreenRoute<T extends Object?>({
  @override required final Widget screen,
  super.settings,
  super.maintainState,
  super.fullscreenDialog,
  super.allowSnapshotting,
  final Duration? overrideTransitionDuration,
}) extends MaterialPageRoute<T> implements ScreenRoute<T> {
  this : super(builder: (_) => FullScreenBackground(child: screen));

  @override
  Duration get transitionDuration => overrideTransitionDuration ?? super.transitionDuration;
}

/// Builds a new route for the [screen].
///
/// This route wraps the [screen] with a [FullScreenBackground] to ensure that the background
/// is always filled with the configured app's background color or image.
Route<T> buildScreenRoute<T>({
  required Widget screen,
  bool fullscreenDialog = false,
  RouteSettings? settings,
  Duration? transitionDuration,
}) {
  return MaterialScreenRoute<T>(
    screen: screen,
    fullscreenDialog: fullscreenDialog,
    settings: settings,
    overrideTransitionDuration: transitionDuration,
  );
}
