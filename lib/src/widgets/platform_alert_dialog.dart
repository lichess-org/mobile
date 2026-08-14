import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

/// Displays a [TextButton] for Android and a [CupertinoDialogAction] for iOS.
///
/// To be used with [AlertDialog.adaptive].
class PlatformDialogAction extends StatelessWidget {
  const PlatformDialogAction({
    super.key,
    required this.onPressed,
    required this.child,
    this.cupertinoIsDefaultAction = false,
    this.cupertinoIsDestructiveAction = false,
  });

  /// Callback invoked when the action is pressed.
  final VoidCallback? onPressed;

  /// See [TextButton.child] for Android and [CupertinoDialogAction.child] for iOS.
  final Widget child;

  /// Passed to [CupertinoDialogAction.isDefaultAction] on iOS, no effect on Android.
  final bool cupertinoIsDefaultAction;

  /// Passed to [CupertinoDialogAction.isDestructiveAction] on iOS, no effect on Android.
  final bool cupertinoIsDestructiveAction;

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
