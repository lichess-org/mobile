import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAdaptiveDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  required void Function(DateTime?) onDateTimeChanged,
}) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
      showCupertinoModalPopup<DateTime?>(
        context: context,
        builder: (context) {
          return Builder(
            builder: (context) {
              return SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  backgroundColor: CupertinoColors.systemBackground.resolveFrom(
                    context,
                  ),
                  initialDateTime: initialDate,
                  minimumDate: firstDate,
                  maximumDate: lastDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: onDateTimeChanged,
                ),
              );
            },
          );
        },
      );

    default:
      showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      ).then(onDateTimeChanged);
  }
}
