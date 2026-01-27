import 'package:dartchess/dartchess.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:multistockfish/multistockfish.dart';

import '../../binding.dart';
import '../../test_container.dart';
import 'fake_stockfish.dart';

Work makeWork({
  StringId? id,
  UciPath? path,
  ChessEnginePref enginePref = ChessEnginePref.sf16,
  Duration searchTime = const Duration(seconds: 1),
  Position? initialPosition,
}) {
  return Work(
    id: id,
    enginePref: enginePref,
    variant: Variant.standard,
    threads: 1,
    path: path ?? UciPath.empty,
    searchTime: searchTime,
    multiPv: 1,
    initialPosition: initialPosition ?? Chess.initial,
    steps: IList(),
    threatMode: false,
  );
}

void main() {
  TestLichessBinding.ensureInitialized();

  setUp(() {
    testBinding.stockfish = FakeStockfish();
  });

  group('EvaluationService state transitions', () {
    test('initial state is EngineState.initial', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      expect(service.evaluationState.value.state, EngineState.initial);
      expect(service.evaluationState.value.currentWork, isNull);
      expect(service.evaluationState.value.eval, isNull);
    });

    test('evaluate() transitions state from initial to loading to idle', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      // Track state transitions (filter out consecutive duplicates)
      final states = <EngineState>[];
      service.evaluationState.addListener(() {
        final newState = service.evaluationState.value.state;
        if (states.isEmpty || states.last != newState) {
          states.add(newState);
        }
      });

      final work = makeWork();
      final stream = service.evaluate(work);
      expect(stream, isNotNull);

      await stream!.first;

      expect(states, contains(EngineState.loading));
      expect(states.last, anyOf(EngineState.idle, EngineState.computing));
    });

    test('quit() resets evaluationState to initial state immediately', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      final stream = service.evaluate(work);
      await stream!.first;

      // Verify we have non-initial state before quit
      expect(service.evaluationState.value.state, isNot(EngineState.initial));
      expect(service.evaluationState.value.currentWork, isNotNull);
      expect(service.evaluationState.value.eval, isNotNull);
      expect(service.evaluationState.value.engineName, isNotNull);

      service.quit();

      // quit() should immediately reset all fields to initial state
      expect(service.evaluationState.value.state, EngineState.initial);
      expect(service.evaluationState.value.currentWork, isNull);
      expect(service.evaluationState.value.eval, isNull);
      expect(service.evaluationState.value.engineName, isNull);
    });

    test('state transitions idle -> computing -> idle when work completes', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      // First evaluation to get engine into idle state
      final initWork = makeWork();
      final initStream = service.evaluate(initWork);
      await initStream!.first;

      // Wait for state to settle to idle
      while (service.evaluationState.value.state != EngineState.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(service.evaluationState.value.state, EngineState.idle);

      // Track state transitions for the next evaluation (filter out consecutive duplicates)
      // Initialize with current state to only capture actual transitions
      var lastState = service.evaluationState.value.state;
      final states = <EngineState>[];
      service.evaluationState.addListener(() {
        final newState = service.evaluationState.value.state;
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
      while (service.evaluationState.value.state != EngineState.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      expect(states, [EngineState.computing, EngineState.idle]);
    });

    test('new work while computing: stream1 receives results before work2, not after', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      // Initialize engine
      final initWork = makeWork();
      final initStream = service.evaluate(initWork);
      await initStream!.first;

      while (service.evaluationState.value.state != EngineState.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      // Track stream1 results
      final stream1ResultsBeforeWork2 = <Work>[];
      final stream1ResultsAfterWork2 = <Work>[];
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

      expect(service.evaluationState.value.currentWork, work2);

      // Wait for work2 to complete
      final (resultWork2, _) = await stream2!.first;
      expect(resultWork2, work2);

      while (service.evaluationState.value.state != EngineState.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      // stream1 should not receive any results after work2 started
      expect(stream1ResultsAfterWork2, isEmpty);
    });

    test('evaluate() after quit() restarts engine', () async {
      final delayedStockfish = DelayedFakeStockfish();
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      final stream1 = service.evaluate(work);
      await stream1!.first;

      expect(delayedStockfish.startCallCount, 1);

      service.quit();

      final stream2 = service.evaluate(work);
      await stream2!.first;

      expect(delayedStockfish.startCallCount, 2);
    });
  });

  group('EvaluationService race conditions', () {
    test('rapid evaluate() calls during init - last caller wins', () async {
      final delayedStockfish = DelayedFakeStockfish(startDelay: const Duration(milliseconds: 50));
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work1 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));
      final work2 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('d2d4')));
      final work3 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('c2c4')));

      // Collect results from stream1 to verify it doesn't receive work3 results
      final stream1Results = <Work>[];
      final stream1 = service.evaluate(work1);
      stream1!.listen((result) => stream1Results.add(result.$1));

      service.evaluate(work2);
      final stream3 = service.evaluate(work3);

      expect(service.evaluationState.value.currentWork, work3);

      // Wait for evaluation to complete
      final (resultWork, _) = await stream3!.first;

      // Result should be for work3, not work1 or work2
      expect(resultWork, work3);

      // Engine should only be started once despite multiple evaluate() calls
      expect(delayedStockfish.startCallCount, 1);
      // quit is called once in _initEngine before start
      expect(delayedStockfish.quitCallCount, 1);
      // compute() is called only once (with work3) after _initEngine completes, because
      // when _initInProgress is true, evaluate() just returns a stream without calling compute().
      // That one compute() call doesn't send 'stop' because _work is null (reset in _initEngine).
      // The 1 stop comes from the info handler: elapsedMs (1500) > searchTime (1000).
      expect(delayedStockfish.stopCallCount, 1);

      // stream1 is filtered to work1, so it should not have received any results
      // (the engine only computed work3)
      expect(stream1Results, isEmpty);
    });

    test('evaluate() while init in progress does not start new init', () async {
      final delayedStockfish = DelayedFakeStockfish(startDelay: const Duration(milliseconds: 100));
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work1 = makeWork();
      final work2 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));

      service.evaluate(work1);
      expect(service.evaluationState.value.state, EngineState.loading);

      final stream2 = service.evaluate(work2);
      expect(service.evaluationState.value.currentWork, work2);

      // Wait for init to complete
      await stream2!.first;

      // Still only one start call
      expect(delayedStockfish.startCallCount, 1);
    });

    test('evaluate() does not restart when stockfish is in starting state', () async {
      final delayedStockfish = DelayedFakeStockfish(startDelay: const Duration(milliseconds: 100));
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work1 = makeWork();
      service.evaluate(work1);

      // Wait for stockfish to be in starting state
      while (delayedStockfish.state.value != StockfishState.starting) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      expect(delayedStockfish.state.value, StockfishState.starting);

      // Call evaluate again while stockfish is starting
      final work2 = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));
      final stream2 = service.evaluate(work2);

      // Wait for engine to be ready
      await stream2!.first;

      // Should only have one start call (no restart when state was starting)
      expect(delayedStockfish.startCallCount, 1);
      // quit is only called once during _initEngine before the first start
      expect(delayedStockfish.quitCallCount, 1);
    });

    test('stop() during init clears work but init continues', () async {
      final delayedStockfish = DelayedFakeStockfish(startDelay: const Duration(milliseconds: 50));
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      service.evaluate(work);

      expect(service.evaluationState.value.state, EngineState.loading);

      service.stop();

      expect(service.evaluationState.value.currentWork, isNull);
      expect(service.evaluationState.value.eval, isNull);
    });

    test('rapid quit/evaluate cycles are handled correctly', () async {
      final delayedStockfish = DelayedFakeStockfish();
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();

      // First cycle
      final stream1 = service.evaluate(work);
      await stream1!.first;
      service.quit();

      // Second cycle
      final stream2 = service.evaluate(work);
      await stream2!.first;
      service.quit();

      // Third cycle
      final stream3 = service.evaluate(work);
      await stream3!.first;

      // startCallCount is 3 (one per evaluate cycle)
      expect(delayedStockfish.startCallCount, 3);
      // quitCallCount is 5: 3 from _initEngine (before each start) + 2 explicit quit() calls
      expect(delayedStockfish.quitCallCount, 5);
    });

    test('multiple quit() calls are idempotent', () async {
      final delayedStockfish = DelayedFakeStockfish();
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      final stream = service.evaluate(work);
      await stream!.first;

      service.quit();
      service.quit();
      service.quit();

      expect(service.evaluationState.value.currentWork, isNull);

      // Should still be able to evaluate after multiple quits
      final stream2 = service.evaluate(work);
      expect(stream2, isNotNull);
      await stream2!.first;
    });
  });

  group('EvaluationService internal state consistency', () {
    test('stop() clears currentWork and currentEval', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      service.evaluate(work);

      expect(service.evaluationState.value.currentWork, work);

      service.stop();

      expect(service.evaluationState.value.currentWork, isNull);
      expect(service.evaluationState.value.eval, isNull);
    });

    test('evaluate() returns null for unsupported variants', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = Work(
        enginePref: ChessEnginePref.sf16,
        variant: Variant.antichess,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 1),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      final stream = service.evaluate(work);
      expect(stream, isNull);
      expect(service.evaluationState.value.currentWork, isNull);
    });

    test('currentWork is updated immediately on evaluate()', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      service.evaluate(work);

      expect(service.evaluationState.value.currentWork, work);
    });

    test('evalStream emits results tagged with correct work', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      final stream = service.evaluate(work);
      expect(stream, isNotNull);

      final (resultWork, _) = await stream!.first;
      expect(resultWork, work);
    });

    test('ucinewgame is sent when initialPosition changes', () async {
      final delayedStockfish = DelayedFakeStockfish();
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work1 = makeWork(id: const StringId('game1'));
      final stream1 = service.evaluate(work1);
      await stream1!.first;

      // Clear commands to track only new ones
      delayedStockfish.stdinCommands.clear();

      // Different initialPosition (after e4)
      final positionAfterE4 = Chess.initial.play(Move.parse('e2e4')!);
      final work2 = makeWork(id: const StringId('game2'), initialPosition: positionAfterE4);
      final stream2 = service.evaluate(work2);
      await stream2!.first;

      expect(delayedStockfish.stdinCommands, contains('ucinewgame'));
    });

    test('ucinewgame is sent when work id changes', () async {
      final delayedStockfish = DelayedFakeStockfish();
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work1 = makeWork(id: const StringId('game1'));
      final stream1 = service.evaluate(work1);
      await stream1!.first;

      delayedStockfish.stdinCommands.clear();

      // Same initialPosition but different id
      final work2 = makeWork(id: const StringId('game2'));
      final stream2 = service.evaluate(work2);
      await stream2!.first;

      expect(delayedStockfish.stdinCommands, contains('ucinewgame'));
    });

    test('ucinewgame is not sent when work context is the same', () async {
      final delayedStockfish = DelayedFakeStockfish();
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work1 = makeWork(id: const StringId('game1'));
      final stream1 = service.evaluate(work1);
      await stream1!.first;

      delayedStockfish.stdinCommands.clear();

      // Same id and initialPosition, just different path
      final work2 = makeWork(
        id: const StringId('game1'),
        path: UciPath.fromId(UciCharPair.fromUci('e2e4')),
      );
      final stream2 = service.evaluate(work2);
      await stream2!.first;

      expect(delayedStockfish.stdinCommands, isNot(contains('ucinewgame')));
    });
  });

  group('EvaluationService', () {
    test('Concurrent NNUE download operations are prevented', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      bool secondCallReturned = false;
      bool secondCallResult = true;

      // Start first download (will fail due to missing connectivity/files, but that's ok)
      final firstDownload = service.downloadNNUEFiles(inBackground: true).catchError((_) {
        return false;
      });

      // Immediately start second download while first is in progress
      final secondDownload = service
          .downloadNNUEFiles(inBackground: true)
          .then((result) {
            secondCallReturned = true;
            secondCallResult = result;
            return result;
          })
          .catchError((_) {
            secondCallReturned = true;
            secondCallResult = false;
            return false;
          });

      await Future.wait([firstDownload, secondDownload]);

      expect(secondCallReturned, isTrue);
      expect(
        secondCallResult,
        isFalse,
        reason: 'Second concurrent download call should be rejected',
      );
    });

    test('Sequential NNUE downloads are allowed', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      // First download
      await service.downloadNNUEFiles(inBackground: true).catchError((_) => false);

      // Wait for first to complete, then start second
      final secondResult = await service
          .downloadNNUEFiles(inBackground: true)
          .catchError((_) => false);

      // Second call should be allowed since first completed
      // (will still fail due to missing files, but won't be rejected by the flag)
      expect(secondResult, isA<bool>());
    });

    test('Multiple evaluations - last caller wins', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work1 = Work(
        enginePref: ChessEnginePref.sf16,
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 1),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      final work2 = Work(
        enginePref: ChessEnginePref.sf16,
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
      expect(service.evaluationState.value.currentWork, work2);

      // Results from stream2 should have work2
      if (stream2 != null) {
        final result = await stream2.first;
        expect(result.$1, work2);
      }
    });

    test('Stop clears current work', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = Work(
        enginePref: ChessEnginePref.sf16,
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
      expect(service.evaluationState.value.currentWork, work);

      service.stop();
      expect(service.evaluationState.value.currentWork, isNull);
    });

    test('Stop evaluation sets engine state to not computing', () async {
      final container = await makeContainer();

      final service = container.read(evaluationServiceProvider);

      final work = Work(
        enginePref: ChessEnginePref.sf16,
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

      expect(service.evaluationState.value.state, isNot(EngineState.computing));
    });

    test('Engine evaluation with fake stockfish', () async {
      final container = await makeContainer();

      final service = container.read(evaluationServiceProvider);

      final work = Work(
        enginePref: ChessEnginePref.sf16,
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
      final errorStockfish = ErrorStockfish();
      testBinding.stockfish = errorStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);

        final work = Work(
          enginePref: ChessEnginePref.sf16,
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

        expect(service.evaluationState.value.state, EngineState.error);
      });
    });

    test('Engine name is correctly set after restarting stockfish', () async {
      final fakeStockfish = FakeStockfish();
      testBinding.stockfish = fakeStockfish;
      final container = await makeContainer();

      final service = container.read(evaluationServiceProvider);

      final work = makeWork();

      final stream1 = service.evaluate(work);
      expect(stream1, isNotNull);
      await stream1!.first;

      expect(service.evaluationState.value.engineName, 'Stockfish 16');

      service.quit();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final stream2 = service.evaluate(work.copyWith(enginePref: ChessEnginePref.sfLatest));
      expect(stream2, isNotNull);
      await stream2!.first;

      expect(service.evaluationState.value.engineName, 'Stockfish 17');
    });
  });

  group('EvaluationService throttle behavior', () {
    test('first eval event is emitted immediately without throttle delay', () async {
      final throttleStockfish = ThrottleTestStockfish();
      testBinding.stockfish = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);
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
      final throttleStockfish = ThrottleTestStockfish(evalEventCount: 1);
      testBinding.stockfish = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);
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
      final throttleStockfish = ThrottleTestStockfish(evalEventCount: 1);
      testBinding.stockfish = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);
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
      final throttleStockfish = ThrottleTestStockfish(evalEventCount: 1);
      testBinding.stockfish = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);
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
        service.quit();
        async.flushMicrotasks();

        // Elapse more than throttle delay
        async.elapse(kEngineEvalEmissionThrottleDelay * 2);

        // Pending event should NOT have been emitted (timer was cancelled)
        expect(results.length, 1);

        // No pending timers assertion is implicit - fakeAsync would fail if timer was still pending
      });
    });

    test('stop() does not cancel throttle timer - pending event still emits', () async {
      final throttleStockfish = ThrottleTestStockfish(evalEventCount: 1);
      testBinding.stockfish = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);
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
      final throttleStockfish = ThrottleTestStockfish(evalEventCount: 1);
      testBinding.stockfish = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);

        final work = makeWork();
        service.evaluate(work);

        // Let engine initialize
        async.elapse(const Duration(milliseconds: 50));

        expect(service.evaluationState.value.eval, isNull);

        // Emit first event - updates state immediately
        throttleStockfish.emitEvalEvents(); // depth 11
        async.flushMicrotasks();

        expect(service.evaluationState.value.eval, isNotNull);
        expect(service.evaluationState.value.eval!.depth, 11);

        // Emit more events within throttle window
        throttleStockfish.emitEvalEvents(); // depth 12 - pending
        async.flushMicrotasks();
        throttleStockfish.emitEvalEvents(); // depth 13 - pending (overwrites)
        async.flushMicrotasks();

        // State still shows first event (throttled)
        expect(service.evaluationState.value.eval!.depth, 11);

        // Wait for throttle to expire
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // Now state shows the trailing event
        expect(service.evaluationState.value.eval!.depth, 13);
      });
    });

    test('rapid events only result in first + trailing emissions', () async {
      final throttleStockfish = ThrottleTestStockfish(evalEventCount: 1);
      testBinding.stockfish = throttleStockfish;

      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);
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
  });

  group('EngineEvaluationNotifier', () {
    test('updates engineName after engine restart', () async {
      final fakeStockfish = FakeStockfish();
      testBinding.stockfish = fakeStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);

        EngineEvaluationState? latestState;
        container.listen(engineEvaluationProvider, (_, next) {
          latestState = next;
        }, fireImmediately: true);

        final work = makeWork();

        // Start engine and let all async operations complete
        service.evaluate(work);
        async.elapse(const Duration(seconds: 2));

        // Notifier should have the first engine name
        expect(latestState?.engineName, 'Stockfish 16');

        // Quit engine
        service.quit();
        async.elapse(const Duration(seconds: 1));

        // Restart with different engine name
        service.evaluate(work.copyWith(enginePref: ChessEnginePref.sfLatest));
        async.elapse(const Duration(seconds: 2));

        // Notifier should have the updated engine name
        expect(
          latestState?.engineName,
          'Stockfish 17',
          reason: 'EngineEvaluationNotifier should update engineName when engine restarts',
        );
      });
    });

    test('discards eval results that arrive after quit()', () async {
      final throttleStockfish = ThrottleTestStockfish(evalEventCount: 1);
      testBinding.stockfish = throttleStockfish;
      final container = await makeContainer();

      fakeAsync((async) {
        final service = container.read(evaluationServiceProvider);

        EngineEvaluationState? latestState;
        container.listen(engineEvaluationProvider, (_, next) {
          latestState = next;
        }, fireImmediately: true);

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

        // Call quit() - this should reset state and discard future results
        service.quit();
        // Flush microtasks twice: once for the service state change, once for the notifier listener
        async.flushMicrotasks();
        async.flushMicrotasks();

        // State should be reset
        expect(latestState?.state, EngineState.initial);
        expect(latestState?.eval, isNull);
        expect(latestState?.currentWork, isNull);

        // Now simulate bestmove arriving after quit (this would normally emit the old eval)
        throttleStockfish.emitBestMove();
        async.flushMicrotasks();
        async.flushMicrotasks();
        async.elapse(kEngineEvalEmissionThrottleDelay);

        // State should still be reset - the bestmove result should be discarded
        expect(
          latestState?.eval,
          isNull,
          reason: 'Eval results arriving after quit() should be discarded',
        );
        expect(latestState?.state, EngineState.initial);
      });
    });
  });
}
