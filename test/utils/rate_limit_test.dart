import 'dart:math' as math;

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

  group('SerialTaskQueue', () {
    test('runs one task at a time', () async {
      final queue = SerialTaskQueue();
      var running = 0;
      var maxRunning = 0;

      Future<void> task() => queue.run(() async {
        running++;
        maxRunning = math.max(maxRunning, running);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        running--;
      });

      await Future.wait([for (var i = 0; i < 5; i++) task()]);

      expect(maxRunning, equals(1));
    });

    test('runs tasks in submission order', () async {
      final queue = SerialTaskQueue();
      final order = <int>[];

      await Future.wait([
        for (var i = 0; i < 5; i++)
          queue.run(() async {
            // a later task finishing faster must not let it start earlier
            await Future<void>.delayed(Duration(milliseconds: 10 - i));
            order.add(i);
          }),
      ]);

      expect(order, equals([0, 1, 2, 3, 4]));
    });

    test('returns each task its own result', () async {
      final queue = SerialTaskQueue();

      final results = await Future.wait([
        queue.run(() async => 'a'),
        queue.run(() async => 'b'),
        queue.run(() async => 'c'),
      ]);

      expect(results, equals(['a', 'b', 'c']));
    });

    test('a failing task neither breaks the queue nor swallows its error', () async {
      final queue = SerialTaskQueue();

      final failing = queue.run(() async => throw const FormatException('boom'));
      final next = queue.run(() async => 'ran anyway');

      await expectLater(failing, throwsA(isA<FormatException>()));
      expect(await next, equals('ran anyway'));
    });

    test('does not delay tasks on its own', () async {
      final queue = SerialTaskQueue();

      // The queue only removes concurrency: it must add no delay of its own, and leave no pending
      // timer behind, or every widget test ending on a queued request would fail to settle.
      await Future.wait([
        for (var i = 0; i < 3; i++) queue.run(() async {}),
      ]).timeout(const Duration(seconds: 1));
    });
  });
}
