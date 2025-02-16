import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:sqflite/sqflite.dart';

import '../../test_container.dart';

void main() {
  group('PuzzleBatchStorage', () {
    test('save and fetch data', () async {
      final container = await makeContainer();

      final storage = await container.read(puzzleBatchStorageProvider.future);

      await storage.save(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix), data: data);

      expect(
        storage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
        completion(equals(data)),
      );
    });

    test('fetchSavedThemes', () async {
      final container = await makeContainer();

      final storage = await container.read(puzzleBatchStorageProvider.future);

      await storage.save(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix), data: data);
      await storage.save(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.rookEndgame),
        data: data,
      );
      await storage.save(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.doubleBishopMate),
        data: data,
      );

      expect(
        storage.fetchSavedThemes(userId: null),
        completion(
          equals(
            IMap(const {
              PuzzleThemeKey.mix: 1,
              PuzzleThemeKey.rookEndgame: 1,
              PuzzleThemeKey.doubleBishopMate: 1,
            }),
          ),
        ),
      );
    });

    test('fetchSavedOpenings', () async {
      final container = await makeContainer();

      final storage = await container.read(puzzleBatchStorageProvider.future);

      await storage.save(userId: null, angle: const PuzzleOpening('test_opening'), data: data);
      await storage.save(userId: null, angle: const PuzzleOpening('test_opening2'), data: data);

      expect(
        storage.fetchSavedOpenings(userId: null),
        completion(equals(IMap(const {'test_opening': 1, 'test_opening2': 1}))),
      );
    });

    test('fetchAll', () async {
      final container = await makeContainer();

      final database = await container.read(databaseProvider.future);
      final storage = await container.read(puzzleBatchStorageProvider.future);

      Future<void> save(PuzzleAngle angle, PuzzleBatch data, String timestamp) {
        return database.insert('puzzle_batchs', {
          'userId': '**anon**',
          'angle': angle.key,
          'data': jsonEncode(data.toJson()),
          'lastModified': timestamp,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await save(const PuzzleTheme(PuzzleThemeKey.rookEndgame), data, '2021-01-02T00:00:00Z');
      await save(const PuzzleTheme(PuzzleThemeKey.doubleBishopMate), data, '2021-01-03T00:00:00Z');
      await save(const PuzzleOpening('test_opening'), data, '2021-01-04T00:00:00Z');
      await save(const PuzzleOpening('test_opening2'), data, '2021-01-04T80:00:00Z');

      expect(
        storage.fetchAll(userId: null),
        completion(
          equals(
            [
              const PuzzleOpening('test_opening2'),
              const PuzzleOpening('test_opening'),
              const PuzzleTheme(PuzzleThemeKey.doubleBishopMate),
              const PuzzleTheme(PuzzleThemeKey.rookEndgame),
            ].map((angle) => (angle, 1)).toIList(),
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
        white: PuzzleGamePlayer(side: Side.white, name: 'user1'),
        black: PuzzleGamePlayer(side: Side.black, name: 'user2'),
        pgn: 'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2',
      ),
    ),
  ]),
);
