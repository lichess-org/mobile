import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

void main() {
  group('TimeIncrement Tests', () {
    test('Initialization', () {
      const timeIncrement = TimeIncrement(300, 5);
      expect(timeIncrement.time, 300);
      expect(timeIncrement.increment, 5);
    });

    test('JSON Serialization', () {
      final json = const TimeIncrement(300, 5).toJson();
      expect(json['time'], 300);
      expect(json['increment'], 5);

      final newTimeIncrement = TimeIncrement.fromJson(json);
      expect(newTimeIncrement.time, 300);
      expect(newTimeIncrement.increment, 5);
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
