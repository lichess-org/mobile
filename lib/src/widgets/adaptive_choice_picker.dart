import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

Future<void> showChoicePicker<T extends Enum>(
  BuildContext context, {
  required List<T> choices,
  required T selectedItem,
  required Widget Function(T choice) labelBuilder,
  void Function(T choice)? onSelectedItemChanged,
}) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(top: 12),
            scrollable: true,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: choices.map((value) {
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
              }).toList(growable: false),
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
      return showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return NotificationListener(
            onNotification: (ScrollEndNotification notification) {
              if (onSelectedItemChanged != null) {
                final index =
                    (notification.metrics as FixedExtentMetrics).itemIndex;
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
                children: choices.map((value) {
                  return Center(
                    child: labelBuilder(value),
                  );
                }).toList(),
                onSelectedItemChanged: (_) {},
              ),
            ),
          );
        },
      );
    default:
      throw Exception('Unexpected platform $defaultTargetPlatform');
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
              children: choices.map((choice) {
                return CheckboxListTile.adaptive(
                  title: labelBuilder(choice),
                  value: items.contains(choice),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        items = value
                            ? items.union({choice})
                            : items.difference({choice});
                      });
                    }
                  },
                );
              }).toList(growable: false),
            );
          },
        ),
        actions: defaultTargetPlatform == TargetPlatform.iOS
            ? [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.cancel),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(items),
                ),
              ]
            : [
                TextButton(
                  child: Text(context.l10n.cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(items),
                ),
              ],
      );
    },
  );
}
