import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

/// The practice chapters completed, each with the fewest moves it was completed in.
///
/// A chapter is done as soon as it has an entry. Ids unknown to the [PracticeStructure] (a chapter
/// removed from lichess.org since it was completed) are kept but never counted.
@immutable
class const PracticeProgress(final IMap<StudyChapterId, int> _nbMoves) {
  static const empty = PracticeProgress(IMapConst({}));

  /// Whether no chapter was completed.
  bool get isEmpty => _nbMoves.isEmpty;

  /// The fewest moves [chapterId] was completed in, or null if it was not completed.
  int? nbMoves(StudyChapterId chapterId) => _nbMoves[chapterId];

  bool isDone(StudyChapterId chapterId) => _nbMoves.containsKey(chapterId);

  int countDone(PracticeStudy study) =>
      study.chapters.where((chapter) => isDone(chapter.id)).length;

  bool isStudyComplete(PracticeStudy study) => countDone(study) >= study.chapters.length;

  /// The chapter to open when entering [study]: the first one not completed, or the first one if
  /// they all are.
  PracticeChapter firstOngoingIn(PracticeStudy study) => study.chapters.firstWhere(
    (chapter) => !isDone(chapter.id),
    orElse: () => study.chapters.first,
  );

  /// The overall progress, from 0 to 100, rounded down as on lichess.org.
  int percent(PracticeStructure structure) {
    if (structure.nbChapters == 0) return 0;
    final done = structure.sections
        .expand((section) => section.studies)
        .fold(0, (sum, study) => sum + countDone(study));
    return done * 100 ~/ structure.nbChapters;
  }

  /// Returns a copy with [chapterId] completed in [nbMoves], if it improves on the saved count.
  ///
  /// Keeping the minimum is also what lichess.org does, so merging with a server copy converges.
  PracticeProgress withNbMoves(StudyChapterId chapterId, int nbMoves) {
    final current = _nbMoves[chapterId];
    if (current != null && current <= nbMoves) return this;
    return PracticeProgress(_nbMoves.add(chapterId, nbMoves));
  }
}

/// A provider for [PracticeProgressStorage].
final practiceProgressStorageProvider = FutureProvider<PracticeProgressStorage>((Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  return PracticeProgressStorage(db);
}, name: 'PracticeProgressStorageProvider');

const _tableName = 'practice_progress';

/// Local storage of the practice progress.
///
/// Only improvements are saved: a higher move count never overwrites a lower one.
class const PracticeProgressStorage(final Database _db) {
  Future<PracticeProgress> fetch() async {
    final rows = await _db.query(_tableName, columns: ['chapterId', 'nbMoves']);
    return PracticeProgress(
      {for (final row in rows) StudyChapterId(row['chapterId']! as String): row['nbMoves']! as int}
          .lock,
    );
  }

  Future<void> save({required StudyChapterId chapterId, required int nbMoves}) async {
    await _db.transaction((txn) async {
      final existing = await txn.query(
        _tableName,
        columns: ['nbMoves'],
        where: 'chapterId = ?',
        whereArgs: [chapterId.value],
      );
      final existingNbMoves = existing.firstOrNull?['nbMoves'] as int?;
      if (existingNbMoves != null && existingNbMoves <= nbMoves) return;
      await txn.insert(_tableName, {
        'chapterId': chapterId.value,
        'nbMoves': nbMoves,
        'lastModified': DateTime.now().toIso8601String(),
        'syncedAt': null,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<void> reset() async {
    await _db.delete(_tableName);
  }
}

/// The practice progress, loaded from local storage.
final practiceProgressProvider = AsyncNotifierProvider<PracticeProgressNotifier, PracticeProgress>(
  PracticeProgressNotifier.new,
  name: 'PracticeProgressProvider',
);

class PracticeProgressNotifier() extends AsyncNotifier<PracticeProgress> {
  @override
  Future<PracticeProgress> build() async {
    final storage = await ref.watch(practiceProgressStorageProvider.future);
    return await storage.fetch();
  }

  /// Records [chapterId] as completed in [nbMoves], if it improves on the saved count.
  Future<void> complete(StudyChapterId chapterId, int nbMoves) async {
    final current = await future;
    state = AsyncData(current.withNbMoves(chapterId, nbMoves));
    final storage = await ref.read(practiceProgressStorageProvider.future);
    await storage.save(chapterId: chapterId, nbMoves: nbMoves);
  }

  Future<void> reset() async {
    final storage = await ref.read(practiceProgressStorageProvider.future);
    await storage.reset();
    state = const AsyncData(PracticeProgress.empty);
  }
}
