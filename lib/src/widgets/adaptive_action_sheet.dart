import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

/// A action bottom sheet that adapts to the platform (Android/iOS).
///
/// [actions] The Actions list that will appear on the ActionSheet. (required)
///
/// [title] The optional title widget that show above the actions.
///
/// The optional [isDismissible] can be passed to set barrierDismissible of showCupertinoModalPopup
/// and isDismissible of showModalBottomSheet (Default true as for both implementations)
Future<T?> showAdaptiveActionSheet<T>({
  required BuildContext context,
  Widget? title,
  required List<BottomSheetAction> actions,
  bool isDismissible = true,
}) async {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoActionSheet(
      context: context,
      title: title,
      actions: actions,
      isDismissible: isDismissible,
    );
  } else {
    return showMaterialActionSheet(
      context: context,
      title: title,
      actions: actions,
      isDismissible: isDismissible,
    );
  }
}

Future<T?> showConfirmDialog<T>(
  BuildContext context, {
  required Widget title,
  required void Function(BuildContext context) onConfirm,

  /// Only for iOS
  bool isDestructiveAction = false,
}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (_) => title,
          isDestructiveAction: isDestructiveAction,
          onPressed: onConfirm,
        ),
      ],
    );
  } else {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: Text(context.l10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: Text(context.l10n.mobileOkButton),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm(context);
              },
            ),
          ],
        );
      },
    );
  }
}

Future<T?> showCupertinoActionSheet<T>({
  required BuildContext context,
  Widget? title,
  required List<BottomSheetAction> actions,
  bool isDismissible = true,
}) {
  return showCupertinoModalPopup(
    context: context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: title,
        actions:
            actions
                .map(
                  // Builder is used to retrieve the context immediately surrounding the button
                  // This is necessary to get the correct context for the iPad share dialog
                  // which needs the position of the action to display the share dialog
                  (action) => Builder(
                    builder: (context) {
                      return CupertinoActionSheetAction(
                        onPressed: () {
                          if (action.dismissOnPress) {
                            Navigator.of(context).pop();
                          }
                          action.onPressed(context);
                        },
                        isDestructiveAction: action.isDestructiveAction,
                        isDefaultAction: action.isDefaultAction,
                        child: action.makeLabel(context),
                      );
                    },
                  ),
                )
                .toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.cancel),
        ),
      );
    },
  );
}

Future<T?> showMaterialActionSheet<T>({
  required BuildContext context,
  Widget? title,
  required List<BottomSheetAction> actions,
  bool isDismissible = true,
}) {
  final actionTextStyle = Theme.of(context).textTheme.titleMedium ?? const TextStyle(fontSize: 18);

  final screenWidth = MediaQuery.of(context).size.width;
  return showDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          width: min(screenWidth, kMaterialPopupMenuMaxWidth),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null) ...[
                  Padding(padding: const EdgeInsets.all(16.0), child: Center(child: title)),
                ],
                ...actions.mapIndexed<Widget>((index, action) {
                  return InkWell(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(index == 0 ? 28 : 0),
                      bottom: Radius.circular(index == actions.length - 1 ? 28 : 0),
                    ),
                    onTap: () {
                      if (action.dismissOnPress) {
                        Navigator.of(context).pop();
                      }
                      action.onPressed(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          if (action.leading != null) ...[
                            action.leading!,
                            const SizedBox(width: 15),
                          ],
                          Expanded(
                            child: DefaultTextStyle(
                              style: actionTextStyle,
                              textAlign:
                                  action.leading != null ? TextAlign.start : TextAlign.center,
                              child: action.makeLabel(context),
                            ),
                          ),
                          if (action.trailing != null) ...[
                            const SizedBox(width: 10),
                            action.trailing!,
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// The Actions model that will use on the ActionSheet.
class BottomSheetAction {
  /// A function that returns the label widget. (required)
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  final Widget Function(BuildContext context) makeLabel;

  /// The callback that is called when the action item is tapped. (required)
  final void Function(BuildContext context) onPressed;

  /// Whether the modal should be dismissed when an action is pressed.
  ///
  /// Default to true.
  final bool dismissOnPress;

  /// A widget to display after the label.
  ///
  /// Typically an [Icon] widget. (Android only).
  final Widget? trailing;

  /// A widget to display before the label.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget. (Android only).
  final Widget? leading;

  /// Whether the action is destructive. (iOS only).
  final bool isDestructiveAction;

  /// Whether the action is the default action. (iOS only).
  final bool isDefaultAction;

  BottomSheetAction({
    required this.makeLabel,
    required this.onPressed,
    this.dismissOnPress = true,
    this.trailing,
    this.leading,
    this.isDestructiveAction = false,
    this.isDefaultAction = false,
  });
}
