import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';

Position position(String fen) => Chess.fromSetup(Setup.parseFen(fen));

void main() {
  group('hasNonStandardMaterial', () {
    test('the initial position is standard material', () {
      expect(hasNonStandardMaterial(Chess.initial), isFalse);
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
