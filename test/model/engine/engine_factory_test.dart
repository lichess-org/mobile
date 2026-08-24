import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';

import 'fake_engine.dart';

/// A factory that starts [engine] instead of a real one.
EngineFactory factoryFor(FakeEngine engine) => EngineFactory(connect: engine.connect);

void main() {
  group('EngineFactory', () {
    test('starts an engine that answers its handshake', () async {
      final engine = FakeEngine();
      final factory = factoryFor(engine);

      final started = await factory.create(const StockfishSpec.sf16());
      addTearDown(started.dispose);
      await pumpEventQueue();

      expect(started.spec, const StockfishSpec.sf16());
      expect(started.name.value, 'Stockfish 16');
    });

    test('a create waits for the engine it replaces to finish exiting', () async {
      final engine = FakeEngine(quitDelay: const Duration(milliseconds: 50));
      final factory = factoryFor(engine);

      final first = await factory.create(const StockfishSpec.sf16());

      // Let go of it without waiting: this is what a provider being disposed looks like.
      unawaited(first.dispose());

      final second = await factory.create(const StockfishSpec.sf16());
      addTearDown(second.dispose);

      // The native library only frees the slot once the engine has actually exited, so the second
      // create must not have started before the first quit finished.
      expect(engine.quitCount, 1);
      expect(engine.startCount, 2);
      expect(engine.maxConcurrentOps, 1);
      expect(first.isDisposed, isTrue);
    });

    test('two live engines on one slot are a programming error, not a restart', () async {
      final factory = factoryFor(FakeEngine());

      final live = await factory.create(const StockfishSpec.sf16());
      addTearDown(live.dispose);

      await expectLater(
        factory.create(const StockfishSpec.sf16()),
        throwsA(
          isA<EngineCreationException>().having(
            (e) => e.failure.error,
            'error',
            isA<AssertionError>(),
          ),
        ),
      );
    });

    test('an engine the plugin refuses to start is reported as a start failure', () async {
      final factory = factoryFor(ThrowingStartEngine());

      await expectLater(
        factory.create(const StockfishSpec.sf16()),
        throwsA(
          isA<EngineCreationException>().having(
            (e) => e.failure.kind,
            'kind',
            EngineFailureKind.start,
          ),
        ),
      );
    });

    test('an engine that reports a failure instead of readiness is a start failure', () async {
      final factory = factoryFor(ErrorEngine());

      await expectLater(
        factory.create(const StockfishSpec.sf16()),
        throwsA(
          isA<EngineCreationException>().having(
            (e) => e.failure.kind,
            'kind',
            EngineFailureKind.start,
          ),
        ),
      );
    });

    test('a create that never returns is reported as stuck', () {
      final factory = factoryFor(StuckEngine());

      fakeAsync((async) {
        Object? error;
        factory
            .create(const StockfishSpec.sf16())
            .then<void>((_) {}, onError: (Object e) => error = e);

        async.elapse(kEngineCreateTimeout - const Duration(seconds: 1));
        expect(error, isNull, reason: 'the engine is still starting, and may yet succeed');

        async.elapse(const Duration(seconds: 2));

        expect(error, isA<EngineCreationException>());
        expect((error! as EngineCreationException).failure.kind, EngineFailureKind.stuck);
        expect((error! as EngineCreationException).failure.isUnrecoverable, isTrue);
      });
    });

    test('engines for different slots are independent', () async {
      // Two flavours, two native libraries: nothing has to be quit to make room.
      final engine = FakeEngine();
      final factory = factoryFor(engine);

      final sf16 = await factory.create(const StockfishSpec.sf16());
      addTearDown(sf16.dispose);
      final fairy = await factory.create(const StockfishSpec.fairy());
      addTearDown(fairy.dispose);

      expect(engine.quitCount, 0);
      expect(sf16.spec, isNot(fairy.spec));
    });
  });
}
