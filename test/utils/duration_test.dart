import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  final mockAppLocalizations = MockAppLocalizations();

  setUpAll(() {
    for (final n in [0, 1, 2, 3, 5, 18, 24]) {
      when(() => mockAppLocalizations.nbDays(n)).thenReturn('$n day${n == 1 ? '' : 's'}');
      when(() => mockAppLocalizations.nbHours(n)).thenReturn('$n hour${n == 1 ? '' : 's'}');
      when(() => mockAppLocalizations.nbMinutes(n)).thenReturn('$n minute${n == 1 ? '' : 's'}');
    }
  });

  group('DurationExtensions.toDaysHoursMinutes()', () {
    // Mirrors lila's `translateDuration` in
    // `modules/coreI18n/src/main/i18n.scala`.

    test('hours+minutes are joined with ", " and minutes shown when no days', () {
      testTimeStr(mockAppLocalizations, 0, 2, 2, '2 hours, 2 minutes');
    });

    test('minutes are omitted when there is at least one day', () {
      testTimeStr(mockAppLocalizations, 3, 18, 24, '3 days, 18 hours');
    });

    test('singular labels are respected', () {
      testTimeStr(mockAppLocalizations, 1, 1, 1, '1 day, 1 hour');
    });

    test('middle zero hours are preserved when days are nonzero', () {
      testTimeStr(mockAppLocalizations, 2, 0, 5, '2 days, 0 hours');
    });

    test('leading zero days are dropped', () {
      testTimeStr(mockAppLocalizations, 0, 2, 2, '2 hours, 2 minutes');
    });

    test('leading zero days and hours are dropped', () {
      testTimeStr(mockAppLocalizations, 0, 0, 2, '2 minutes');
    });

    test('only days', () {
      testTimeStr(mockAppLocalizations, 2, 0, 0, '2 days, 0 hours');
    });

    test('only hours', () {
      testTimeStr(mockAppLocalizations, 0, 2, 0, '2 hours, 0 minutes');
    });

    test('one day no hours no minutes -> "1 day, 0 hours"', () {
      testTimeStr(mockAppLocalizations, 1, 0, 0, '1 day, 0 hours');
    });

    test('all values zero -> "0 minutes"', () {
      testTimeStr(mockAppLocalizations, 0, 0, 0, '0 minutes');
    });
  });
  group('DurationExtensions.toHoursMinutesSeconds()', () {
    test('formats without tenths correctly', () {
      const d = Duration(minutes: 5, seconds: 30, milliseconds: 600);
      expect(d.toHoursMinutesSeconds(showTenths: false), '05:30');
    });

    test('formats with tenths correctly under an hour', () {
      const d = Duration(minutes: 5, seconds: 30, milliseconds: 600);
      expect(d.toHoursMinutesSeconds(showTenths: true), '05:30.6');
    });

    test('correct tenth truncation', () {
      const d = Duration(seconds: 120, milliseconds: 30);
      expect(d.toHoursMinutesSeconds(showTenths: true), '02:00.0');

      const d2 = Duration(seconds: 120, milliseconds: 880);
      expect(d2.toHoursMinutesSeconds(showTenths: true), '02:00.8');
    });

    test('does not show tenths for durations over an hour even if showTenths is true', () {
      const d = Duration(hours: 1, minutes: 5, seconds: 30, milliseconds: 600);
      expect(d.toHoursMinutesSeconds(showTenths: true), '1:05:30');
    });
  });
}

void testTimeStr(
  MockAppLocalizations mockAppLocalizations,
  int days,
  int hours,
  int minutes,
  String expected,
) {
  final timeStr = Duration(
    days: days,
    hours: hours,
    minutes: minutes,
  ).toDaysHoursMinutes(mockAppLocalizations);
  expect(timeStr, expected);
}
