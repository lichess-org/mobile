import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';

extension DurationExtensions on Duration {
  String toDaysHoursMinutes(BuildContext context) {
    /*
      I may have made this function unnecessarily complex, but I believe that
      only displaying nonzero values makes it better looking.
    */

    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);

    String daysString = days == 0 ? '' : context.l10n.nbDays(days);
    final String hoursString =
        hours == 0 ? '' : '${context.l10n.nbHours(hours)} ';
    final String minutesString =
        minutes == 0 ? '' : context.l10n.nbMinutes(minutes);

    // Add comma if all values are nonzero
    if (days != 0 && hours != 0 && minutes != 0) {
      daysString = '$daysString, ';
    } else if (days != 0) {
      daysString = '$daysString ';
    }

    int valueCount = 0;
    for (final value in [days, hours, minutes]) {
      if (value != 0) {
        ++valueCount;
      }
    }

    if (valueCount == 0) {
      return context.l10n.nbMinutes(0);
    }

    final String and = valueCount > 1 ? 'and ' : '';

    return '$daysString$hoursString$and$minutesString';
  }
}
