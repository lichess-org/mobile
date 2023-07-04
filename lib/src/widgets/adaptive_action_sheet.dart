import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

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
  if (defaultTargetPlatform == TargetPlatform.iOS) {
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
        actions: actions
            .map(
              (action) => CupertinoActionSheetAction(
                onPressed: () {
                  action.onPressed(context);
                  if (action.dismissOnPress) {
                    Navigator.of(context).pop();
                  }
                },
                isDestructiveAction: action.isDestructiveAction,
                child: action.label,
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
  final defaultTextStyle =
      Theme.of(context).textTheme.titleLarge ?? const TextStyle(fontSize: 20);
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    isScrollControlled: true,
    builder: (BuildContext context) {
      final double screenHeight = MediaQuery.of(context).size.height;
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async => isDismissible,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight - (screenHeight / 10),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (title != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: title),
                    ),
                  ],
                  ...actions.mapIndexed<Widget>((index, action) {
                    return InkWell(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          index == 0 ? 28 : 0,
                        ),
                      ),
                      onTap: () {
                        action.onPressed(context);
                        if (action.dismissOnPress) {
                          Navigator.of(context).pop();
                        }
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
                                style: defaultTextStyle,
                                textAlign: action.leading != null
                                    ? TextAlign.start
                                    : TextAlign.center,
                                child: action.label,
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
        ),
      );
    },
  );
}

/// The Actions model that will use on the ActionSheet.
class BottomSheetAction {
  /// The primary content of the action sheet.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  final Widget label;

  /// The callback that is called when the action item is tapped. (required)
  final void Function(BuildContext context) onPressed;

  /// Whether the modal should be dismissed when an action is pressed.
  ///
  /// Default to true.
  final bool dismissOnPress;

  /// A widget to display after the label.
  ///
  /// Typically an [Icon] widget. Only for android.
  final Widget? trailing;

  /// A widget to display before the label.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget. Only for android.
  final Widget? leading;

  final bool isDestructiveAction;

  BottomSheetAction({
    required this.label,
    required this.onPressed,
    this.dismissOnPress = true,
    this.trailing,
    this.leading,
    this.isDestructiveAction = false,
  });
}
