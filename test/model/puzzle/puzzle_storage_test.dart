import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../test_container.dart';

void main() {
  final dbFactory = databaseFactoryFfi;

  group('PuzzleHistoryStorage', () {
    test('save and fetch data', () async {
      final db = await openAppDatabase(dbFactory, inMemoryDatabasePath);

      final container = await makeContainer(
        overrides: {
          databaseProvider: databaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
        },
      );

      final storage = await container.read(puzzleStorageProvider.future);

      await storage.save(puzzle: puzzle);
      expect(storage.fetch(puzzleId: const PuzzleId('pId3')), completion(equals(puzzle)));
    });
  });
}

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
    white: PuzzleGamePlayer(side: Side.white, name: 'user1'),
    black: PuzzleGamePlayer(side: Side.black, name: 'user2'),
    pgn: 'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2',
  ),
);
