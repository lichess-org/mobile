import 'package:lichess_mobile/l10n/l10n.dart';

extension DurationExtensions on Duration {
  /// Returns a string representation of this duration, like H:MM:SS.m
  ///
  /// If [showTenths] is `true` and the duration is less than one hour, the
  /// representation is H:MM:SS.m, otherwise it is H:MM:SS.
  String toHoursMinutesSeconds({bool showTenths = false}) {
    if (inHours == 0) {
      return '${inMinutes.remainder(60).toString().padLeft(2, '0')}:${inSeconds.remainder(60).toString().padLeft(2, '0')}${showTenths ? '.${inMilliseconds.remainder(1000) ~/ 100}' : ''}';
    } else {
      return '$inHours:${inMinutes.remainder(60).toString().padLeft(2, '0')}:${inSeconds.remainder(60).toString().padLeft(2, '0')}';
    }
  }

  /// Returns the duration formatted as a comma-separated list of localised
  /// day / hour / minute parts, matching lila's `translateDuration` in
  /// `modules/coreI18n/src/main/i18n.scala`.
  String toDaysHoursMinutes(AppLocalizations l10n) {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);

    final slots = <({String text, bool dropIfZero, int value})>[
      (text: l10n.nbDays(days), dropIfZero: true, value: days),
      (text: l10n.nbHours(hours), dropIfZero: true, value: hours),
      if (days == 0) (text: l10n.nbMinutes(minutes), dropIfZero: false, value: minutes),
    ];

    final parts = <String>[];
    var droppingLeading = true;
    for (final slot in slots) {
      if (droppingLeading && slot.dropIfZero && slot.value == 0) continue;
      droppingLeading = false;
      parts.add(slot.text);
    }

    if (parts.isEmpty) {
      return l10n.nbMinutes(0);
    }

    return parts.join(', ');
  }
}
