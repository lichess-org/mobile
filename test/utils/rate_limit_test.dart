import 'package:flutter_test/flutter_test.dart';

import 'package:lichess_mobile/src/utils/rate_limit.dart';

void main() {
  group('debounce', () {
    test('should call the callback after the delay', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 100));
      var called = false;
      debouncer(() {
        called = true;
      });
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(called, false);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(called, true);
    });

    test('should not execute callback more than once if called multiple times', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 100));
      var called = 0;
      debouncer(() {
        called++;
      });
      debouncer(() {
        called++;
      });
      debouncer(() {
        called++;
      });
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, 1);
    });

    test('should cancel the previous callback', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 100));
      var called = false;
      debouncer(() {
        called = true;
      });
      debouncer(() {
        called = false;
      });
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, false);
    });

    test('cancel should cancel the callback', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 100));
      var called = false;
      debouncer(() {
        called = true;
      });
      await Future<void>.delayed(const Duration(milliseconds: 20));
      debouncer.cancel();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, false);
    });
  });

  group('throttle', () {
    test('should call the callback immediately', () {
      final throttler = Throttler(const Duration(milliseconds: 100));
      var called = false;
      throttler(() {
        called = true;
      });
      expect(called, true);
    });

    test('should call the callback only once within delay', () async {
      final throttler = Throttler(const Duration(milliseconds: 100));
      var called = 0;
      throttler(() {
        called++;
      });
      throttler(() {
        called++;
      });
      throttler(() {
        called++;
      });
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, 1);
    });

    test('should call the callback multiple times if delay is passed', () async {
      final throttler = Throttler(const Duration(milliseconds: 100));
      var called = 0;
      throttler(() {
        called++;
      });
      throttler(() {
        called++;
      });
      await Future<void>.delayed(const Duration(milliseconds: 150));
      throttler(() {
        called++;
      });
      await Future<void>.delayed(const Duration(milliseconds: 150));
      throttler(() {
        called++;
      });
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, 3);
    });
  });
}
