import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_progress.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../test_container.dart';

void main() {
  Map<String, dynamic> chapter(String id) => {
    'id': id,
    'name': id,
    'kind': 'practice',
    'orientation': 'white',
    'fen': '8/8/3k4/8/8/4K3/8/Q6R w - - 0 1',
    'goal': {'result': 'mate'},
  };

  final structure = PracticeStructure.fromJson({
    'sections': [
      {
        'id': 'checkmates',
        'name': 'Checkmates',
        'studies': [
          {
            'id': 'study1',
            'slug': 'study-one',
            'name': 'Study one',
            'chapters': [chapter('chapter1'), chapter('chapter2'), chapter('chapter3')],
          },
          {
            'id': 'study2',
            'slug': 'study-two',
            'name': 'Study two',
            'chapters': [chapter('chapter4')],
          },
        ],
      },
    ],
  });
  final study1 = structure.study(const PracticeStudyId('study1'))!;

  const chapter1 = PracticeChapterId('chapter1');
  const chapter2 = PracticeChapterId('chapter2');
  const chapter3 = PracticeChapterId('chapter3');
  const removed = PracticeChapterId('removed1');

  group('PracticeProgress', () {
    test('keeps the fewest moves', () {
      final progress = PracticeProgress.empty
          .withNbMoves(chapter1, 5)
          .withNbMoves(chapter1, 7)
          .withNbMoves(chapter1, 3);
      expect(progress.nbMoves(chapter1), 3);
      expect(progress.nbMoves(chapter2), isNull);
      expect(progress.isDone(chapter1), isTrue);
      expect(progress.isDone(chapter2), isFalse);
    });

    test('a chapter completed in 0 moves is done', () {
      expect(PracticeProgress.empty.withNbMoves(chapter1, 0).isDone(chapter1), isTrue);
    });

    test('counts done chapters per study', () {
      final progress = PracticeProgress.empty.withNbMoves(chapter1, 2).withNbMoves(chapter3, 4);
      expect(progress.countDone(study1), 2);
      expect(progress.isStudyComplete(study1), isFalse);
      expect(progress.withNbMoves(chapter2, 1).isStudyComplete(study1), isTrue);
    });

    test('first ongoing chapter wraps around once the study is complete', () {
      var progress = PracticeProgress.empty;
      expect(progress.firstOngoingIn(study1).id, chapter1);

      progress = progress.withNbMoves(chapter1, 2).withNbMoves(chapter3, 2);
      expect(progress.firstOngoingIn(study1).id, chapter2);

      progress = progress.withNbMoves(chapter2, 2);
      expect(progress.firstOngoingIn(study1).id, chapter1);
    });

    test('percent is rounded down and ignores unknown chapters', () {
      expect(PracticeProgress.empty.percent(structure), 0);

      final progress = PracticeProgress.empty.withNbMoves(chapter1, 2).withNbMoves(removed, 1);
      expect(progress.percent(structure), 25);
      expect(progress.withNbMoves(chapter2, 1).percent(structure), 50);
      expect(progress.withNbMoves(chapter2, 1).withNbMoves(chapter3, 1).percent(structure), 75);
    });
  });

  group('PracticeProgressStorage', () {
    Future<(ProviderContainer, Database)> makeStorageContainer() async {
      final db = await openAppDatabase(databaseFactoryFfi, inMemoryDatabasePath);
      final container = await makeContainer(
        overrides: {
          databaseProvider: databaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
        },
      );
      return (container, db);
    }

    test('saves only improvements, and resets', () async {
      final (container, db) = await makeStorageContainer();

      final storage = await container.read(practiceProgressStorageProvider.future);
      await storage.save(chapterId: chapter1, nbMoves: 4);
      await storage.save(chapterId: chapter1, nbMoves: 6);
      await storage.save(chapterId: chapter2, nbMoves: 0);

      final progress = await storage.fetch();
      expect(progress.nbMoves(chapter1), 4);
      expect(progress.nbMoves(chapter2), 0);

      final rows = await db.query('practice_progress', orderBy: 'chapterId');
      expect(rows.map((r) => r['syncedAt']), [null, null], reason: 'nothing is synced yet');

      await storage.save(chapterId: chapter1, nbMoves: 2);
      expect((await storage.fetch()).nbMoves(chapter1), 2);

      await storage.reset();
      expect((await storage.fetch()).isDone(chapter1), isFalse);
    });

    test('the notifier updates its state', () async {
      final (container, _) = await makeStorageContainer();

      await container.read(practiceProgressProvider.future);
      final notifier = container.read(practiceProgressProvider.notifier);

      await notifier.complete(chapter1, 3);
      await notifier.complete(chapter1, 5);
      expect(container.read(practiceProgressProvider).value!.nbMoves(chapter1), 3);

      // The state is what was persisted.
      final storage = await container.read(practiceProgressStorageProvider.future);
      expect((await storage.fetch()).nbMoves(chapter1), 3);

      await notifier.reset();
      expect(container.read(practiceProgressProvider).value!.isDone(chapter1), isFalse);
    });
  });
}
