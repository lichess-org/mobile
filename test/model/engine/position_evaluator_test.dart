import 'package:dartchess/dartchess.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/engine_providers.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';

import '../../binding.dart';
import '../../test_container.dart';
import 'fake_engine.dart';
import 'fake_stockfish_nnue_service.dart';

/// The engine's lifecycle, as these tests read it off [EngineEvaluationState].
///
/// The evaluator keeps no state machine of its own: the engine is an [AsyncValue], and whether it
/// is searching is a flag beside it. This is the mapping the views apply, named so that the
/// assertions below stay about behaviour rather than about record fields.
///
/// Deliberately not called `EngineState`: that name belongs to the plugin's own reading of a
/// native engine (`EngineFailure.engineState`), which is a different thing entirely. This is a
/// test's way of reading two fields as one word, and exists nowhere in the app.
enum EngineLifecycle { initial, loading, idle, computing, error }

extension EngineEvaluationStateTest on EngineEvaluationState {
  /// The engine's `id name`, once it has one.
  String? get engineName => engine?.value;

  EngineLifecycle get lifecycle => switch (engine) {
    null => EngineLifecycle.initial,
    AsyncError() => EngineLifecycle.error,
    AsyncValue(isLoading: true) => EngineLifecycle.loading,
    _ => isComputing ? EngineLifecycle.computing : EngineLifecycle.idle,
  };
}

EvaluationContext makeContext({
  StringId? id,
  Variant variant = Variant.standard,
  Position? initialPosition,
}) => EvaluationContext(
  id: id ?? const StringId('test'),
  variant: variant,
  initialPosition: initialPosition ?? Chess.initial,
);

/// Chooses the engine the evaluator will use for the official chess variants.
Future<void> setEnginePref(ProviderContainer container, ChessEnginePref pref) =>
    container.read(engineEvaluationPreferencesProvider.notifier).setEvaluationFunction(pref);

/// The evaluator for [context], or for the context [makeWork] builds work in by default.
///
/// Listened to as well as read, because the evaluator is autoDispose: a bare `read` would hand
/// back one that is disposed again before the test can use it.
PositionEvaluator readEvaluator(ProviderContainer container, [EvaluationContext? context]) {
  final provider = positionEvaluatorProvider(context ?? makeContext());
  _screens[context ?? makeContext()] = container.listen(provider, (_, _) {});
  return container.read(provider.notifier);
}

final _screens = <EvaluationContext, ProviderSubscription<EngineEvaluationState>>{};

/// Leaves the screen the evaluator belongs to.
///
/// The evaluator is autoDispose, so closing the last subscription disposes it — which is what lets
/// go of the engine. Turning the engine off with `release` no longer does: it keeps the engine for
/// as long as the screen is open.
void leaveEvaluatorScreen(ProviderContainer container, [EvaluationContext? context]) {
  _screens.remove(context ?? makeContext())?.close();
}

EvalWork makeWork({
  StringId? id,
  UciPath? path,
  Variant variant = Variant.standard,
  Duration searchTime = const Duration(seconds: 1),
  Position? initialPosition,
}) {
  return EvalWork(
    id: id ?? const StringId('test'),
    variant: variant,
    threads: 1,
    path: path ?? UciPath.empty,
    searchTime: searchTime,
    multiPv: 1,
    initialPosition: initialPosition ?? Chess.initial,
    steps: const IListConst<Step>([]),
    threatMode: false,
  );
}

