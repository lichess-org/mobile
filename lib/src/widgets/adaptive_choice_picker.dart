import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

/// Shows a platform adaptive choice picker dialog
///
/// On Android, it shows a dialog with radio buttons.
/// On iOS, it shows a modal action sheet if the number of choices is less than or equal to 10.
/// Otherwise, it shows a [CupertinoPicker].
Future<void> showChoicePicker<T>(
  BuildContext context, {
  required List<T> choices,
  required T selectedItem,
  required Widget Function(T choice) labelBuilder,
  void Function(T choice)? onSelectedItemChanged,
}) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
      final deviceHeight = MediaQuery.sizeOf(context).height;
      return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(top: 12),
            scrollable: true,
            content: Builder(
              builder: (context) {
                final List<Widget> choiceWidgets = choices
                    .map((value) {
                      return RadioListTile<T>(
                        title: labelBuilder(value),
                        value: value,
                        groupValue: selectedItem,
                        onChanged: (value) {
                          if (value != null && onSelectedItemChanged != null) {
                            onSelectedItemChanged(value);
                            Navigator.of(context).pop();
                          }
                        },
                      );
                    })
                    .toList(growable: false);
                return choiceWidgets.length >= 10
                    ? SizedBox(
                      width: double.maxFinite,
                      height: deviceHeight * 0.6,
                      child: ListView(shrinkWrap: true, children: choiceWidgets),
                    )
                    : Column(mainAxisSize: MainAxisSize.min, children: choiceWidgets);
              },
            ),
            actions: [
              TextButton(
                child: Text(context.l10n.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    case TargetPlatform.iOS:
      if (choices.length <= 10) {
        return showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              actions:
                  choices.map((value) {
                    return CupertinoActionSheetAction(
                      onPressed: () {
                        if (onSelectedItemChanged != null) {
                          onSelectedItemChanged(value);
                        }
                        Navigator.of(context).pop();
                      },
                      child: labelBuilder(value),
                    );
                  }).toList(),
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.cancel),
              ),
            );
          },
        );
      } else {
        return showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return NotificationListener(
              onNotification: (ScrollEndNotification notification) {
                if (onSelectedItemChanged != null) {
                  final index = (notification.metrics as FixedExtentMetrics).itemIndex;
                  onSelectedItemChanged(choices[index]);
                }
                return false;
              },
              child: SizedBox(
                height: 250,
                child: CupertinoPicker(
                  backgroundColor: Theme.of(context).canvasColor,
                  useMagnifier: true,
                  magnification: 1.1,
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: choices.indexWhere((t) => t == selectedItem),
                  ),
                  children:
                      choices.map((value) {
                        return Center(child: labelBuilder(value));
                      }).toList(),
                  onSelectedItemChanged: (_) {},
                ),
              ),
            );
          },
        );
      }
    default:
      throw Exception('Unexpected platform $Theme.of(context).platform');
  }
}

Future<Set<T>?> showMultipleChoicesPicker<T extends Enum>(
  BuildContext context, {
  required Iterable<T> choices,
  required Iterable<T> selectedItems,
  required Widget Function(T choice) labelBuilder,
}) {
  return showAdaptiveDialog<Set<T>>(
    context: context,
    builder: (context) {
      Set<T> items = {...selectedItems};
      return AlertDialog.adaptive(
        contentPadding: const EdgeInsets.only(top: 12),
        scrollable: true,
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: choices
                  .map((choice) {
                    return CheckboxListTile.adaptive(
                      title: labelBuilder(choice),
                      value: items.contains(choice),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            items = value ? items.union({choice}) : items.difference({choice});
                          });
                        }
                      },
                    );
                  })
                  .toList(growable: false),
            );
          },
        ),
        actions:
            Theme.of(context).platform == TargetPlatform.iOS
                ? [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancel),
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(context.l10n.mobileOkButton),
                    onPressed: () => Navigator.of(context).pop(items),
                  ),
                ]
                : [
                  TextButton(
                    child: Text(context.l10n.cancel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text(context.l10n.mobileOkButton),
                    onPressed: () => Navigator.of(context).pop(items),
                  ),
                ],
      );
    },
  );
}
