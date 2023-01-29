import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/features/puzzle/data/puzzle_local_db.dart';
import 'package:lichess_mobile/src/features/puzzle/model/puzzle.dart';
import 'package:lichess_mobile/src/features/puzzle/model/puzzle_theme.dart';

void main() {
  group('PuzzleLocalDB', () {
    test('save and fetch data', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      final db = PuzzleLocalDB(sharedPreferences);

      final data = PuzzleLocalData(
          solved: IList(const [
            PuzzleSolution(id: PuzzleId('pId'), win: true, rated: true),
            PuzzleSolution(id: PuzzleId('pId2'), win: false, rated: true),
          ]),
          unsolved: IList([
            Puzzle(
              puzzle: PuzzleData(
                  id: const PuzzleId('pId3'),
                  rating: 1988,
                  plays: 5,
                  initialPly: 23,
                  solution: IList(const ['a6a7', 'b2a2', 'c4c2']),
                  themes: ISet(const ['endgame', 'advantage'])),
              game: const PuzzleGame(
                  id: GameId('PrlkCqOv'),
                  perf: Perf.blitz,
                  rated: true,
                  white: PuzzlePlayer(
                      side: Side.white, userId: 'user1', name: 'user1'),
                  black: PuzzlePlayer(
                      side: Side.black, userId: 'user2', name: 'user2'),
                  pgn:
                      'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2'),
            ),
          ]));

      await db.save(angle: PuzzleTheme.mix, data: data);

      expect(db.fetch(angle: PuzzleTheme.mix), data);
    });
  });
}
