import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';

import '../../binding.dart';
import 'fake_stockfish.dart';

void main() {
  setUp(TestLichessBinding.ensureInitialized);

  group('EngineFactory', () {
    test('starts an engine that answers its handshake', () async {
      testBinding.stockfish = FakeStockfish();
      final factory = EngineFactory();

      final engine = await factory.create(const StockfishSpec.sf16());
      addTearDown(engine.dispose);
      await pumpEventQueue();

      expect(engine.spec, const StockfishSpec.sf16());
      expect(engine.name.value, 'Stockfish 16');
    });

    test('a create waits for the engine it replaces to finish exiting', () async {
      final stockfish = DelayedFakeStockfish(quitDelay: const Duration(milliseconds: 50));
      testBinding.stockfish = stockfish;
      final factory = EngineFactory();

      final first = await factory.create(const StockfishSpec.sf16());

      // Let go of it without waiting: this is what a provider being disposed looks like.
      unawaited(first.dispose());

      final second = await factory.create(const StockfishSpec.sf16());
      addTearDown(second.dispose);

      // The native library only frees the slot once the engine has actually exited, so the second
      // create must not have started before the first quit finished.
      expect(stockfish.quitCallCount, 1);
      expect(stockfish.startCallCount, 2);
      expect(first.isDisposed, isTrue);
    });

    test('two live engines on one slot are a programming error, not a restart', () async {
      testBinding.stockfish = FakeStockfish();
      final factory = EngineFactory();

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
      testBinding.stockfish = ThrowingStartStockfish();
      final factory = EngineFactory();

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
      testBinding.stockfish = StuckStockfish();
      final factory = EngineFactory();

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
  });
}
