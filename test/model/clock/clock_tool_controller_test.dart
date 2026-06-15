import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

import '../../test_container.dart';

void main() {
  group('ClockToolController options', () {
    test('updateOptions applies delay to both sides', () async {
      final container = await makeContainer();
      // Keep the autoDispose provider alive for the duration of the test.
      container.listen(clockToolControllerProvider, (_, _) {});
      final controller = container.read(clockToolControllerProvider.notifier);

      controller.updateOptions(const TimeIncrement(60, 0, delay: 3));

      final options = container.read(clockToolControllerProvider).options;
      expect(options.topDelay, const Duration(seconds: 3));
      expect(options.bottomDelay, const Duration(seconds: 3));
      expect(options.hasDelay(ClockSide.top), true);
      expect(options.hasDelay(ClockSide.bottom), true);
      expect(options.getDelay(ClockSide.top), const Duration(seconds: 3));
    });

    test('updateOptions with no delay reports no delay', () async {
      final container = await makeContainer();
      container.listen(clockToolControllerProvider, (_, _) {});
      final controller = container.read(clockToolControllerProvider.notifier);

      controller.updateOptions(const TimeIncrement(60, 0));

      final options = container.read(clockToolControllerProvider).options;
      expect(options.topDelay, Duration.zero);
      expect(options.bottomDelay, Duration.zero);
      expect(options.hasDelay(ClockSide.top), false);
    });

    test('updateOptionsCustom sets delay for only the given side', () async {
      final container = await makeContainer();
      container.listen(clockToolControllerProvider, (_, _) {});
      final controller = container.read(clockToolControllerProvider.notifier);

      controller.updateOptionsCustom(const TimeIncrement(60, 0, delay: 5), ClockSide.top);

      final options = container.read(clockToolControllerProvider).options;
      expect(options.topDelay, const Duration(seconds: 5));
      expect(options.bottomDelay, Duration.zero);
    });
  });

  group('ClockToolController delay behavior', () {
    test('start defers the countdown by the configured delay', () async {
      final container = await makeContainer();
      fakeAsync((async) {
        // Build the controller (and its ChessClock) inside the fake zone, and
        // keep it alive so autoDispose doesn't cancel the clock on microtask flush.
        container.listen(clockToolControllerProvider, (_, _) {});
        final controller = container.read(clockToolControllerProvider.notifier);
        controller.updateOptions(const TimeIncrement(60, 0, delay: 3));

        // start(top) makes the bottom side active and starts its clock.
        controller.start(ClockSide.top);

        final state = container.read(clockToolControllerProvider);
        // Within the 3s delay window the active clock must not tick down.
        async.elapse(const Duration(seconds: 2));
        expect(state.bottomTime.value, const Duration(seconds: 60));

        // After the delay elapses the clock starts counting: at 4s total,
        // ~1s has been consumed past the 3s delay.
        async.elapse(const Duration(seconds: 2));
        expect(state.bottomTime.value, const Duration(seconds: 59));

        controller.pause();
      });
    });

    test('without delay the countdown starts immediately', () async {
      final container = await makeContainer();
      fakeAsync((async) {
        container.listen(clockToolControllerProvider, (_, _) {});
        final controller = container.read(clockToolControllerProvider.notifier);
        controller.updateOptions(const TimeIncrement(60, 0));

        controller.start(ClockSide.top);

        final state = container.read(clockToolControllerProvider);
        async.elapse(const Duration(seconds: 2));
        expect(state.bottomTime.value, const Duration(seconds: 58));

        controller.pause();
      });
    });

    test('resume after the delay has elapsed does not re-grant it', () async {
      final container = await makeContainer();
      fakeAsync((async) {
        container.listen(clockToolControllerProvider, (_, _) {});
        final controller = container.read(clockToolControllerProvider.notifier);
        controller.updateOptions(const TimeIncrement(60, 0, delay: 3));

        // Start and let the delay fully elapse so the main clock is ticking.
        controller.start(ClockSide.top);
        async.elapse(const Duration(seconds: 4));
        final state = container.read(clockToolControllerProvider);
        expect(state.bottomTime.value, const Duration(seconds: 59));

        // Pause then resume: no fresh delay should be granted, and the main
        // clock should keep counting immediately.
        controller.pause();
        controller.resume();

        async.elapse(const Duration(seconds: 1));
        expect(state.bottomTime.value, const Duration(seconds: 58));

        controller.pause();
      });
    });

    test('pausing mid-delay preserves and resumes the remaining delay', () async {
      final container = await makeContainer();
      fakeAsync((async) {
        container.listen(clockToolControllerProvider, (_, _) {});
        final controller = container.read(clockToolControllerProvider.notifier);
        controller.updateOptions(const TimeIncrement(60, 0, delay: 3));

        controller.start(ClockSide.top); // bottom becomes active, 3s delay
        final state = container.read(clockToolControllerProvider);

        // 1s into the delay (~2s remain), main clock untouched.
        async.elapse(const Duration(seconds: 1));
        expect(state.bottomTime.value, const Duration(seconds: 60));

        // While paused, elapsing wall time does not move the main clock.
        controller.pause();
        async.elapse(const Duration(seconds: 5));
        expect(state.bottomTime.value, const Duration(seconds: 60));

        controller.resume();
        // The remaining ~2s of delay must still pass before the main clock moves.
        async.elapse(const Duration(seconds: 1));
        expect(state.bottomTime.value, const Duration(seconds: 60));

        // After the remaining delay elapses, the main clock finally ticks.
        async.elapse(const Duration(seconds: 2));
        expect(state.bottomTime.value, lessThan(const Duration(seconds: 60)));

        controller.pause();
      });
    });

    test('reset during a delay stops the clock', () async {
      final container = await makeContainer();
      fakeAsync((async) {
        container.listen(clockToolControllerProvider, (_, _) {});
        final controller = container.read(clockToolControllerProvider.notifier);
        controller.updateOptions(const TimeIncrement(60, 0, delay: 3));

        controller.start(ClockSide.top);
        async.elapse(const Duration(seconds: 1));

        controller.reset();
        final resetState = container.read(clockToolControllerProvider);
        expect(resetState.activeSide, isNull);

        // The clock is stopped and back to full time.
        async.elapse(const Duration(seconds: 2));
        expect(resetState.bottomTime.value, const Duration(seconds: 60));
      });
    });

    test('each side gets its own delay (asymmetric)', () async {
      final container = await makeContainer();
      fakeAsync((async) {
        container.listen(clockToolControllerProvider, (_, _) {});
        final controller = container.read(clockToolControllerProvider.notifier);
        // Top has a 3s delay, bottom has none.
        controller.updateOptionsCustom(const TimeIncrement(60, 0, delay: 3), ClockSide.top);
        controller.updateOptionsCustom(const TimeIncrement(60, 0), ClockSide.bottom);

        // start(top) makes the bottom side active: no delay, so it ticks at once.
        controller.start(ClockSide.top);
        final state = container.read(clockToolControllerProvider);
        async.elapse(const Duration(seconds: 1));
        expect(state.bottomTime.value, const Duration(seconds: 59));

        // Tapping bottom hands over to top, which has a 3s delay: top is frozen.
        controller.onTap(ClockSide.bottom);
        async.elapse(const Duration(seconds: 2));
        expect(state.topTime.value, const Duration(seconds: 60));

        // After top's delay elapses it starts ticking.
        async.elapse(const Duration(seconds: 2));
        expect(state.topTime.value, lessThan(const Duration(seconds: 60)));

        controller.pause();
      });
    });

    test('onTap applies the delay to the newly active side', () async {
      final container = await makeContainer();
      fakeAsync((async) {
        container.listen(clockToolControllerProvider, (_, _) {});
        final controller = container.read(clockToolControllerProvider.notifier);
        controller.updateOptions(const TimeIncrement(60, 0, delay: 3));

        // Tapping the bottom player passes the turn: the top side becomes active.
        controller.onTap(ClockSide.bottom);

        final state = container.read(clockToolControllerProvider);
        async.elapse(const Duration(seconds: 2));
        expect(state.topTime.value, const Duration(seconds: 60));

        async.elapse(const Duration(seconds: 2));
        expect(state.topTime.value, const Duration(seconds: 59));

        controller.pause();
      });
    });
  });
}
