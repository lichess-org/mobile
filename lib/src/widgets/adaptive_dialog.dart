import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';

/// A dialog modal that adapts to the platform (Android/iOS).
Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool? barrierDismissible,
}) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return showCupertinoDialog(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible ?? false,
    );
  } else {
    return showDialog(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible ?? true,
    );
  }
}

class YesNoDialog extends StatelessWidget {
  const YesNoDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onYes,
    required this.onNo,
  });

  final Widget title;
  final Widget content;
  final VoidCallback onYes;
  final VoidCallback onNo;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: onNo,
            child: Text(context.l10n.no),
          ),
          CupertinoDialogAction(
            onPressed: onYes,
            child: Text(context.l10n.yes),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: title,
        content: content,
        actions: [
          TextButton(
            onPressed: onNo,
            child: Text(context.l10n.no),
          ),
          TextButton(
            onPressed: onYes,
            child: Text(context.l10n.yes),
          ),
        ],
      );
    }
  }
}
