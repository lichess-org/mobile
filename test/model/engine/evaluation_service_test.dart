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

void main() {
  TestLichessBinding.ensureInitialized();

  setUp(() {
    testBinding.stockfish = FakeStockfish();
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
      testBinding.stockfish = FakeStockfish(engineName: 'Stockfish 16');
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

      final stream1 = service.evaluate(work);
      expect(stream1, isNotNull);
      await stream1!.first;

      final firstName = await service.engineName;
      expect(firstName, 'Stockfish 16');

      service.quit();

      testBinding.stockfish = FakeStockfish(engineName: 'Stockfish 17');

      final stream2 = service.evaluate(work);
      expect(stream2, isNotNull);
      await stream2!.first;

      final secondName = await service.engineName;
      expect(secondName, 'Stockfish 17');
    });
  });
}
