import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';

class YesNoDialog extends StatelessWidget {
  const YesNoDialog({
    super.key,
    this.title,
    this.content,
    required this.onYes,
    required this.onNo,
    this.alignment,
  });

  final Widget? title;
  final Widget? content;
  final VoidCallback onYes;
  final VoidCallback onNo;
  final AlignmentGeometry? alignment;

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
        alignment: alignment,
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
