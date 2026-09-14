import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

/// Displays a [TextButton] for Android and a [CupertinoDialogAction] for iOS.
///
/// To be used with [AlertDialog.adaptive].
class const PlatformDialogAction({
  super.key,

  /// Callback invoked when the action is pressed.
  required final VoidCallback? onPressed,

  /// See [TextButton.child] for Android and [CupertinoDialogAction.child] for iOS.
  required final Widget child,

  /// Passed to [CupertinoDialogAction.isDefaultAction] on iOS, no effect on Android.
  final bool cupertinoIsDefaultAction = false,

  /// Passed to [CupertinoDialogAction.isDestructiveAction] on iOS, no effect on Android.
  final bool cupertinoIsDestructiveAction = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) => TextButton(onPressed: onPressed, child: child),
      iosBuilder: (context) => CupertinoDialogAction(
        onPressed: onPressed,
        isDefaultAction: cupertinoIsDefaultAction,
        isDestructiveAction: cupertinoIsDestructiveAction,
        child: child,
      ),
    );
  }
}
