import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

/// Displays an [AlertDialog] for Android and a [CupertinoAlertDialog] for iOS.
class PlatformAlertDialog extends StatelessWidget {
  const PlatformAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const <PlatformDialogAction>[],
  });

  /// See [AlertDialog.title] for Android and [CupertinoAlertDialog.title] for iOS.
  final Widget? title;

  /// See [AlertDialog.content] for Android and [CupertinoAlertDialog.content] for iOS.
  final Widget? content;

  /// See [AlertDialog.actions] for Android and [CupertinoAlertDialog.actions] for iOS.
  final List<PlatformDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) => AlertDialog(title: title, content: content, actions: actions),
      iosBuilder:
          (context) => CupertinoAlertDialog(title: title, content: content, actions: actions),
    );
  }
}

/// To be used with [PlatformAlertDialog.actions]. Displays a [TextButton] for Android and a [CupertinoDialogAction] for iOS.
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
      iosBuilder:
          (context) => CupertinoDialogAction(
            onPressed: onPressed,
            isDefaultAction: cupertinoIsDefaultAction,
            isDestructiveAction: cupertinoIsDestructiveAction,
            child: child,
          ),
    );
  }
}
