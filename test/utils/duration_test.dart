import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  final mockAppLocalizations = MockAppLocalizations();

  setUpAll(() {
    when(() => mockAppLocalizations.nbDays(2)).thenReturn('2 days');
    when(() => mockAppLocalizations.nbDays(1)).thenReturn('1 day');
    when(() => mockAppLocalizations.nbDays(0)).thenReturn('0 days');

    when(() => mockAppLocalizations.nbHours(2)).thenReturn('2 hours');
    when(() => mockAppLocalizations.nbHours(1)).thenReturn('1 hour');
    when(() => mockAppLocalizations.nbHours(0)).thenReturn('0 hours');

    when(() => mockAppLocalizations.nbMinutes(2)).thenReturn('2 minutes');
    when(() => mockAppLocalizations.nbMinutes(1)).thenReturn('1 minute');
    when(() => mockAppLocalizations.nbMinutes(0)).thenReturn('0 minutes');
  });

  group('DurationExtensions.toDaysHoursMinutes()', () {
    test('all values nonzero, plural', () {
      testTimeStr(mockAppLocalizations, 2, 2, 2, '2 days, 2 hours and 2 minutes');
    });

    test('all values nonzero, plural', () {
      testTimeStr(mockAppLocalizations, 2, 2, 2, '2 days, 2 hours and 2 minutes');
    });

    test('all values nonzero, single', () {
      testTimeStr(mockAppLocalizations, 1, 1, 1, '1 day, 1 hour and 1 minute');
    });

    test('no days', () {
      testTimeStr(mockAppLocalizations, 0, 2, 2, '2 hours and 2 minutes');
    });

    test('no hours', () {
      testTimeStr(mockAppLocalizations, 2, 0, 2, '2 days and 2 minutes');
    });

    test('no minutes', () {
      testTimeStr(mockAppLocalizations, 2, 2, 0, '2 days and 2 hours');
    });

    test('only days', () {
      testTimeStr(mockAppLocalizations, 2, 0, 0, '2 days');
    });

    test('only hours', () {
      testTimeStr(mockAppLocalizations, 0, 2, 0, '2 hours');
    });

    test('only minutes', () {
      testTimeStr(mockAppLocalizations, 0, 0, 2, '2 minutes');
    });

    test('all values zero', () {
      testTimeStr(mockAppLocalizations, 0, 0, 0, '0 minutes');
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
