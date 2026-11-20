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

    test('drops a call made within the delay when not trailing', () async {
      final throttler = Throttler(const Duration(milliseconds: 100));
      var called = 0;
      throttler(() => called++);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      throttler(() => called++);
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, 1);
    });

    test('runs a trailing call once the delay expires', () async {
      final throttler = Throttler(const Duration(milliseconds: 100), trailing: true);
      var called = 0;
      throttler(() => called++);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      throttler(() => called++);
      expect(called, 1, reason: 'the second call waits for the delay to expire');
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, 2);
    });

    test('coalesces the calls made within the delay into a single trailing run', () async {
      final throttler = Throttler(const Duration(milliseconds: 100), trailing: true);
      final calls = <String>[];
      throttler(() => calls.add('first'));
      throttler(() => calls.add('second'));
      throttler(() => calls.add('third'));
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(calls, ['first', 'third'], reason: 'the last action of the window wins');
    });

    test('a trailing run opens a new delay of its own', () async {
      final throttler = Throttler(const Duration(milliseconds: 100), trailing: true);
      var called = 0;
      throttler(() => called++);
      throttler(() => called++);
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, 2);
      throttler(() => called++);
      expect(called, 2, reason: 'the trailing run throttles what follows it');
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(called, 3);
    });

    test('cancel drops a pending trailing call', () async {
      final throttler = Throttler(const Duration(milliseconds: 100), trailing: true);
      var called = 0;
      throttler(() => called++);
      throttler(() => called++);
      throttler.cancel();
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
