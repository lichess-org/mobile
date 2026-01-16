import 'package:dartchess/dartchess.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:multistockfish/multistockfish.dart';

import '../../binding.dart';
import 'fake_stockfish.dart';

void main() {
  // Required to have the mock of Stockfish
  TestLichessBinding.ensureInitialized();

  setUp(() {
    testBinding.stockfish = FakeStockfish();
  });

  group('Engine', () {
    test('Test fake engine', () async {
      final stockfishEngine = StockfishEngine(StockfishFlavor.variant);

      final work = Work(
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 3),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
        threatMode: false,
      );

      final (_, eval) = await stockfishEngine.start(work).first;

      expect(eval.bestMove, const NormalMove(from: Square.e2, to: Square.e4));
    });

    test('Dispose works when engine transitions to error state', () {
      fakeAsync((async) {
        final errorStockfish = ErrorStockfish();
        testBinding.stockfish = errorStockfish;

        final stockfishEngine = StockfishEngine(StockfishFlavor.variant);

        final work = Work(
          variant: Variant.standard,
          threads: 1,
          path: UciPath.empty,
          searchTime: const Duration(seconds: 1),
          multiPv: 1,
          initialPosition: Chess.initial,
          steps: IList(),
          threatMode: false,
        );

        stockfishEngine.start(work);

        async.flushMicrotasks();

        stockfishEngine.dispose();

        async.elapse(const Duration(seconds: 1));

        expect(stockfishEngine.isDisposed, isTrue);
      });
    });
  });
}
