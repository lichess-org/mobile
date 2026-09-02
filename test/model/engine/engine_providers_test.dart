import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_providers.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';

import '../../test_container.dart';
import 'fake_engine.dart';

void main() {
  group('engineProvider', () {
    test('disposes an engine whose last watcher left while it was still starting', () async {
      // Long enough that the subscription can be closed while the engine is still starting, which
      // is the whole scenario: leaving the analysis screen before the engine has answered.
      fakeEngine = FakeEngine(startDelay: const Duration(milliseconds: 50));
      final container = await makeContainer();
      addTearDown(container.dispose);

      final subscription = container.listen<AsyncValue<Engine>>(
        engineProvider(const StockfishSpec.sf16()),
        (_, _) {},
      );

      // Nobody is waiting any more, and the engine has not started yet.
      subscription.close();
      expect(fakeEngine.isRunning, isFalse);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      await pumpEventQueue();

      // The engine did start — the create was already in flight and nothing cancels it — so it
      // must have been quit. An engine left running here holds its native slot for the rest of the
      // process's life, and every later engine of that flavour is refused.
      expect(fakeEngine.startCount, 1);
      expect(fakeEngine.quitCount, 1);
      expect(fakeEngine.isRunning, isFalse);
    });

    test('keeps the engine alive for the dispose window, then disposes it', () async {
      fakeEngine = FakeEngine();
      final container = await makeContainer();
      addTearDown(container.dispose);

      final subscription = container.listen<AsyncValue<Engine>>(
        engineProvider(const StockfishSpec.sf16()),
        (_, _) {},
      );
      await container.read(engineProvider(const StockfishSpec.sf16()).future);
      subscription.close();

      await pumpEventQueue();
      expect(fakeEngine.isRunning, isTrue, reason: 'the dispose window has not passed yet');

      await Future<void>.delayed(kEngineDisposeDelay + const Duration(milliseconds: 50));
      await pumpEventQueue();
      expect(fakeEngine.quitCount, 1);
      expect(fakeEngine.isRunning, isFalse);
    });

    test('the dispose window is idle time, not a lifetime', () async {
      fakeEngine = FakeEngine();
      final container = await makeContainer();
      addTearDown(container.dispose);

      final subscription = container.listen<AsyncValue<Engine>>(
        engineProvider(const StockfishSpec.sf16()),
        (_, _) {},
      );
      await container.read(engineProvider(const StockfishSpec.sf16()).future);

      // Watched for longer than the window: a timer started when the engine was built would have
      // fired by now, and the engine would be quit the moment its last watcher went away.
      await Future<void>.delayed(kEngineDisposeDelay + const Duration(milliseconds: 50));
      subscription.close();
      await pumpEventQueue();
      expect(
        fakeEngine.isRunning,
        isTrue,
        reason: 'the window starts when the last watcher leaves',
      );

      await Future<void>.delayed(kEngineDisposeDelay + const Duration(milliseconds: 50));
      await pumpEventQueue();
      expect(fakeEngine.quitCount, 1);
      expect(fakeEngine.isRunning, isFalse);
    });

    test('an engine on another slot starts without waiting for an unwatched one to exit', () async {
      fakeEngine = FakeEngine();
      final container = await makeContainer();
      addTearDown(container.dispose);

      final subscription = container.listen<AsyncValue<Engine>>(
        engineProvider(const StockfishSpec.sf16()),
        (_, _) {},
      );
      await container.read(engineProvider(const StockfishSpec.sf16()).future);
      subscription.close();
      await pumpEventQueue();
      expect(fakeEngine.isRunning, isTrue, reason: 'still inside its dispose window');

      final other = container.listen<AsyncValue<Engine>>(
        engineProvider(const StockfishSpec.fairy()),
        (_, _) {},
      );
      addTearDown(other.close);
      await container.read(engineProvider(const StockfishSpec.fairy()).future);

      // The budget sizes a table for each of `kMaxResidentEngines`, so an engine waiting out its
      // window is left to it: it is one table more than that for as long as the window lasts, and
      // nothing about the new engine waits on it.
      expect(fakeEngine.quitCount, 0);
      expect(fakeEngine.sessions.length, 2);

      // It still goes when its own window ends.
      await Future<void>.delayed(kEngineDisposeDelay + const Duration(milliseconds: 50));
      await pumpEventQueue();
      expect(fakeEngine.quitCount, 1);
      expect(fakeEngine.sessions.single.spec, const StockfishSpec.fairy());
    });
  });
}
