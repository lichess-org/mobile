import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
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
      await storage.saveScore(userId: null, stageKey: 'rook', levelIndex: 0, score: 550);
      await storage.saveScore(userId: null, stageKey: 'rook', levelIndex: 0, score: 300);
      await storage.saveScore(userId: null, stageKey: 'rook', levelIndex: 1, score: 400);

      final progress = await storage.fetch(null);
      expect(progress.stageScores(rook), [550, 400, 0, 0, 0, 0]);

      final rows = await db.query('learn_progress', orderBy: 'levelId');
      expect(rows.map((r) => r['levelId']), [1, 2], reason: 'level ids start at 1');

      await storage.reset(null);
      expect((await storage.fetch(null)).stageScores(rook), [0, 0, 0, 0, 0, 0]);
    });

    test('keeps each account separate', () async {
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
      const alice = UserId('alice');
      const bob = UserId('bob');

      await storage.saveScore(userId: alice, stageKey: 'rook', levelIndex: 0, score: 700);
      await storage.saveScore(userId: bob, stageKey: 'rook', levelIndex: 0, score: 200);

      expect((await storage.fetch(alice)).levelScore(rook, 0), 700);
      expect((await storage.fetch(bob)).levelScore(rook, 0), 200);
      // The anonymous bucket is its own account, not a fallback for signed-in users.
      expect((await storage.fetch(null)).levelScore(rook, 0), 0);

      // Alice's reset must not touch Bob's rows.
      await storage.reset(alice);
      expect((await storage.fetch(alice)).levelScore(rook, 0), 0);
      expect((await storage.fetch(bob)).levelScore(rook, 0), 200);
    });

    test('tracks a reset waiting to reach the server', () async {
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
      const alice = UserId('alice');
      const bob = UserId('bob');

      expect(await storage.isResetPending(alice), isFalse);
      await storage.setResetPending(alice, pending: true);
      expect(await storage.isResetPending(alice), isTrue);
      // Per account: Bob's reset state is untouched by Alice's.
      expect(await storage.isResetPending(bob), isFalse);
      await storage.setResetPending(alice, pending: false);
      expect(await storage.isResetPending(alice), isFalse);
    });

    test('quarantines a level the server refused, keeping the score', () async {
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
      const alice = UserId('alice');

      // A stage lila knows but this build does not: the level was really completed, so the score
      // has to survive the refusal to upload it.
      await storage.saveScore(userId: alice, stageKey: 'pins', levelIndex: 0, score: 500);
      expect(await storage.fetchUnsynced(alice), hasLength(1));

      await storage.quarantine(userId: alice, stageKey: 'pins', levelIndex: 0);
      // Not posted again...
      expect(await storage.fetchUnsynced(alice), isEmpty);
      // ...but the row and the score are still there. It stays in the database rather than being
      // deleted, so a build that does know the stage can still show and upload it.
      final rows = await db.query('learn_progress');
      expect(rows, hasLength(1));
      expect(rows.single['score'], 500);
      expect(rows.single['stageKey'], 'pins');
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
