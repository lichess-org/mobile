import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/learn/learn_position.dart';

int perft(LearnPosition pos, int depth) {
  if (depth < 1) return 1;
  var nodes = 0;
  for (final move in pos.moves()) {
    final isPromotion = pos.board.pawns.has(move.from) && SquareSet.backranks.has(move.to);
    if (isPromotion) {
      for (final role in [Role.queen, Role.rook, Role.bishop, Role.knight]) {
        final after = pos.playUnchecked(move.withPromotion(role));
        nodes += depth == 1 ? 1 : perft(after, depth - 1);
      }
    } else {
      nodes += depth == 1 ? 1 : perft(pos.playUnchecked(move), depth - 1);
    }
  }
  return nodes;
}

void main() {
  group('perft', () {
    test('initial position', () {
      final pos = LearnPosition.fromFen(kInitialFEN);
      expect(perft(pos, 1), 20);
      expect(perft(pos, 2), 400);
      expect(perft(pos, 3), 8902);
      expect(perft(pos, 4), 197281);
    });

    test('kiwipete', () {
      final pos = LearnPosition.fromFen(
        'r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq -',
      );
      expect(perft(pos, 1), 48);
      expect(perft(pos, 2), 2039);
      expect(perft(pos, 3), 97862);
    });

    test('position 3', () {
      final pos = LearnPosition.fromFen('8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - -');
      expect(perft(pos, 1), 14);
      expect(perft(pos, 2), 191);
      expect(perft(pos, 3), 2812);
      expect(perft(pos, 4), 43238);
    });

    test('position 4', () {
      final pos = LearnPosition.fromFen(
        'r3k2r/Pppp1ppp/1b3nbN/nP6/BBP1P3/q4N2/Pp1P2PP/R2Q1RK1 w kq -',
      );
      expect(perft(pos, 1), 6);
      expect(perft(pos, 2), 264);
      expect(perft(pos, 3), 9467);
    });

    test('position 5', () {
      final pos = LearnPosition.fromFen('rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ -');
      expect(perft(pos, 1), 44);
      expect(perft(pos, 2), 1486);
      expect(perft(pos, 3), 62379);
    });

    test('en passant pinned along the rank', () {
      final pos = LearnPosition.fromFen('8/8/8/K1pP3r/8/8/8/7k w - c6');
      expect(pos.destsOf(Square.d5).has(Square.c6), isFalse);
    });
  });

  group('differential against dartchess', () {
    // Positions with two kings, where dartchess is the oracle. The walk visits every position
    // reachable in a few plies, so castling rights, en passant and promotions all come up.
    const fens = [
      kInitialFEN,
      'r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq -',
      'rnbqkbnr/pppppppp/8/8/2B5/4PN2/PPPP1PPP/RNBQK2R w KQkq -',
      'rn1qkbnr/ppp1pppp/3p4/8/2b5/4PN2/PPPP1PPP/RNBQK2R w KQkq -',
      'rnb2rk1/pppppppp/8/8/8/4Nb1n/PPPP1P1P/RNB1KB1R w KQkq -',
      '1r1k2nr/p2ppppp/7b/7b/4P3/2nP4/P1P2P2/RN2K3 w Q -',
      'rnbqkbnr/ppp1pppp/8/2Pp3P/8/8/PP1PPPP1/RNBQKBNR w KQkq d6',
      'r1bqkb1r/pppp1p1p/2n2np1/4p3/2B5/4PN2/PPPP1PPP/RNBQK2R w KQkq -',
      '4k3/6p1/5p2/p4P2/PpB2N2/1K6/8/3R4 w - -',
    ];

    void walk(LearnPosition learn, Position chess, int depth) {
      for (final square in Square.values) {
        expect(
          learn.destsOf(square),
          chess.legalMovesOf(square),
          reason: '${chess.fen} from $square',
        );
      }
      expect(learn.isCheck, chess.isCheck, reason: chess.fen);
      expect(learn.isCheckmate, chess.isCheckmate, reason: chess.fen);
      if (depth == 0) return;
      for (final move in learn.moves()) {
        final isPromotion = learn.board.pawns.has(move.from) && SquareSet.backranks.has(move.to);
        final played = isPromotion ? move.withPromotion(Role.queen) : move;
        walk(learn.playUnchecked(played), chess.play(played), depth - 1);
      }
    }

    for (final fen in fens) {
      test(fen, () {
        walk(LearnPosition.fromFen(fen), Chess.fromSetup(Setup.parseFen(fen)), 2);
      });
    }
  });

  group('kingless positions', () {
    test('a lone rook moves freely', () {
      final pos = LearnPosition.fromFen('8/8/8/8/8/8/4R3/8 w - -');
      expect(pos.destsOf(Square.e2).size, 14);
      expect(pos.isCheck, isFalse);
      expect(pos.isCheckmate, isFalse);
    });

    test('captures are not forced', () {
      final pos = LearnPosition.fromFen('8/2p2p2/8/8/8/2R5/8/8 w - -');
      expect(pos.destsOf(Square.c3).has(Square.c4), isTrue);
    });

    test('a king without an enemy king still cannot walk into check', () {
      final pos = LearnPosition.fromFen('8/8/8/4q3/8/8/8/4K3 w - -');
      expect(pos.isCheck, isTrue);
      expect(
        pos.destsOf(Square.e1),
        SquareSet.fromSquares(const [Square.d1, Square.d2, Square.f1, Square.f2]),
      );
    });

    test('illegal dests keep self-checks', () {
      final pos = LearnPosition.fromFen('8/8/8/4q3/8/8/8/4K3 w - -');
      expect(pos.destsOf(Square.e1, illegal: true).size, 5);
    });
  });

  group('play', () {
    test('castling with the king two squares or onto the rook', () {
      final pos = LearnPosition.fromFen('rnbqkbnr/pppppppp/8/8/2B5/4PN2/PPPP1PPP/RNBQK2R w KQkq -');
      for (final to in [Square.g1, Square.h1]) {
        final move = NormalMove(from: Square.e1, to: to);
        expect(pos.castlingSideOf(move), CastlingSide.king);
        final after = pos.playUnchecked(move);
        expect(after.board.pieceAt(Square.g1), Piece.whiteKing);
        expect(after.board.pieceAt(Square.f1), Piece.whiteRook);
        expect(after.castles.rookOf(Side.white, CastlingSide.queen), isNull);
      }
    });

    test('en passant captures the pawn behind the ep square', () {
      final pos = LearnPosition.fromFen('rnbqkbnr/ppp1pppp/8/2Pp4/8/8/PP1PPPPP/RNBQKBNR w KQkq d6');
      const move = NormalMove(from: Square.c5, to: Square.d6);
      expect(pos.capturedPieceOf(move), Piece.blackPawn);
      expect(pos.playUnchecked(move).board.pieceAt(Square.d5), isNull);
    });

    test('withTurn drops the en passant square', () {
      final pos = LearnPosition.fromFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -')
          .playUnchecked(const NormalMove(from: Square.e2, to: Square.e4));
      expect(pos.epSquare, Square.e3);
      expect(pos.withTurn(Side.white).epSquare, isNull);
    });
  });
}
