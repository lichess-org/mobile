import 'package:flutter_test/flutter_test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:dartchess/dartchess.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_history_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import '../../test_container.dart';

void main() {
  final dbFactory = databaseFactoryFfi;
  sqfliteFfiInit();

  group('PuzzleHistoryStorage', () {
    test('save and fetch data', () async {
      final db = await openDb(dbFactory, inMemoryDatabasePath);

      final container = await makeContainer(
        overrides: [
          databaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
        ],
      );

      final storage = container.read(puzzleHistoryStorageProvider);

      await storage.save(
        userId: null,
        angle: PuzzleTheme.mix,
        result: true,
        puzzle: puzzle,
      );
      expect(
        storage.fetchPuzzleHistoryPage(
          userId: null,
          page: 0,
        ),
        completion(equals([historyDay])),
      );

      expect(
        storage.fetchPuzzle(
          puzzleId: const PuzzleId('pId3'),
        ),
        completion(equals(puzzle)),
      );

      expect(
        storage.fetchRecent(userId: null),
        completion(
          equals([historyDay]),
        ),
      );
    });
  });
}

final now = DateTime.now();
final dayOnly = DateTime(now.year, now.month, now.day);

final historyDay = PuzzleHistoryDay(
  puzzles: IList([PuzzleAndResult(puzzle: puzzle, result: true)]),
  angle: PuzzleTheme.mix,
  day: dayOnly,
);

final puzzle = Puzzle(
  puzzle: PuzzleData(
    id: const PuzzleId('pId3'),
    rating: 1988,
    plays: 5,
    initialPly: 23,
    solution: IList(const ['a6a7', 'b2a2', 'c4c2']),
    themes: ISet(const ['endgame', 'advantage']),
  ),
  game: const PuzzleGame(
    id: GameId('PrlkCqOv'),
    perf: Perf.blitz,
    rated: true,
    white: PuzzleGamePlayer(
      side: Side.white,
      userId: UserId('user1'),
      name: 'user1',
    ),
    black: PuzzleGamePlayer(
      side: Side.black,
      userId: UserId('user2'),
      name: 'user2',
    ),
    pgn: 'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2',
  ),
);
