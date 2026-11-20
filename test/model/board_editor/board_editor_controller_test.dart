import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

void main() {
  ProviderContainer makeContainer(BoardEditorControllerParams? params) {
    final container = ProviderContainer();
    final subscription = container.listen(boardEditorControllerProvider(params), (_, _) {});
    addTearDown(subscription.close);
    addTearDown(container.dispose);
    return container;
  }

  group('BoardEditorController', () {
    // Black is in check while it is White's turn: the FEN is valid, but the
    // position it describes is illegal, so `Position.setupPosition` rejects it.
    const illegalPositionFen = 'r3k2r/8/8/8/8/4Q3/8/R3K2R w KQkq - 0 1';

    test('loads a FEN whose position is illegal', () {
      final container = makeContainer(null);
      final provider = boardEditorControllerProvider(null);

      container.read(provider.notifier).loadFen(illegalPositionFen);

      final state = container.read(provider);
      expect(state.pieces, readFen(illegalPositionFen).lock);
      expect(state.sideToPlay, Side.white);
      expect(state.castlingRights.values, everyElement(isTrue));
      expect(state.fen, illegalPositionFen);
      // The position is still not playable, so it cannot be analyzed.
      expect(state.pgn, isNull);
    });

    test('opens with an initial FEN whose position is illegal', () {
      const params = (
        initialVariant: Variant.standard,
        initialFen: illegalPositionFen,
        initialOrientation: null,
      );
      final container = makeContainer(params);

      expect(container.read(boardEditorControllerProvider(params)).fen, illegalPositionFen);
    });

    test('drops the castling rights of a rook that is missing', () {
      final container = makeContainer(null);
      final provider = boardEditorControllerProvider(null);

      container.read(provider.notifier).loadFen('4k3/8/8/8/8/8/8/R3K3 w KQkq - 0 1');

      final state = container.read(provider);
      expect(state.castlingRights[CastlingRight.whiteQueen], isTrue);
      expect(state.castlingRights[CastlingRight.whiteKing], isFalse);
      expect(state.castlingRights[CastlingRight.blackQueen], isFalse);
      expect(state.castlingRights[CastlingRight.blackKing], isFalse);
    });

    test('antichess positions have no castling rights', () {
      final params = (
        initialVariant: Variant.antichess,
        initialFen: Variant.standard.initialPosition.fen,
        initialOrientation: null,
      );
      final container = makeContainer(params);

      final state = container.read(boardEditorControllerProvider(params));
      expect(state.castlingRights.values, everyElement(isFalse));
    });
  });
}
