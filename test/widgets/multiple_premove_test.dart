import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/board.dart';

GameData _game(String fen, Side sideToMove) => GameData(
  fen: fen,
  playerSide: PlayerSide.white,
  sideToMove: sideToMove,
  validMoves: const <Square, Set<Square>>{},
);

NormalMove _move(Square from, Square to) => NormalMove(from: from, to: to);

void main() {
  group('tryExecutePremove with a queue', () {
    late ChessboardController controller;

    setUp(() {
      controller = ChessboardController(game: _game('7k/8/8/8/8/8/6K1/8 b - - 0 1', Side.black))
        ..maxPremoveCount = 4;
    });

    tearDown(() => controller.dispose());

    test('submits only a legal head and keeps the dependent tail', () async {
      final first = _move(Square.g2, Square.f2);
      final second = _move(Square.f2, Square.e2);
      controller
        ..premove = first
        ..premove = second;

      const fen = '8/7k/8/8/8/8/6K1/8 w - - 1 2';
      final position = Chess.fromSetup(Setup.parseFen(fen));
      controller.updatePosition(_game(fen, Side.white), animate: false);

      Move? submitted;
      tryExecutePremove(controller, position, (move) => submitted = move);
      await Future<void>.delayed(Duration.zero);

      expect(submitted, first);
      expect(controller.premove, second);
      expect(controller.premoveQueue, [second]);
    });

    test('clears the dependent queue when the authoritative head is illegal', () async {
      controller
        ..premove = _move(Square.g2, Square.f2)
        ..premove = _move(Square.f2, Square.e2);

      // The opponent's move left one of our own pieces on f2, so g2-f2 can no
      // longer be played even though it was a valid speculative premove before.
      const fen = '7k/8/8/8/8/8/5RK1/8 w - - 1 2';
      final position = Chess.fromSetup(Setup.parseFen(fen));
      controller.updatePosition(_game(fen, Side.white), animate: false);

      Move? submitted;
      tryExecutePremove(controller, position, (move) => submitted = move);
      await Future<void>.delayed(Duration.zero);

      expect(submitted, isNull);
      expect(controller.premove, isNull);
      expect(controller.premoveQueue, isEmpty);
      expect(controller.pieces[Square.f2]?.role, Role.rook);
      expect(controller.pieces[Square.g2]?.role, Role.king);
    });
  });
}