void main() {
  TestLichessBinding.ensureInitialized();

  setUp(() {
    fakeEngine = FakeEngine();
  });

  group('PositionEvaluator state transitions', () {
    test('initial state is EngineLifecycle.initial', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      expect(service.state.lifecycle, EngineLifecycle.initial);
      expect(service.state.currentWork, isNull);
      expect(service.state.eval, isNull);
    });

    test('evaluate() transitions state from initial to loading to idle', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      // Track state transitions (filter out consecutive duplicates)
      final states = <EngineLifecycle>[];
      container.listen(positionEvaluatorProvider(makeContext()), (_, _) {
        final newState = service.state.lifecycle;
        if (states.isEmpty || states.last != newState) {
          states.add(newState);
        }
      });

      final work = makeWork();
      final stream = service.evaluate(work);
      expect(stream, isNotNull);

      await stream!.first;

      expect(states, contains(EngineLifecycle.loading));
      expect(states.last, anyOf(EngineLifecycle.idle, EngineLifecycle.computing));
    });

    test('quit() resets evaluationState to initial state immediately', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = makeWork();
      final stream = service.evaluate(work);
      await stream!.first;

      // Verify we have non-initial state before quit
      expect(service.state.lifecycle, isNot(EngineLifecycle.initial));
      expect(service.state.currentWork, isNotNull);
      expect(service.state.eval, isNotNull);
      expect(service.state.engineName, isNotNull);

      service.release();

      // quit() should immediately reset all fields to initial state
      expect(service.state.lifecycle, EngineLifecycle.initial);
      expect(service.state.currentWork, isNull);
      expect(service.state.eval, isNull);
      expect(service.state.engineName, isNull);
    });

    test('state transitions idle -> computing -> idle when work completes', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      // First evaluation to get engine into idle state
      final initWork = makeWork();
      final initStream = service.evaluate(initWork);
      await initStream!.first;

      // Wait for state to settle to idle
      while (service.state.lifecycle != EngineLifecycle.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(service.state.lifecycle, EngineLifecycle.idle);

      // Track state transitions for the next evaluation (filter out consecutive duplicates)
      // Initialize with current state to only capture actual transitions
      var lastState = service.state.lifecycle;
      final states = <EngineLifecycle>[];
      container.listen(positionEvaluatorProvider(makeContext()), (_, _) {
        final newState = service.state.lifecycle;
        if (newState != lastState) {
          states.add(newState);
          lastState = newState;
        }
      });

      // Start new evaluation - should transition to computing
      final work = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));
      final stream = service.evaluate(work);
      expect(stream, isNotNull);

      // Wait for evaluation to complete
      await stream!.first;

      // Wait for state to settle back to idle
      while (service.state.lifecycle != EngineLifecycle.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      expect(states, [EngineLifecycle.computing, EngineLifecycle.idle]);
    });

    test('new work while computing: stream1 receives results before work2, not after', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      // Initialize engine
      final initWork = makeWork();
      final initStream = service.evaluate(initWork);
      await initStream!.first;

      while (service.state.lifecycle != EngineLifecycle.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      // Track stream1 results
      final stream1ResultsBeforeWork2 = <EvalWork>[];
      final stream1ResultsAfterWork2 = <EvalWork>[];
      var work2Started = false;

      final work1 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));
      final stream1 = service.evaluate(work1);

      stream1!.listen((result) {
        if (work2Started) {
          stream1ResultsAfterWork2.add(result.$1);
        } else {
          stream1ResultsBeforeWork2.add(result.$1);
        }
      });

      // Wait for stream1 to receive at least one result
      while (stream1ResultsBeforeWork2.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      expect(stream1ResultsBeforeWork2, isNotEmpty);
      expect(stream1ResultsBeforeWork2.first, work1);

      // Start work2 while work1 is still computing
      work2Started = true;
      final work2 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('d2d4')));
      final stream2 = service.evaluate(work2);

      expect(service.state.currentWork, work2);

      // Wait for work2 to complete
      final (resultWork2, _) = await stream2!.first;
      expect(resultWork2, work2);

      while (service.state.lifecycle != EngineLifecycle.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      // stream1 should not receive any results after work2 started
      expect(stream1ResultsAfterWork2, isEmpty);
    });

    test('evaluate() after quit() reuses the engine within the grace window', () async {
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = makeWork();
      final stream1 = service.evaluate(work);
      await stream1!.first;

      expect(delayedStockfish.startCount, 1);

      service.release();
      await pumpEventQueue();

      final stream2 = service.evaluate(work);
      await stream2!.first;

      // Leaving one analysis screen for another is what the grace window exists for: the engine is
      // handed over instead of being quit and started again in between.
      expect(delayedStockfish.startCount, 1);
      expect(delayedStockfish.quitCount, 0);
    });

    test('turning the engine off and on again keeps the same engine', () async {
      final stockfish = FakeEngine();
      fakeEngine = stockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      await service.evaluate(makeWork())!.first;
      expect(stockfish.startCount, 1);

      // The engine button, turned off and left off for longer than the grace window: the engine is
      // the screen's for as long as the screen is open, however often the button is tapped.
      service.release();
      expect(service.state.engineName, isNull, reason: 'nothing to show for an engine that is off');
      await Future<void>.delayed(kEngineDisposeDelay + const Duration(milliseconds: 100));
      expect(stockfish.quitCount, 0, reason: 'still inside the pause window');

      await service.evaluate(makeWork())!.first;
      expect(stockfish.startCount, 1, reason: 'the engine was never let go of');
      expect(stockfish.quitCount, 0);
      expect(service.state.engineName, isNotNull, reason: 'the button shows the engine again');
    });

    test('an engine left turned off is let go of', () async {
      final stockfish = FakeEngine();
      fakeEngine = stockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        service.evaluate(makeWork());
        async.elapse(const Duration(seconds: 1));
        expect(stockfish.startCount, 1);

        service.release();
        async.elapse(kEnginePauseDelay - const Duration(seconds: 1));
        expect(stockfish.quitCount, 0, reason: 'still inside the pause window');

        // The engine the user turned off must not go on holding its table for a screen that is
        // evaluating nothing: past the pause window it is let go of, and the provider's own window
        // quits it.
        async.elapse(const Duration(seconds: 1) + kEngineDisposeDelay + const Duration(seconds: 1));
        expect(stockfish.quitCount, 1);

        // And it is a new engine that a later request starts, not a resurrected one.
        service.evaluate(makeWork());
        async.elapse(const Duration(seconds: 1));
        expect(stockfish.startCount, 2);
      });
    });

    test('an engine nobody comes back for is quit once the grace window passes', () async {
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        service.evaluate(makeWork());
        async.elapse(const Duration(seconds: 1));
        expect(delayedStockfish.startCount, 1);

        leaveEvaluatorScreen(container);
        async.elapse(const Duration(seconds: 1));
        expect(delayedStockfish.quitCount, 0, reason: 'still inside the grace window');

        async.elapse(kEngineDisposeDelay);
        expect(delayedStockfish.quitCount, 1);
      });
    });
  });

  group('PositionEvaluator race conditions', () {
    test('rapid evaluate() calls during init - last caller wins', () async {
      final delayedStockfish = FakeEngine(startDelay: const Duration(milliseconds: 50));
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work1 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));
      final work2 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('d2d4')));
      final work3 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('c2c4')));

      // Collect results from stream1 to verify it doesn't receive work3 results
      final stream1Results = <EvalWork>[];
      final stream1 = service.evaluate(work1);
      stream1!.listen((result) => stream1Results.add(result.$1));

      service.evaluate(work2);
      final stream3 = service.evaluate(work3);

      expect(service.state.currentWork, work3);

      // Wait for evaluation to complete
      final (resultWork, _) = await stream3!.first;

      // Result should be for work3, not work1 or work2
      expect(resultWork, work3);

      // Engine should only be started once despite multiple evaluate() calls
      expect(delayedStockfish.startCount, 1);
      // Nothing is quit: there was no engine to replace, and a start is no longer preceded by a
      // quit of whatever happened to be running.
      expect(delayedStockfish.quitCount, 0);
      // Only work3 ever reaches the engine — the requests made while it was starting were
      // superseded before it was ready — so the single stop is the engine being cut short once it
      // reported past its own movetime (elapsed 1500ms > searchTime 1000ms).
      expect(delayedStockfish.stopCount, 1);

      // stream1 is filtered to work1, so it should not have received any results
      // (the engine only computed work3)
      expect(stream1Results, isEmpty);
    });

    test('evaluate() while init in progress does not start new init', () async {
      final delayedStockfish = FakeEngine(startDelay: const Duration(milliseconds: 100));
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work1 = makeWork();
      final work2 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));

      service.evaluate(work1);
      expect(service.state.lifecycle, EngineLifecycle.loading);

      final stream2 = service.evaluate(work2);
      expect(service.state.currentWork, work2);

      // Wait for init to complete
      await stream2!.first;

      // Still only one start call
      expect(delayedStockfish.startCount, 1);
    });

    test('evaluate() does not restart when stockfish is in starting state', () async {
      final delayedStockfish = FakeEngine(startDelay: const Duration(milliseconds: 100));
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work1 = makeWork();
      service.evaluate(work1);

      // Wait for the engine to be starting.
      while (delayedStockfish.startCount == 0) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      expect(delayedStockfish.isRunning, isFalse, reason: 'still starting');

      // Call evaluate again while stockfish is starting
      final work2 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));
      final stream2 = service.evaluate(work2);

      // Wait for engine to be ready
      await stream2!.first;

      // Should only have one start call (no restart when state was starting)
      expect(delayedStockfish.startCount, 1);
      // And nothing is quit: the second request joined the engine that was already starting.
      expect(delayedStockfish.quitCount, 0);
    });

    test('stop() during init clears work but init continues', () async {
      final delayedStockfish = FakeEngine(startDelay: const Duration(milliseconds: 50));
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = makeWork();
      service.evaluate(work);

      expect(service.state.lifecycle, EngineLifecycle.loading);

      service.stop();

      expect(service.state.currentWork, isNull);
      expect(service.state.eval, isNull);
    });

    test('rapid quit/evaluate cycles are handled correctly', () async {
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = makeWork();

      // First cycle
      final stream1 = service.evaluate(work);
      await stream1!.first;
      service.release();

      // Second cycle
      final stream2 = service.evaluate(work);
      await stream2!.first;
      service.release();

      // Third cycle
      final stream3 = service.evaluate(work);
      await stream3!.first;

      // One engine for all three cycles: each quit() lets go of it, and each evaluate() picks the
      // same one back up before the grace window has passed.
      expect(delayedStockfish.startCount, 1);
      expect(delayedStockfish.quitCount, 0);
    });

    test('multiple quit() calls are idempotent', () async {
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = makeWork();
      final stream = service.evaluate(work);
      await stream!.first;

      service.release();
      service.release();
      service.release();

      expect(service.state.currentWork, isNull);

      // Should still be able to evaluate after multiple quits
      final stream2 = service.evaluate(work);
      expect(stream2, isNotNull);
      await stream2!.first;
    });

    test('redundant quit() calls do not issue extra engine quit operations', () async {
      // Non-regression test for the idempotent-quit fix: once the engine is
      // back in its initial state, further quit() calls must short-circuit and
      // not reach the native engine again (quitting an already-quit engine is
      // what crashed it in #2870).
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        service.evaluate(makeWork());
        async.elapse(const Duration(seconds: 1));

        // Starting an engine does not quit one first, so nothing has been quit yet.
        expect(delayedStockfish.quitCount, 0);

        service.release();
        service.release();
        service.release();
        leaveEvaluatorScreen(container);

        async.elapse(kEngineDisposeDelay + const Duration(seconds: 1));

        expect(
          delayedStockfish.quitCount,
          1,
          reason: 'the engine is quit once, however many times it was let go of',
        );
      });
    });

    test('engine start/quit operations never overlap during rapid open/close cycles', () async {
      // Non-regression test for #2870: repeatedly opening and closing the
      // analysis page crashed the engine because native start/quit calls ran
      // concurrently. They must now be serialized through a single queue.
      final stockfish = FakeEngine();
      fakeEngine = stockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      // Simulate repeatedly opening (evaluate) and closing (quit) the screen.
      for (var i = 0; i < 5; i++) {
        service.evaluate(makeWork(id: StringId('game$i')));
        service.release();
      }

      // A final evaluation is enqueued after every cycle's operations. Awaiting
      // its first result therefore deterministically guarantees the whole
      // serialized queue has drained — no fixed delay needed.
      final stream = service.evaluate(makeWork(id: const StringId('after')));
      final (resultWork, _) = await stream!.first;
      expect(resultWork.id, const StringId('after'));

      expect(
        stockfish.maxConcurrentOps,
        1,
        reason: 'engine start/quit must be serialized to avoid native crashes (#2870)',
      );
    });
  });

  group('PositionEvaluator internal state consistency', () {
    test('stop() clears currentWork and currentEval', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = makeWork();
      service.evaluate(work);

      expect(service.state.currentWork, work);

      service.stop();

      expect(service.state.currentWork, isNull);
      expect(service.state.eval, isNull);
    });

    test('currentWork is updated immediately on evaluate()', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = makeWork();
      service.evaluate(work);

      expect(service.state.currentWork, work);
    });

    test('eval is reset immediately when evaluate() is called with new work', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      // Start first evaluation and wait for an eval result
      final work1 = makeWork(id: const StringId('game1'));
      final stream1 = service.evaluate(work1);
      await stream1!.first;
      expect(service.state.eval, isNotNull);

      // Start a new evaluation - eval must be cleared immediately, before any new results arrive
      final work2 = makeWork(id: const StringId('game2'));
      service.evaluate(work2);

      expect(service.state.eval, isNull);
    });

    test('evalStream emits results tagged with correct work', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = makeWork();
      final stream = service.evaluate(work);
      expect(stream, isNotNull);

      final (resultWork, _) = await stream!.first;
      expect(resultWork, work);
    });

    test('ucinewgame is sent when initialPosition changes', () async {
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work1 = makeWork(id: const StringId('game1'));
      final stream1 = service.evaluate(work1);
      await stream1!.first;

      delayedStockfish.commands.clear();

      // Different initialPosition (after e4)
      final positionAfterE4 = Chess.initial.play(Move.parse('e2e4')!);
      final work2 = makeWork(id: const StringId('game1'), initialPosition: positionAfterE4);
      final stream2 = service.evaluate(work2);
      await stream2!.first;

      expect(delayedStockfish.commands, contains('ucinewgame'));
    });

    test('ucinewgame is sent when variant changes (engine restart)', () async {
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work1 = makeWork(id: const StringId('game1'), variant: Variant.standard);
      final stream1 = service.evaluate(work1);
      await stream1!.first;

      delayedStockfish.commands.clear();

      final work2 = makeWork(id: const StringId('game1'), variant: Variant.atomic);
      final stream2 = service.evaluate(work2);
      await stream2!.first;

      expect(delayedStockfish.commands, contains('ucinewgame'));
    });

    test('ucinewgame is sent when flavor changes (engine restart)', () async {
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work1 = makeWork(id: const StringId('game1'));
      final stream1 = service.evaluate(work1);
      await stream1!.first;

      delayedStockfish.commands.clear();

      await setEnginePref(container, ChessEnginePref.sfLatest);
      final work2 = makeWork(id: const StringId('game1'));
      final stream2 = service.evaluate(work2);
      await stream2!.first;

      expect(delayedStockfish.commands, contains('ucinewgame'));
    });

    test('ucinewgame is not sent when work context is the same', () async {
      final delayedStockfish = FakeEngine();
      fakeEngine = delayedStockfish;

      final container = await makeContainer();
      final service = readEvaluator(container);

      final work1 = makeWork(id: const StringId('game1'));
      final stream1 = service.evaluate(work1);
      await stream1!.first;

      delayedStockfish.commands.clear();

      // Same id and initialPosition, just different path
      final work2 = makeWork(
        id: const StringId('game1'),
        path: UciPath.fromId(UciCharPair.fromUci('e2e4')),
      );
      final stream2 = service.evaluate(work2);
      await stream2!.first;

      expect(delayedStockfish.commands, isNot(contains('ucinewgame')));
    });

    test(
      'latestNoNNUE falling back to sf16 does not cause restart on subsequent latestNoNNUE requests',
      () async {
        final delayedStockfish = FakeEngine();
        fakeEngine = delayedStockfish;

        // NNUE files are unavailable: latestNoNNUE will fall back to sf16
        final container = await makeContainer(
          overrides: {
            stockfishNnueServiceProvider: stockfishNnueServiceProvider.overrideWithValue(
              FakeStockfishNnueServiceUnavailable(),
            ),
          },
        );
        final service = readEvaluator(container);

        final work1 = makeWork();
        final stream1 = service.evaluate(work1);
        await stream1!.first;

        expect(delayedStockfish.startCount, 1);

        // A second request with latestNoNNUE should reuse the running sf16 engine.
        final work2 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));
        final stream2 = service.evaluate(work2);
        await stream2!.first;

        expect(
          delayedStockfish.startCount,
          1,
          reason:
              'Engine must not restart when latestNoNNUE already fell back to sf16 '
              'and a new latestNoNNUE request arrives',
        );
      },
    );
  });

  group('PositionEvaluator', () {
    test('Uses the engine the user asked for on the variants Stockfish can play', () async {
      final container = await makeContainer();
      final service = readEvaluator(container, makeContext(variant: Variant.chess960));

      final stream = service.evaluate(makeWork(variant: Variant.chess960));
      expect(stream, isNotNull);
      await stream!.first;
      expect(service.state.engineName, 'Stockfish 16');
    });

    test('Falls back to Fairy-Stockfish for the variants Stockfish cannot play', () async {
      final container = await makeContainer();
      // Even asked for the latest Stockfish, an atomic game can only be evaluated by Fairy.
      await setEnginePref(container, ChessEnginePref.sfLatest);
      final service = readEvaluator(container, makeContext(variant: Variant.atomic));

      final stream = service.evaluate(makeWork(variant: Variant.atomic));
      expect(stream, isNotNull);
      await stream!.first;
      expect(service.state.engineName, 'Fairy-Stockfish');
    });

    test('Multiple evaluations - last caller wins', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      final work1 = EvalWork(
        id: const StringId('test'),
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 1),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      final work2 = EvalWork(
        id: const StringId('test'),
        variant: Variant.standard,
        threads: 1,
        path: UciPath.fromId(UciCharPair.fromUci('e2e4')),
        searchTime: const Duration(seconds: 1),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      // Start first evaluation
      service.evaluate(work1);

      // Start second evaluation - should take over
      final stream2 = service.evaluate(work2);

      // The second evaluation should be the current one
      expect(service.state.currentWork, work2);

      // Results from stream2 should have work2
      if (stream2 != null) {
        final result = await stream2.first;
        expect(result.$1, work2);
      }
    });

    test('Stop clears current work', () async {
      final container = await makeContainer();
      final service = readEvaluator(container);

      final work = EvalWork(
        id: const StringId('test'),
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 1),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      service.evaluate(work);
      expect(service.state.currentWork, work);

      service.stop();
      expect(service.state.currentWork, isNull);
    });

    test('Stop evaluation sets engine state to not computing', () async {
      final container = await makeContainer();

      final service = readEvaluator(container);

      final work = EvalWork(
        id: const StringId('test'),
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 3),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      service.evaluate(work);
      service.stop();

      expect(service.state.lifecycle, isNot(EngineLifecycle.computing));
    });

    test('Engine evaluation with fake stockfish', () async {
      final container = await makeContainer();

      final service = readEvaluator(container);

      final work = EvalWork(
        id: const StringId('test'),
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 3),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      final stream = service.evaluate(work);
      expect(stream, isNotNull);

      final (_, eval) = await stream!.first;

      expect(eval.bestMove, const NormalMove(from: Square.e2, to: Square.e4));
    });

    test('Engine transitions to error state on startup failure', () async {
      final errorStockfish = ErrorEngine();
      fakeEngine = errorStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        final work = EvalWork(
          id: const StringId('test'),
          variant: Variant.standard,
          threads: 1,
          path: UciPath.empty,
          searchTime: const Duration(seconds: 1),
          multiPv: 1,
          initialPosition: Chess.initial,
          steps: IList(),
          threatMode: false,
        );

        service.evaluate(work);

        async.flushMicrotasks();

        expect(service.state.lifecycle, EngineLifecycle.error);
      });
    });

    test('Engine transitions to error state when start() throws', () async {
      // Non-regression test: start/quit go through an error-swallowing
      // serialization queue, but a thrown failure from start() must still be
      // surfaced as EngineLifecycle.error rather than leaving the engine stuck in
      // the loading state.
      fakeEngine = ThrowingStartEngine();

      final container = await makeContainer();
      final service = readEvaluator(container);

      service.evaluate(makeWork());

      // Wait for the failing initialization to settle.
      await pumpEventQueue();

      expect(service.state.lifecycle, EngineLifecycle.error);
    });

    test('An engine that never finishes starting is reported as stuck', () async {
      fakeEngine = StuckEngine();
      final container = await makeContainer();
      final crashlytics = testBinding.firebaseCrashlytics;
      crashlytics.recordedErrors.clear();

      fakeAsync((async) {
        final service = readEvaluator(container);

        service.evaluate(makeWork());
        async.flushMicrotasks();

        // Nothing has failed yet: the engine is simply still loading.
        expect(service.state.lifecycle, EngineLifecycle.loading);
        expect(crashlytics.recordedErrors, isEmpty);

        async.elapse(kEngineCreateTimeout + const Duration(seconds: 1));
        async.flushMicrotasks();

        expect(service.state.lifecycle, EngineLifecycle.error);
        expect(crashlytics.customKeys['engine_failure_kind'], 'stuck');
        expect(crashlytics.customKeys['engine_unrecoverable'], true);
        // A create that never returns never hands back an engine to read the native diagnostics
        // from, so the report says so rather than inventing a phase. In production the plugin
        // bounds every step it takes and puts its own reading of them in the TimeoutException it
        // throws, which is what this backstop reports when it does fire.
        expect(crashlytics.customKeys['engine_phase'], 'unknown');
        expect(crashlytics.customKeys['engine_phase_step'], 'unknown');
        expect(crashlytics.recordedErrors, hasLength(1));
      });
    });

    test('An engine that wedges on a later start is still reported as stuck', () async {
      // The first engine starts and is let go of normally; the one that replaces it never becomes
      // ready. A start that follows a healthy engine has to be reported like any other, or a
      // restart that never completes is never reported.
      final stockfish = WedgesOnRestartEngine();
      fakeEngine = stockfish;
      final container = await makeContainer();
      final crashlytics = testBinding.firebaseCrashlytics;
      crashlytics.recordedErrors.clear();

      fakeAsync((async) {
        final service = readEvaluator(container);

        service.evaluate(makeWork());
        async.elapse(const Duration(seconds: 1));
        expect(stockfish.startCount, 1);
        expect(service.state.lifecycle, EngineLifecycle.idle);

        leaveEvaluatorScreen(container);
        // Past the grace window, so the engine really is gone and the next request has to start
        // another one.
        async.elapse(kEngineDisposeDelay + const Duration(seconds: 1));

        final nextScreen = readEvaluator(container);
        nextScreen.evaluate(makeWork(id: const StringId('test2')));
        async.flushMicrotasks();
        expect(stockfish.startCount, 2);

        async.elapse(kEngineCreateTimeout + const Duration(seconds: 1));
        async.flushMicrotasks();

        expect(nextScreen.state.lifecycle, EngineLifecycle.error);
        expect(crashlytics.customKeys['engine_failure_kind'], 'stuck');
      });
    });

    test('A stuck engine releases pending work and refuses new work', () async {
      fakeEngine = StuckEngine();
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        expect(service.evaluate(makeWork()), isNotNull);
        async.flushMicrotasks();
        expect(service.currentWork, isNotNull);

        async.elapse(kEngineCreateTimeout + const Duration(seconds: 1));
        async.flushMicrotasks();

        // Nothing is going to answer the work that was waiting on this engine, so it is let go of
        // rather than left pending against an engine that is never coming back.
        expect(service.currentWork, isNull);
        expect(service.state.lifecycle, EngineLifecycle.error);

        // The engine is gone for the rest of the process's life, so later work is refused on the
        // spot instead of queueing behind an operation that will never complete.
        service.evaluate(makeWork());
        async.flushMicrotasks();
        expect(service.state.lifecycle, EngineLifecycle.error);
      });
    });

    test('A command the engine refuses is reported instead of thrown at the caller', () async {
      // The write that breaks the session is silent: the plugin reports it by moving the engine's
      // state, not by throwing. The transport is listening for that while it writes, so the
      // failure names the command that caused it and the session is closed there and then —
      // nothing else is sent to an engine that cannot read it.
      final stockfish = FatalWriteEngine();
      fakeEngine = stockfish;
      final container = await makeContainer();
      final crashlytics = testBinding.firebaseCrashlytics;
      crashlytics.recordedErrors.clear();

      final service = readEvaluator(container);

      expect(() => service.evaluate(makeWork()), returnsNormally);

      await pumpEventQueue();

      expect(stockfish.failedCommands, hasLength(1));
      expect(
        stockfish.commands,
        stockfish.failedCommands,
        reason:
            'a dead session is not written to again, so nothing follows the command that '
            'killed it',
      );
      expect(service.state.lifecycle, EngineLifecycle.error);
      expect(crashlytics.customKeys['engine_failure_kind'], 'command');
      expect(crashlytics.recordedErrors.last.reason, contains(stockfish.failedCommands.single));
    });

    test('A write that fails mid-search leaves the engine in the error state', () async {
      // The failed write is not thrown back at UCIProtocol, so it carries on with the exchange and
      // ends it by announcing that it is computing. That announcement must not be taken for a
      // working engine.
      fakeEngine = FatalWriteEngine(fails: (command) => command.startsWith('go'));
      final container = await makeContainer();
      final service = readEvaluator(container);

      service.evaluate(makeWork());

      await pumpEventQueue();

      expect(service.state.lifecycle, EngineLifecycle.error);
    });

    test('Work requested after a broken command stream restarts the engine', () async {
      // Nothing recovers a failed session but a new start: the plugin refuses every write until
      // one happens.
      final stockfish = FatalWriteEngine();
      fakeEngine = stockfish;
      final container = await makeContainer();
      final service = readEvaluator(container);

      service.evaluate(makeWork());
      await pumpEventQueue();

      expect(stockfish.startCount, 1);

      service.evaluate(makeWork(path: UciPath.fromId(UciCharPair.fromMove(Move.parse('e2e4')!))));
      await pumpEventQueue();

      expect(stockfish.startCount, 2);
    });

    test('Engine name is correctly set after restarting stockfish', () async {
      final fakeStockfish = FakeEngine();
      fakeEngine = fakeStockfish;
      final container = await makeContainer();

      final service = readEvaluator(container);

      final work = makeWork();

      final stream1 = service.evaluate(work);
      expect(stream1, isNotNull);
      await stream1!.first;

      expect(service.state.engineName, 'Stockfish 16');

      service.release();
      await pumpEventQueue();

      // Changing the preference is what changes the engine now.
      await setEnginePref(container, ChessEnginePref.sfLatest);

      final stream2 = service.evaluate(work);
      expect(stream2, isNotNull);
      await stream2!.first;

      expect(service.state.engineName, 'Stockfish 18');
    });
  });

  group('PositionEvaluator throttle behavior', () {
    test('first eval event is emitted immediately without throttle delay', () async {
      final throttleStockfish = ThrottleTestEngine();
      fakeEngine = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);
        final results = <EvalResult>[];

        service.evalStream.listen(results.add);

        final work = makeWork();
        service.evaluate(work);

        // Let engine initialize
        async.elapse(const Duration(milliseconds: 50));

        // Emit one eval event
        throttleStockfish.emitEvalEvents();
        async.flushMicrotasks();

        // First event should be emitted immediately (no throttle delay)
        expect(results.length, 1);
        expect(results.first.$1, work);
      });
    });

    test('events during throttle window are collected, only trailing is emitted', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);
        final results = <EvalResult>[];

        service.evalStream.listen(results.add);

        final work = makeWork();
        service.evaluate(work);

        // Let engine initialize
        async.elapse(const Duration(milliseconds: 50));

        // Emit first event - should be emitted immediately
        throttleStockfish.emitEvalEvents(); // depth 11, cp 10
        async.flushMicrotasks();
        expect(results.length, 1);
        expect(results.last.$2.depth, 11);

        // Emit more events within throttle window (200ms)
        throttleStockfish.emitEvalEvents(); // depth 12, cp 20
        async.flushMicrotasks();
        throttleStockfish.emitEvalEvents(); // depth 13, cp 30
        async.flushMicrotasks();
        throttleStockfish.emitEvalEvents(); // depth 14, cp 40
        async.flushMicrotasks();

        // Still only 1 result (first one) - others are pending
        expect(results.length, 1);

        // Elapse throttle delay (200ms)
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // Now trailing event should be emitted (the last one: depth 14)
        expect(results.length, 2);
        expect(results.last.$2.depth, 14);
      });
    });

    test('multiple throttle windows emit correctly', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);
        final results = <EvalResult>[];

        service.evalStream.listen(results.add);

        final work = makeWork();
        service.evaluate(work);

        // Let engine initialize
        async.elapse(const Duration(milliseconds: 50));

        // First window: emit events
        throttleStockfish.emitEvalEvents(); // depth 11 - emitted immediately
        async.flushMicrotasks();
        throttleStockfish.emitEvalEvents(); // depth 12 - pending
        async.flushMicrotasks();

        expect(results.length, 1);
        expect(results.last.$2.depth, 11);

        // Wait for throttle to expire - trailing event emitted, starts new window
        async.elapse(kEngineEvalEmissionThrottleDelay);
        expect(results.length, 2);
        expect(results.last.$2.depth, 12);

        // Wait for the trailing emission's throttle window to expire
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // Second window: emit more events
        throttleStockfish.emitEvalEvents(); // depth 13 - emitted immediately (new window)
        async.flushMicrotasks();
        throttleStockfish.emitEvalEvents(); // depth 14 - pending
        async.flushMicrotasks();

        expect(results.length, 3);
        expect(results.last.$2.depth, 13);

        // Wait for second throttle to expire
        async.elapse(kEngineEvalEmissionThrottleDelay);
        expect(results.length, 4);
        expect(results.last.$2.depth, 14);
      });
    });

    test('quit() cancels pending throttle timer - no pending timers', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);
        final results = <EvalResult>[];

        service.evalStream.listen(results.add);

        final work = makeWork();
        service.evaluate(work);

        // Let engine initialize
        async.elapse(const Duration(milliseconds: 50));

        // Emit events to start throttle window
        throttleStockfish.emitEvalEvents(); // emitted immediately
        async.flushMicrotasks();
        throttleStockfish.emitEvalEvents(); // pending
        async.flushMicrotasks();

        expect(results.length, 1);

        // Quit before throttle expires - should cancel pending timer
        service.release();
        async.flushMicrotasks();

        // Elapse more than throttle delay
        async.elapse(kEngineEvalEmissionThrottleDelay * 2);

        // Pending event should NOT have been emitted (timer was cancelled)
        expect(results.length, 1);

        // No pending timers assertion is implicit - fakeAsync would fail if timer was still pending
      });
    });

    test('stop() does not cancel throttle timer - pending event still emits', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);
        final results = <EvalResult>[];

        service.evalStream.listen(results.add);

        final work = makeWork();
        service.evaluate(work);

        // Let engine initialize
        async.elapse(const Duration(milliseconds: 50));

        // Emit events to start throttle window
        throttleStockfish.emitEvalEvents(); // emitted immediately
        async.flushMicrotasks();
        throttleStockfish.emitEvalEvents(); // pending
        async.flushMicrotasks();

        expect(results.length, 1);

        // stop() clears work but doesn't cancel throttle timer
        service.stop();
        async.flushMicrotasks();

        // Elapse throttle delay
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // Pending event should still be emitted (throttle timer not cancelled by stop)
        expect(results.length, 2);
      });
    });

    test('evaluationState.eval is updated with throttled events', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        final work = makeWork();
        service.evaluate(work);

        // Let engine initialize
        async.elapse(const Duration(milliseconds: 50));

        expect(service.state.eval, isNull);

        // Emit first event - updates state immediately
        throttleStockfish.emitEvalEvents(); // depth 11
        async.flushMicrotasks();

        expect(service.state.eval, isNotNull);
        expect(service.state.eval!.depth, 11);

        // Emit more events within throttle window
        throttleStockfish.emitEvalEvents(); // depth 12 - pending
        async.flushMicrotasks();
        throttleStockfish.emitEvalEvents(); // depth 13 - pending (overwrites)
        async.flushMicrotasks();

        // State still shows first event (throttled)
        expect(service.state.eval!.depth, 11);

        // Wait for throttle to expire
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // Now state shows the trailing event
        expect(service.state.eval!.depth, 13);
      });
    });

    test('rapid events only result in first + trailing emissions', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);
        final results = <EvalResult>[];

        service.evalStream.listen(results.add);

        final work = makeWork();
        service.evaluate(work);

        // Let engine initialize
        async.elapse(const Duration(milliseconds: 50));

        // Emit 10 rapid events
        for (var i = 0; i < 10; i++) {
          throttleStockfish.emitEvalEvents();
          async.flushMicrotasks();
        }

        // Only first event emitted so far
        expect(results.length, 1);
        expect(results.first.$2.depth, 11); // first event

        // Wait for throttle
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // Now trailing (last) event is also emitted
        expect(results.length, 2);
        expect(results.last.$2.depth, 20); // 10th event (11 + 9)
      });
    });
    test('_emitEval drops late evaluations from previous positions', () async {
      final throttleEngine = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleEngine;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        final work1 = makeWork(
          id: const StringId('position_1'),
          path: UciPath.fromId(UciCharPair.fromUci('e2e4')),
        );
        final work2 = makeWork(
          id: const StringId('position_2'),
          path: UciPath.fromId(UciCharPair.fromUci('d2d4')),
        );

        // Start evaluating position 1
        service.evaluate(work1);
        async.flushMicrotasks();

        // Emit the first event. This updates the state immediately and starts the throttle timer.
        throttleEngine.emitEvalEvents();
        async.flushMicrotasks();
        expect(service.state.eval, isNotNull); // Confirm work1 has an active eval

        // Emit a second event for work1. This gets trapped inside the service's trailing slot variable.
        throttleEngine.emitEvalEvents();
        async.flushMicrotasks();

        // Now switch to position 2 while the timer is still ticking down
        service.evaluate(work2);
        async.flushMicrotasks();

        // Elapse the remaining time to force the throttle timer to fire its trailing slot flush
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // Drops the trapped eval because the target position doesn't match work2.
        expect(service.state.currentWork, work2);
        expect(service.state.eval, isNull);
      });
    });
  });

  group('engineEvaluationProvider', () {
    test('updates engineName after engine restart', () async {
      final fakeStockfish = FakeEngine();
      fakeEngine = fakeStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        EngineEvaluationState? latestState;
        container.listen(
          engineEvaluationProvider((
            context: makeContext(id: const StringId('test')),
            path: UciPath.empty,
          )),
          (_, next) {
            latestState = next;
          },
          fireImmediately: true,
        );

        final work = makeWork();

        // Start engine and let all async operations complete
        service.evaluate(work);
        async.elapse(const Duration(seconds: 2));

        // Notifier should have the first engine name
        expect(latestState?.engineName, 'Stockfish 16');

        // Let go of the engine, then ask for a different one.
        service.release();
        async.elapse(const Duration(seconds: 1));

        setEnginePref(container, ChessEnginePref.sfLatest);
        async.flushMicrotasks();

        service.evaluate(work);
        async.elapse(const Duration(seconds: 2));

        // Notifier should have the updated engine name
        expect(
          latestState?.engineName,
          'Stockfish 18',
          reason: 'engineEvaluationProvider should surface the new engine name after a restart',
        );
      });
    });

    test("an evaluator never sees another context's results", () async {
      // What used to need an id filter is structural now: evaluators are per [EvaluationContext],
      // so one game's evaluation cannot reach another game's screen at all.
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container, makeContext(id: const StringId('game2')));

        EngineEvaluationState? game1State;
        container.listen(
          engineEvaluationProvider((
            context: makeContext(id: const StringId('game1')),
            path: UciPath.empty,
          )),
          (_, next) {
            game1State = next;
          },
          fireImmediately: true,
        );

        // Evaluate work for 'game2' - different id than the notifier's filter
        final work = makeWork(id: const StringId('game2'));
        service.evaluate(work);
        async.elapse(const Duration(milliseconds: 50));

        throttleStockfish.emitEvalEvents();
        async.flushMicrotasks();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // game1's evaluator was never asked for anything, so it has nothing to show.
        expect(
          game1State?.eval,
          isNull,
          reason: 'an evaluator should not see the results of another context',
        );
        expect(game1State?.lifecycle, EngineLifecycle.initial);
      });
    });

    test('notifier with path filter ignores eval results from work with different path', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        final e4Path = UciPath.fromId(UciCharPair.fromUci('e2e4'));
        final d4Path = UciPath.fromId(UciCharPair.fromUci('d2d4'));

        EngineEvaluationState? e4State;
        container.listen(
          engineEvaluationProvider((
            context: makeContext(id: const StringId('test')),
            path: e4Path,
          )),
          (_, next) {
            e4State = next;
          },
          fireImmediately: true,
        );

        // Evaluate work with a different path (d4 instead of e4)
        final work = makeWork(id: const StringId('test'), path: d4Path);
        service.evaluate(work);
        async.elapse(const Duration(milliseconds: 50));

        throttleStockfish.emitEvalEvents();
        async.flushMicrotasks();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // The notifier listening for the e4 path should not receive updates for d4 work
        expect(
          e4State?.eval,
          isNull,
          reason: 'Notifier should not receive eval updates from work with a different path',
        );
        expect(e4State?.lifecycle, EngineLifecycle.initial);
      });
    });

    test('notifier receives eval results for matching id and path', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        EngineEvaluationState? latestState;
        container.listen(
          engineEvaluationProvider((
            context: makeContext(id: const StringId('test')),
            path: UciPath.empty,
          )),
          (_, next) {
            latestState = next;
          },
          fireImmediately: false,
        );

        final work = makeWork(); // id: 'test', path: UciPath.empty
        service.evaluate(work);
        async.elapse(const Duration(milliseconds: 50));

        throttleStockfish.emitEvalEvents();
        async.flushMicrotasks();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        expect(
          latestState?.eval,
          isNotNull,
          reason: 'Notifier should receive eval updates from work with matching id and path',
        );
      });
    });

    test('notifier does not filter work.path when path filter is null', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        EngineEvaluationState? latestState;
        container.listen(
          engineEvaluationProvider((context: makeContext(id: const StringId('test')), path: null)),
          (_, next) {
            latestState = next;
          },
          fireImmediately: false,
        );

        final work = makeWork();
        service.evaluate(work);
        async.elapse(const Duration(milliseconds: 50));

        throttleStockfish.emitEvalEvents();
        async.flushMicrotasks();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        expect(
          latestState?.eval,
          isNotNull,
          reason: 'Notifier should receive updates from null path filter regardless of work.path',
        );
      });
    });

    test(
      'two notifiers with different ids are isolated: only the matching one receives updates',
      () async {
        final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
        fakeEngine = throttleStockfish;
        final container = await makeContainer();

        fakeAsync((async) {
          final service = readEvaluator(container, makeContext(id: const StringId('game1')));

          EngineEvaluationState? game1State;
          EngineEvaluationState? game2State;

          container.listen(
            engineEvaluationProvider((
              context: makeContext(id: const StringId('game1')),
              path: UciPath.empty,
            )),
            (_, next) {
              game1State = next;
            },
            fireImmediately: true,
          );

          container.listen(
            engineEvaluationProvider((
              context: makeContext(id: const StringId('game2')),
              path: UciPath.empty,
            )),
            (_, next) {
              game2State = next;
            },
            fireImmediately: true,
          );

          // Evaluate work for 'game1'
          final work1 = makeWork(id: const StringId('game1'));
          service.evaluate(work1);
          async.elapse(const Duration(milliseconds: 50));

          throttleStockfish.emitEvalEvents();
          async.flushMicrotasks();
          async.elapse(kEngineEvalEmissionThrottleDelay);

          // Only the 'game1' notifier should have received the eval
          expect(
            game1State?.eval,
            isNotNull,
            reason: 'game1 notifier should receive updates for game1 work',
          );
          expect(
            game2State?.eval,
            isNull,
            reason: 'game2 notifier should not receive updates for game1 work',
          );
          expect(game2State?.lifecycle, EngineLifecycle.initial);
        });
      },
    );

    test('all notifiers are reset to initial state when quit() is called', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container, makeContext(id: const StringId('game1')));

        EngineEvaluationState? game1State;

        container.listen(
          engineEvaluationProvider((context: makeContext(id: const StringId('game1')), path: null)),
          (_, next) {
            game1State = next;
          },
          fireImmediately: true,
        );

        final work1 = makeWork(id: const StringId('game1'));
        service.evaluate(work1);
        async.elapse(const Duration(milliseconds: 50));

        throttleStockfish.emitEvalEvents();
        async.flushMicrotasks();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        expect(game1State?.eval, isNotNull);

        service.release();
        async.elapse(Duration.zero);

        expect(
          game1State?.lifecycle,
          EngineLifecycle.initial,
          reason: 'game1 notifier should be reset',
        );
        expect(game1State?.eval, isNull, reason: 'game1 notifier eval should be cleared');
      });
    });

    test('discards eval results that arrive after quit()', () async {
      final throttleStockfish = ThrottleTestEngine(evalEventCount: 1);
      fakeEngine = throttleStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        EngineEvaluationState? latestState;
        container.listen(
          engineEvaluationProvider((
            context: makeContext(id: const StringId('test')),
            path: UciPath.empty,
          )),
          (_, next) {
            latestState = next;
          },
          fireImmediately: true,
        );

        final work = makeWork();

        // Start evaluation
        service.evaluate(work);
        async.elapse(const Duration(milliseconds: 50));

        // Emit some eval events to build up state
        throttleStockfish.emitEvalEvents(); // depth 11
        async.flushMicrotasks();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        throttleStockfish.emitEvalEvents(); // depth 12
        async.flushMicrotasks();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // Verify we have an eval with depth 12
        expect(latestState?.eval, isNotNull);
        expect(latestState?.eval?.depth, 12);

        // Releasing the engine resets the state and discards whatever it says from now on.
        service.release();
        async.elapse(Duration.zero);

        // State should be reset
        expect(latestState?.lifecycle, EngineLifecycle.initial);
        expect(latestState?.eval, isNull);
        expect(latestState?.currentWork, isNull);

        // Now simulate a bestmove arriving after the release: it would otherwise emit the last eval.
        throttleStockfish.emitBestMove();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // State should still be reset - the bestmove result should be discarded
        expect(
          latestState?.eval,
          isNull,
          reason: 'Eval results arriving after quit() should be discarded',
        );
        expect(latestState?.lifecycle, EngineLifecycle.initial);
      });
    });
    test('the filter falls back to the default state when the path no longer matches', () async {
      final container = await makeContainer();

      fakeAsync((async) {
        final service = readEvaluator(container);

        final e4Path = UciPath.fromId(UciCharPair.fromUci('e2e4'));
        final provider = engineEvaluationProvider((context: makeContext(), path: e4Path));

        service.evaluate(makeWork(path: e4Path));
        async.flushMicrotasks();

        expect(container.read(provider).currentWork?.path, e4Path);

        // The user moves on to another node: the widget still showing e4 must not be handed the
        // evaluation of the position that replaced it.
        service.evaluate(makeWork(path: UciPath.fromId(UciCharPair.fromUci('d2d4'))));
        async.flushMicrotasks();

        final filtered = container.read(provider);
        expect(filtered.currentWork, isNull);
        expect(filtered.eval, isNull);
        expect(filtered.lifecycle, EngineLifecycle.initial);
      });
    });
  });
}
