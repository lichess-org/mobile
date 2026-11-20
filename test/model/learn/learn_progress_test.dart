import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/learn/learn_progress.dart';
import 'package:lichess_mobile/src/model/learn/learn_stages.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../test_container.dart';

void main() {
  final rook = learnStageByKey('rook')!;

  group('LearnProgress', () {
    test('keeps the best score', () {
      final progress = LearnProgress.empty
          .withScore(rook, 0, 550)
          .withScore(rook, 0, 350)
          .withScore(rook, 2, 400);
      expect(progress.levelScore(rook, 0), 550);
      expect(progress.stageScores(rook), [550, 0, 400, 0, 0, 0]);
      expect(progress.completedLevels(rook), 2);
      expect(progress.nextLevelIndex(rook), 1);
      expect(progress.isStageComplete(rook), isFalse);
    });

    test('next level wraps around once the stage is complete', () {
      var progress = LearnProgress.empty;
      for (var i = 0; i < rook.levels.length; i++) {
        progress = progress.withScore(rook, i, 100);
      }
      expect(progress.isStageComplete(rook), isTrue);
      expect(progress.nextLevelIndex(rook), 0);
    });

    test('percent', () {
      expect(LearnProgress.empty.percent, 0);
      // A started stage with a low rank counts for half of a perfect one.
      final progress = LearnProgress.empty.withScore(rook, 0, 100);
      expect(progress.percent, (5 / 180 * 100).round());
    });
  });

  group('LearnProgressStorage', () {
    test('saves only improvements, and resets', () async {
      final db = await openAppDatabase(databaseFactoryFfi, inMemoryDatabasePath);
      final container = await makeContainer(
        overrides: {
          databaseProvider: databaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
        },
      );

      final storage = await container.read(learnProgressStorageProvider.future);
      await storage.saveScore(stageKey: 'rook', levelIndex: 0, score: 550);
      await storage.saveScore(stageKey: 'rook', levelIndex: 0, score: 300);
      await storage.saveScore(stageKey: 'rook', levelIndex: 1, score: 400);

      final progress = await storage.fetch();
      expect(progress.stageScores(rook), [550, 400, 0, 0, 0, 0]);

      final rows = await db.query('learn_progress', orderBy: 'levelId');
      expect(rows.map((r) => r['levelId']), [1, 2], reason: 'level ids start at 1');

      await storage.reset();
      expect((await storage.fetch()).stageScores(rook), [0, 0, 0, 0, 0, 0]);
    });

    test('the notifier updates its state', () async {
      final db = await openAppDatabase(databaseFactoryFfi, inMemoryDatabasePath);
      final container = await makeContainer(
        overrides: {
          databaseProvider: databaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
        },
      );

      await container.read(learnProgressProvider.future);
      await container.read(learnProgressProvider.notifier).saveScore(rook, 3, 500);
      expect(container.read(learnProgressProvider).value!.levelScore(rook, 3), 500);

      await container.read(learnProgressProvider.notifier).reset();
      expect(container.read(learnProgressProvider).value!.levelScore(rook, 3), 0);
    });
  });
}
