import 'package:lichess_mobile/l10n/l10n.dart';

extension DurationExtensions on Duration {
  /// Returns a string representation of this duration, like H:MM:SS.mm.
  ///
  /// If [showTenths] is `true` and the duration is less than one hour, the
  /// representation is H:MM:SS.mm, otherwise it is H:MM:SS.
  String toHoursMinutesSeconds({bool showTenths = false}) {
    if (inHours == 0) {
      return '${inMinutes.remainder(60).toString().padLeft(2, '0')}:${inSeconds.remainder(60).toString().padLeft(2, '0')}${showTenths ? '.${inMilliseconds.remainder(1000) ~/ 10 % 10}' : ''}';
    } else {
      return '$inHours:${inMinutes.remainder(60).toString().padLeft(2, '0')}:${inSeconds.remainder(60).toString().padLeft(2, '0')}';
    }
  }

  String toDaysHoursMinutes(AppLocalizations l10n) {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);

    String daysString = days == 0 ? '' : l10n.nbDays(days);
    String hoursString = hours == 0 ? '' : l10n.nbHours(hours);
    final String minutesString = minutes == 0 ? '' : l10n.nbMinutes(minutes);

    int valueCount = 0;
    for (final value in [days, hours, minutes]) {
      if (value != 0) {
        ++valueCount;
      }
    }

    if (valueCount == 0) {
      return l10n.nbMinutes(0);
    }

    // Add comma and space if all values are nonzero,
    // add only space if 'daysString' is not the only value.
    if (days != 0 && hours != 0 && minutes != 0) {
      daysString = '$daysString, ';
    } else if (days != 0 && valueCount != 1) {
      daysString = '$daysString ';
    }

    final String and = valueCount > 1 ? 'and ' : '';

    // Avoid case where 'and' is printed after days and hours.
    if (minutes == 0) {
      return '$daysString$and$hoursString';
    }

    // Since we know hoursString either is either the only string, or it goes
    // before 'minutesString', we add a space after it, if it's not the only value.
    if (hours != 0 && valueCount != 1) {
      hoursString = '$hoursString ';
    }

    return '$daysString$hoursString$and$minutesString';
  }
}
