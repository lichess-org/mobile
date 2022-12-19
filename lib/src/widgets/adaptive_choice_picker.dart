import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A choice picker that adapts to the platform (Android/iOS).
///
/// [choices] The choices list that will appear on the picker. (required)
void showChoicePicker(
  BuildContext context,
  List<String> choices,
) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      showDialog<void>(
        context: context,
        builder: (context) {
          int? selectedRadio = 1;
          return AlertDialog(
            contentPadding: const EdgeInsets.only(top: 12),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(choices.length, (index) {
                    return RadioListTile<int?>(
                      title: Text(choices[index]),
                      value: index,
                      groupValue: selectedRadio,
                      onChanged: (value) {
                        setState(() => selectedRadio = value);
                      },
                    );
                  }),
                );
              },
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    case TargetPlatform.iOS:
      showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 250,
            child: CupertinoPicker(
              backgroundColor: Theme.of(context).canvasColor,
              useMagnifier: true,
              magnification: 1.1,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: 1),
              children: List<Widget>.generate(choices.length, (index) {
                return Center(
                  child: Text(
                    choices[index],
                    style: const TextStyle(
                      fontSize: 21,
                    ),
                  ),
                );
              }),
              onSelectedItemChanged: (value) {},
            ),
          );
        },
      );
      return;
    default:
      assert(false, 'Unexpected platform $defaultTargetPlatform');
  }
}
