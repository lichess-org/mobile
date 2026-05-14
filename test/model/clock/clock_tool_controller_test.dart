import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

import '../common/service/fake_sound_service.dart';

void main() {
  ProviderContainer makeClockContainer() {
    final container = ProviderContainer(
      overrides: [soundServiceProvider.overrideWithValue(FakeSoundService())],
    );
    final subscription = container.listen(clockToolControllerProvider, (_, _) {});
    addTearDown(subscription.close);
    addTearDown(container.dispose);
    return container;
  }

  test('simple delay does not subtract main time during delay', () {
    fakeAsync((async) {
      final container = makeClockContainer();
      final controller = container.read(clockToolControllerProvider.notifier);

      controller
        ..updateOptions(const TimeIncrement(5, 2))
        ..updateClockType(ClockTimeControlType.simpleDelay)
        ..start(ClockSide.top);

      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(seconds: 5),
      );

      async.elapse(const Duration(seconds: 2));
      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(seconds: 5),
      );

      async.elapse(const Duration(milliseconds: 100));
      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(milliseconds: 4900),
      );
    });
  });

  test('simple delay applies again after each move', () {
    fakeAsync((async) {
      final container = makeClockContainer();
      final controller = container.read(clockToolControllerProvider.notifier);

      controller
        ..updateOptions(const TimeIncrement(5, 2))
        ..updateClockType(ClockTimeControlType.simpleDelay)
        ..start(ClockSide.top);

      async.elapse(const Duration(seconds: 3));
      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(seconds: 4),
      );

      controller.onTap(ClockSide.bottom);
      async.elapse(const Duration(seconds: 2));
      expect(container.read(clockToolControllerProvider).topTime.value, const Duration(seconds: 5));

      async.elapse(const Duration(milliseconds: 100));
      expect(
        container.read(clockToolControllerProvider).topTime.value,
        const Duration(milliseconds: 4900),
      );
    });
  });

  test('simple delay preserves remaining delay across pause and resume', () {
    fakeAsync((async) {
      final container = makeClockContainer();
      final controller = container.read(clockToolControllerProvider.notifier);

      controller
        ..updateOptions(const TimeIncrement(5, 2))
        ..updateClockType(ClockTimeControlType.simpleDelay)
        ..start(ClockSide.top);

      async.elapse(const Duration(seconds: 1));
      controller.pause();
      async.elapse(const Duration(seconds: 5));
      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(seconds: 5),
      );

      controller.resume();
      async.elapse(const Duration(seconds: 1));
      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(seconds: 5),
      );

      async.elapse(const Duration(milliseconds: 100));
      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(milliseconds: 4900),
      );
    });
  });

  test('bronstein delay restores only the time spent up to the delay', () {
    fakeAsync((async) {
      final container = makeClockContainer();
      final controller = container.read(clockToolControllerProvider.notifier);

      controller
        ..updateOptions(const TimeIncrement(5, 2))
        ..updateClockType(ClockTimeControlType.bronsteinDelay)
        ..start(ClockSide.top);

      async.elapse(const Duration(seconds: 1));
      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(seconds: 4),
      );

      controller.onTap(ClockSide.bottom);
      expect(
        container.read(clockToolControllerProvider).bottomTime.value,
        const Duration(seconds: 5),
      );

      async.elapse(const Duration(seconds: 3));
      expect(container.read(clockToolControllerProvider).topTime.value, const Duration(seconds: 2));

      controller.onTap(ClockSide.top);
      expect(container.read(clockToolControllerProvider).topTime.value, const Duration(seconds: 4));
    });
  });

  test('bronstein delay does not increase time on repeated fast moves', () {
    fakeAsync((async) {
      final container = makeClockContainer();
      final controller = container.read(clockToolControllerProvider.notifier);

      controller
        ..updateOptions(const TimeIncrement(180, 2))
        ..updateClockType(ClockTimeControlType.bronsteinDelay)
        ..start(ClockSide.top);

      final initialTopTime = container.read(clockToolControllerProvider).topTime.value;
      final initialBottomTime = container.read(clockToolControllerProvider).bottomTime.value;

      for (int i = 0; i < 20; i++) {
        async.elapse(const Duration(milliseconds: 50));
        controller.onTap(container.read(clockToolControllerProvider).activeSide!);
      }

      expect(container.read(clockToolControllerProvider).topTime.value <= initialTopTime, true);
      expect(
        container.read(clockToolControllerProvider).bottomTime.value <= initialBottomTime,
        true,
      );
    });
  });
}
