import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';

import '../../binding.dart';

void main() {
  // Required to have the mock of Stockfish
  TestLichessBinding.ensureInitialized();

  group('Engine', () {
    test('Test fake engine', () async {
      final stockfishEngine = StockfishEngine();

      final work = Work(
        variant: Variant.standard,
        threads: 1,
        path: UciPath.empty,
        searchTime: const Duration(seconds: 3),
        multiPv: 1,
        initialPosition: Chess.initial,
        steps: IList(),
      );

      final (_, eval) = await stockfishEngine.start(work).first;

      expect(eval.bestMove, const NormalMove(from: Square.e2, to: Square.e4));
    });
  });
}
