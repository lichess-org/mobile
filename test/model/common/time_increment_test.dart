import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

void main() {
  group('TimeIncrement Tests', () {
    test('Initialization', () {
      const timeIncrement = TimeIncrement(300, 5);
      expect(timeIncrement.time, 300);
      expect(timeIncrement.increment, 5);
      // delay defaults to 0 when omitted
      expect(timeIncrement.delay, 0);
    });

    test('Initialization with delay', () {
      const timeIncrement = TimeIncrement(300, 5, delay: 3);
      expect(timeIncrement.time, 300);
      expect(timeIncrement.increment, 5);
      expect(timeIncrement.delay, 3);
    });

    test('fromDurations with delay', () {
      final timeIncrement = TimeIncrement.fromDurations(
        const Duration(minutes: 5),
        const Duration(seconds: 5),
        delay: const Duration(seconds: 3),
      );
      expect(timeIncrement.time, 300);
      expect(timeIncrement.increment, 5);
      expect(timeIncrement.delay, 3);
    });

    test('JSON Serialization', () {
      final json = const TimeIncrement(300, 5, delay: 3).toJson();
      expect(json['time'], 300);
      expect(json['increment'], 5);
      expect(json['delay'], 3);

      final newTimeIncrement = TimeIncrement.fromJson(json);
      expect(newTimeIncrement.time, 300);
      expect(newTimeIncrement.increment, 5);
      expect(newTimeIncrement.delay, 3);
    });

    test('JSON deserialization is backward compatible (no delay key)', () {
      // Persisted prefs from before the delay feature won't have a 'delay' key.
      final timeIncrement = TimeIncrement.fromJson(const {'time': 300, 'increment': 5});
      expect(timeIncrement.time, 300);
      expect(timeIncrement.increment, 5);
      expect(timeIncrement.delay, 0);
    });

    test('Display Strings', () {
      expect(const TimeIncrement(0, 0).display, '∞');
      expect(const TimeIncrement(0, 5).display, '0+5');
      expect(const TimeIncrement(45, 5).display, '¾+5');
      expect(const TimeIncrement(30, 5).display, '½+5');
      expect(const TimeIncrement(15, 5).display, '¼+5');
      expect(const TimeIncrement(90, 5).display, '1.5+5');
      expect(const TimeIncrement(600, 5).display, '10+5');
    });

    test('Estimated Duration', () {
      expect(const TimeIncrement(300, 5).estimatedDuration, const Duration(seconds: 300 + 5 * 40));
      expect(const TimeIncrement(0, 0).estimatedDuration, Duration.zero);
    });

    test('Equality and HashCode', () {
      const timeIncrement1 = TimeIncrement(300, 5);
      const timeIncrement2 = TimeIncrement(300, 5);
      const timeIncrement3 = TimeIncrement(600, 10);

      expect(timeIncrement1, timeIncrement2);
      expect(timeIncrement1.hashCode, timeIncrement2.hashCode);
      expect(timeIncrement1, isNot(timeIncrement3));
    });

    test('Equality and HashCode account for delay', () {
      const noDelay = TimeIncrement(300, 5);
      const withDelay = TimeIncrement(300, 5, delay: 3);
      const sameDelay = TimeIncrement(300, 5, delay: 3);

      expect(noDelay.delay, 0);
      expect(withDelay, isNot(noDelay));
      expect(withDelay, sameDelay);
      expect(withDelay.hashCode, sameDelay.hashCode);
    });

    test('toString includes delay only when non-zero', () {
      expect(const TimeIncrement(300, 5).toString(), 'TimeIncrement(300+5)');
      expect(const TimeIncrement(300, 5, delay: 3).toString(), 'TimeIncrement(300+5 d3)');
    });

    test('clockLabelInMinutes Function', () {
      expect(clockLabelInMinutes(0), '0');
      expect(clockLabelInMinutes(45), '¾');
      expect(clockLabelInMinutes(30), '½');
      expect(clockLabelInMinutes(15), '¼');
      expect(clockLabelInMinutes(60), '1');
      expect(clockLabelInMinutes(90), '1.5');
      expect(clockLabelInMinutes(600), '10');
    });
  });
}
