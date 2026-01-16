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
  // Required to have the mock of Stockfish
  TestLichessBinding.ensureInitialized();

  setUp(() {
    testBinding.stockfish = FakeStockfish();
  });

  group('EvaluationService', () {
    test('Test engine evaluation with fake stockfish', () async {
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

    test('Stop evaluation clears current work', () async {
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

      // After stop, the engine should be idle
      expect(service.engineState.value, isNot(EngineState.computing));
    });
  });
}
