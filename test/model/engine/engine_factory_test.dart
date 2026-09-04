import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';

import 'fake_engine.dart';

/// A minimal search, for checking which engine answers it.
SearchRequest makeRequest() => const SearchRequest(
  initialPosition: Chess.initial,
  moves: IListConst([]),
  variant: Variant.standard,
  limit: SearchLimit.movetime(Duration(seconds: 1)),
  game: 'test',
);

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

    test('an engine that arrives after its create gave up is disposed', () {
      // The engine starts, but not before the create waiting for it has timed out.
      final engine = FakeEngine(startDelay: kEngineCreateTimeout + const Duration(seconds: 5));
      final factory = factoryFor(engine);

      fakeAsync((async) {
        Object? error;
        factory
            .create(const StockfishSpec.sf16())
            .then<void>((_) {}, onError: (Object e) => error = e);

        async.elapse(kEngineCreateTimeout + const Duration(seconds: 1));
        expect(error, isA<EngineCreationException>());

        // A future cannot be cancelled, so the create runs on and the engine still arrives. It
        // has no owner and nobody will ever quit it, so it must be quit here: a native slot an
        // abandoned engine holds is not free again until the app restarts.
        async.elapse(const Duration(seconds: 10));

        expect(engine.startCount, 1);
        expect(engine.quitCount, 1);
        expect(engine.isRunning, isFalse);
      });
    });

    test('a second create on one slot never runs beside the first', () async {
      final engine = FakeEngine(startDelay: const Duration(milliseconds: 50));
      final factory = factoryFor(engine);

      final firstRequest = factory.create(const StockfishSpec.sf16());

      // Listened to straight away: this one is expected to fail, and an error nobody is waiting
      // for yet would surface as an unhandled async error instead.
      Object? secondError;
      final secondRequest = factory
          .create(const StockfishSpec.sf16())
          .then<Engine?>(
            (engine) => engine,
            onError: (Object e) {
              secondError = e;
              return null;
            },
          );

      final first = await firstRequest;
      addTearDown(first.dispose);

      expect(await secondRequest, isNull, reason: 'one slot cannot host two engines');
      expect(secondError, isA<EngineCreationException>());

      // The native library hosts one engine per slot, so it must never be asked to start a second
      // one while the first is still starting.
      expect(engine.startCount, 1);
      expect(engine.maxConcurrentOps, 1);
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

    test('an LC0 engine and a Stockfish engine are live at once, each with its '
        'own output', () async {
      // The point of giving both plugins private I/O. Before it, whichever
      // engine booted second took the process's fd 0 and fd 1 with it, and the
      // first one's output arrived on the second one's channel.
      // An engine that answers nothing by itself, so that every line below is
      // put on a session on purpose.
      final engine = ThrottleTestEngine();
      final factory = factoryFor(engine);

      final stockfish = await factory.create(const StockfishSpec.sf16());
      addTearDown(stockfish.dispose);
      final lc0 = await factory.create(const Lc0Spec());
      addTearDown(lc0.dispose);
      await pumpEventQueue();

      expect(engine.sessions, hasLength(2));
      expect(engine.quitCount, 0, reason: 'neither is quit to make room');

      // Each engine read its own handshake, from its own session.
      expect(stockfish.name.value, 'Stockfish 16');
      expect(lc0.name.value, 'Lc0 v0.32.1');

      // And each search is answered by the engine it was given to.
      final stockfishSearch = stockfish.search(makeRequest());
      final lc0Search = lc0.search(makeRequest());
      await pumpEventQueue();
      engine.sessions[0].emit('readyok');
      engine.sessions[1].emit('readyok');
      await pumpEventQueue();

      engine.sessions[0].emit('bestmove e2e4');
      engine.sessions[1].emit('bestmove d2d4');

      expect(await stockfishSearch.bestMove, 'e2e4');
      expect(await lc0Search.bestMove, 'd2d4');
    });
  });
}
