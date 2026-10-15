import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_division.dart';

void main() {
  group('inferLocalGameDivision', () {
    test('marks the opening and middlegame after ten moves', () {
      final root = Root.fromPgnMoves(
        'e4 e5 Nf3 Nc6 Bb5 a6 Ba4 Nf6 O-O Be7 Re1 b5 Bb3 d6 c3 O-O h3 Na5 Bc2 c5 d4',
      );

      expect(inferLocalGameDivision(root.view), const Division(middlegame: 20));
    });

    test('does not add phase markers before the opening is complete', () {
      final root = Root.fromPgnMoves('e4 e5 Nf3 Nc6');

      expect(inferLocalGameDivision(root.view), isNull);
    });

    test('marks the endgame when queens are gone and little material remains', () {
      final moves = '${List.filled(5, 'Kb1 Kg8 Ka1 Kh8').join(' ')} Kb1';
      final root = Root.fromPgnGame(
        PgnGame.parsePgn('[FEN "7k/8/8/8/8/8/8/K7 w - - 0 1"]\n\n$moves'),
      );

      expect(inferLocalGameDivision(root.view), const Division(middlegame: 20, endgame: 21));
    });
  });
}
