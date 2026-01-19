import 'package:dartchess/dartchess.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';

import '../../binding.dart';
import '../../test_container.dart';
import 'fake_stockfish.dart';

Work makeWork({
  UciPath? path,
  ChessEnginePref enginePref = ChessEnginePref.sf16,
  Duration searchTime = const Duration(seconds: 1),
}) {
  return Work(
    enginePref: enginePref,
    variant: Variant.standard,
    threads: 1,
    path: path ?? UciPath.empty,
    searchTime: searchTime,
    multiPv: 1,
    initialPosition: Chess.initial,
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

      expect(service.engineState.value, EngineState.initial);
      expect(service.currentWork, isNull);
      expect(service.currentEval.value, isNull);
    });

    test('evaluate() transitions state from initial to loading to idle', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final states = <EngineState>[];
      service.engineState.addListener(() {
        states.add(service.engineState.value);
      });

      final work = makeWork();
      final stream = service.evaluate(work);
      expect(stream, isNotNull);

      await stream!.first;

      expect(states, contains(EngineState.loading));
      expect(states.last, anyOf(EngineState.idle, EngineState.computing));
    });

    test('quit() resets all internal state', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      final stream = service.evaluate(work);
      await stream!.first;

      service.quit();

      expect(service.currentWork, isNull);
    });

    test('state transitions idle -> computing -> idle when work completes', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      // First evaluation to get engine into idle state
      final initWork = makeWork();
      final initStream = service.evaluate(initWork);
      await initStream!.first;

      // Wait for state to settle to idle
      while (service.engineState.value != EngineState.idle) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(service.engineState.value, EngineState.idle);

      // Track state transitions for the next evaluation
      final states = <EngineState>[];
      service.engineState.addListener(() {
        states.add(service.engineState.value);
      });

      // Start new evaluation - should transition to computing
      final work = makeWork(path: UciPath.fromId(UciCharPair.fromUci('e2e4')));
      final stream = service.evaluate(work);
      expect(stream, isNotNull);

      // Wait for evaluation to complete
      await stream!.first;

      // Wait for state to settle back to idle
      while (service.engineState.value != EngineState.idle) {
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

      while (service.engineState.value != EngineState.idle) {
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

      expect(service.currentWork, work2);

      // Wait for work2 to complete
      final (resultWork2, _) = await stream2!.first;
      expect(resultWork2, work2);

      while (service.engineState.value != EngineState.idle) {
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

      expect(service.currentWork, work3);

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
      expect(service.engineState.value, EngineState.loading);

      final stream2 = service.evaluate(work2);
      expect(service.currentWork, work2);

      // Wait for init to complete
      await stream2!.first;

      // Still only one start call
      expect(delayedStockfish.startCallCount, 1);
    });

    test('stop() during init clears work but init continues', () async {
      final delayedStockfish = DelayedFakeStockfish(startDelay: const Duration(milliseconds: 50));
      testBinding.stockfish = delayedStockfish;

      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      service.evaluate(work);

      expect(service.engineState.value, EngineState.loading);

      service.stop();

      expect(service.currentWork, isNull);
      expect(service.currentEval.value, isNull);
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

      expect(service.currentWork, isNull);

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

      expect(service.currentWork, work);

      service.stop();

      expect(service.currentWork, isNull);
      expect(service.currentEval.value, isNull);
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
      expect(service.currentWork, isNull);
    });

    test('currentWork is updated immediately on evaluate()', () async {
      final container = await makeContainer();
      final service = container.read(evaluationServiceProvider);

      final work = makeWork();
      service.evaluate(work);

      expect(service.currentWork, work);
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
      expect(service.currentWork, work2);

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
      expect(service.currentWork, work);

      service.stop();
      expect(service.currentWork, isNull);
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

      expect(service.engineState.value, isNot(EngineState.computing));
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

        expect(service.engineState.value, EngineState.error);
      });
    });

    test('Engine name is correctly set after restarting stockfish', () async {
      final fakeStockfish = FakeStockfish(engineName: 'Stockfish 16');
      testBinding.stockfish = fakeStockfish;
      final container = await makeContainer();

      final service = container.read(evaluationServiceProvider);

      final work = makeWork();

      final stream1 = service.evaluate(work);
      expect(stream1, isNotNull);
      await stream1!.first;

      final firstName = await service.engineName;
      expect(firstName, 'Stockfish 16');

      service.quit();

      fakeStockfish.engineName = 'Stockfish 17';

      final stream2 = service.evaluate(work);
      expect(stream2, isNotNull);
      await stream2!.first;

      final secondName = await service.engineName;
      expect(secondName, 'Stockfish 17');
    });
  });
}
