import 'package:flutter_test/flutter_test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:dartchess/dartchess.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import '../../test_container.dart';

void main() {
  final dbFactory = databaseFactoryFfi;
  sqfliteFfiInit();

  group('PuzzleBatchStorage', () {
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

      final storage = container.read(puzzleBatchStorageProvider);

      await storage.save(userId: null, angle: PuzzleTheme.mix, data: data);

      expect(
        storage.fetch(userId: null, angle: PuzzleTheme.mix),
        completion(equals(data)),
      );
    });

    test('fetchSavedThemes', () async {
      final db = await openDb(dbFactory, inMemoryDatabasePath);

      final container = await makeContainer(
        overrides: [
          databaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
        ],
      );

      final storage = container.read(puzzleBatchStorageProvider);

      await storage.save(userId: null, angle: PuzzleTheme.mix, data: data);
      await storage.save(
        userId: null,
        angle: PuzzleTheme.rookEndgame,
        data: data,
      );
      await storage.save(
        userId: null,
        angle: PuzzleTheme.doubleBishopMate,
        data: data,
      );

      expect(
        storage.fetchSavedThemes(userId: null),
        completion(
          equals(
            ISet(const [
              PuzzleTheme.mix,
              PuzzleTheme.rookEndgame,
              PuzzleTheme.doubleBishopMate,
            ]),
          ),
        ),
      );
    });
  });
}

final data = PuzzleBatch(
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
    ),
  ]),
);
