import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

Position position(String fen) => Chess.fromSetup(Setup.parseFen(fen));

void main() {
  group('threatModePosition', () {
    test('clears en passant after a white double pawn push', () {
      final afterE4 = Chess.initial.play(const NormalMove(from: .e2, to: .e4));
      expect(afterE4.epSquare, Square.e3);

      final threat = threatModePosition(afterE4);

      expect(threat.turn, Side.white);
      expect(threat.fen, 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 1 2');
      expect(threat.epSquare, isNull);
      expect(threat.isLegal(const NormalMove(from: .d2, to: .e3)), isFalse);
    });
  });

  group('hasNonStandardMaterial', () {
    test('the initial position is standard material', () {
      expect(hasNonStandardMaterial(Chess.initial), isFalse);
    });

    test('more than 32 pieces is not standard material', () {
      expect(
        hasNonStandardMaterial(
          position('rnbqkbnr/pppppppp/8/8/8/4N3/PPPPPPPP/RNBQKBNR w KQkq - 0 1'),
        ),
        isTrue,
      );
    });

    test('more than eight pawns on either side is not standard material', () {
      expect(hasNonStandardMaterial(position('4k3/8/8/8/8/P7/PPPPPPPP/4K3 w - - 0 1')), isTrue);
      expect(hasNonStandardMaterial(position('4k3/pppppppp/p7/8/8/8/8/4K3 w - - 0 1')), isTrue);
    });

    test('a promoted piece paid for with a pawn is standard material', () {
      // Eight white pieces beyond the king, one of them a second queen that came from a promotion.
      expect(hasNonStandardMaterial(position('4k3/8/8/8/8/8/PPPPPPP1/QQ2K3 w - - 0 1')), isFalse);
    });

    test('a third knight with no pawn spent on it is standard material', () {
      // A knight can be promoted to, and with no pawns left there is a promotion to account for it.
      expect(hasNonStandardMaterial(position('nnnk4/8/8/8/8/8/8/4KNNN w - - 0 1')), isFalse);
    });

    test('a third knight beside a full set of pawns is not standard material', () {
      expect(
        hasNonStandardMaterial(position('nnnk4/pppppppp/8/8/8/8/PPPPPPPP/4KNNN w - - 0 1')),
        isTrue,
      );
    });

    test('a promotion too many for the pawns left is not standard material', () {
      // Eight pawns and a second queen: the queen had nothing to be promoted from.
      expect(hasNonStandardMaterial(position('4k3/8/8/8/8/8/PPPPPPPP/QQ2K3 w - - 0 1')), isTrue);
    });

    test('two bishops on the same colour count as a promotion', () {
      // Light-squared bishops on f1 and h3, so one of them is promoted, and eight pawns to pay
      // for it are one too many.
      expect(hasNonStandardMaterial(position('4k3/8/8/8/8/7B/PPPPPPPP/4KB2 w - - 0 1')), isTrue);
    });

    test('a bishop pair on opposite colours is standard material', () {
      expect(hasNonStandardMaterial(position('4k3/8/8/8/8/8/PPPPPPPP/2B1KB2 w - - 0 1')), isFalse);
    });

    test('material is judged for both sides', () {
      expect(hasNonStandardMaterial(position('qqqqk3/pppppppp/8/8/8/8/8/4K3 w - - 0 1')), isTrue);
    });
  });

  group('engineShortLabel', () {
    test('reads the version from the engine name', () {
      expect(engineShortLabel('Stockfish 19'), 'SF 19');
      expect(engineShortLabel('Stockfish 19.1'), 'SF 19');
    });

    test('names Fairy-Stockfish without its version', () {
      expect(engineShortLabel('Fairy-Stockfish 14.0.1'), 'Fairy SF');
    });

    test('returns null for a name it cannot read', () {
      expect(engineShortLabel(null), isNull);
      expect(engineShortLabel('Lc0 v0.32.1'), isNull);
    });
  });
}
