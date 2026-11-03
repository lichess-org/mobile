import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// Shows a platform adaptive choice picker dialog
///
/// On Android, it shows a dialog with radio buttons.
/// On iOS, it shows a liquid glass action sheet if the number of choices is less than or equal to 10.
/// Otherwise, it shows a [CupertinoPicker].
Future<void> showChoicePicker<T>(
  BuildContext context, {
  Widget? title,
  required List<T> choices,
  required T selectedItem,
  required Widget Function(T choice) labelBuilder,
  void Function(T choice)? onSelectedItemChanged,
}) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
      final deviceHeight = MediaQuery.heightOf(context);
      return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title,
            clipBehavior: Clip.hardEdge,
            contentPadding: const EdgeInsets.only(top: 16.0, bottom: 24.0, left: 0, right: 0),
            scrollable: true,
            content: Builder(
              builder: (context) {
                final List<Widget> choiceWidgets = choices
                    .map((value) {
                      return RadioListTile<T>(title: labelBuilder(value), value: value);
                    })
                    .toList(growable: false);
                return RadioGroup(
                  groupValue: selectedItem,
                  onChanged: (value) {
                    if (value is T && onSelectedItemChanged != null) {
                      onSelectedItemChanged(value);
                      Navigator.of(context).pop();
                    }
                  },
                  child: choiceWidgets.length >= 10
                      ? SizedBox(
                          width: double.maxFinite,
                          height: deviceHeight * 0.6,
                          child: ListView(shrinkWrap: true, children: choiceWidgets),
                        )
                      : ListBody(children: choiceWidgets),
                );
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
        return showCupertinoActionSheet<void>(
          context: context,
          title: title,
          actions: [
            for (final value in choices)
              BottomSheetAction(
                makeLabel: (_) => labelBuilder(value),
                onPressed: () => onSelectedItemChanged?.call(value),
              ),
          ],
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
                  children: choices.map((value) {
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
      return PlatformAlertDialog(
        contentPadding: const EdgeInsets.only(top: 12),
        scrollable: true,
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Material ancestor is needed for CheckboxListTile.adaptive to work on iOS
            return Material(
              type: MaterialType.transparency,
              child: Column(
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
              ),
            );
          },
        ),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
          PlatformDialogAction(
            cupertinoIsDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(items),
            child: Text(context.l10n.mobileOkButton),
          ),
        ],
      );
    },
  );
}
