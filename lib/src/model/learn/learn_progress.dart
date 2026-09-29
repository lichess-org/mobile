import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';
import 'package:lichess_mobile/src/model/learn/learn_repository.dart';
import 'package:lichess_mobile/src/model/learn/learn_score.dart';
import 'package:lichess_mobile/src/model/learn/learn_stages.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

/// The learn scores, per stage key and level index.
///
/// A level without a score has not been completed.
@immutable
class const LearnProgress(final IMap<String, IMap<int, int>> _scores) {
  static const empty = LearnProgress(IMapConst({}));

  /// The best score of the level at [levelIndex] of [stage], or 0 if it was not completed.
  int levelScore(LearnStage stage, int levelIndex) => _scores[stage.key]?[levelIndex] ?? 0;

  /// The scores of each level of [stage], 0 for levels not completed.
  IList<int> stageScores(LearnStage stage) =>
      [for (var i = 0; i < stage.levels.length; i++) levelScore(stage, i)].lock;

  int stageScore(LearnStage stage) => stageScores(stage).fold(0, (a, b) => a + b);

  /// Whether any level of [stage] was completed.
  bool isStageStarted(LearnStage stage) => completedLevels(stage) > 0;

  int completedLevels(LearnStage stage) => stageScores(stage).where((s) => s > 0).length;

  bool isStageComplete(LearnStage stage) => completedLevels(stage) >= stage.levels.length;

  /// The index of the level to play when opening [stage]: the first one not completed, or the first
  /// one if they all are.
  int nextLevelIndex(LearnStage stage) {
    final index = stageScores(stage).indexWhere((s) => s == 0);
    return index == -1 ? 0 : index;
  }

  /// The stage to resume: the first one started but not completed, or, if none is in progress,
  /// the first one not completed.
  ///
  /// Null while nothing is started and once everything is done, so that resuming is only offered
  /// to a user in the middle of the stages.
  LearnStage? get resumeStage {
    if (percent <= 0 || percent >= 100) return null;
    return learnStages.firstWhereOrNull(
          (stage) => isStageStarted(stage) && !isStageComplete(stage),
        ) ??
        learnStages.firstWhereOrNull((stage) => !isStageComplete(stage));
  }

  /// The overall progress, from 0 to 100, computed as on lichess.org.
  int get percent {
    var total = 0;
    for (final stage in learnStages) {
      if (!isStageStarted(stage)) continue;
      total += switch (learnStageRank(stage, stageScores(stage))) {
        1 => 10,
        2 => 8,
        _ => 5,
      };
    }
    return (total / (learnStages.length * 10) * 100).round();
  }

  /// Returns a copy with [score] for the level, if it improves on the saved one.
  LearnProgress withScore(LearnStage stage, int levelIndex, int score) {
    if (levelScore(stage, levelIndex) >= score) return this;
    final stageScores = _scores[stage.key] ?? const IMapConst({});
    return LearnProgress(_scores.add(stage.key, stageScores.add(levelIndex, score)));
  }
}

/// A provider for [LearnProgressStorage].
final learnProgressStorageProvider = FutureProvider<LearnProgressStorage>((Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  return LearnProgressStorage(db);
}, name: 'LearnProgressStorageProvider');

const _tableName = 'learn_progress';

/// Local storage of the learn scores.
///
/// Only improvements are saved: a lower score never overwrites a higher one.
class const LearnProgressStorage(final Database _db) {
  Future<LearnProgress> fetch() async {
    final rows = await _db.query(_tableName, columns: ['stageKey', 'levelId', 'score']);
    final scores = <String, Map<int, int>>{};
    for (final row in rows) {
      final stageKey = row['stageKey']! as String;
      // Level ids start at 1, as on lichess.org.
      final levelIndex = (row['levelId']! as int) - 1;
      (scores[stageKey] ??= {})[levelIndex] = row['score']! as int;
    }
    return LearnProgress(scores.map((key, value) => MapEntry(key, value.lock)).lock);
  }

  Future<void> saveScore({
    required String stageKey,
    required int levelIndex,
    required int score,
  }) async {
    await _db.transaction((txn) async {
      final existing = await txn.query(
        _tableName,
        columns: ['score'],
        where: 'stageKey = ? AND levelId = ?',
        whereArgs: [stageKey, levelIndex + 1],
      );
      final existingScore = existing.firstOrNull?['score'] as int?;
      if (existingScore != null && existingScore >= score) return;
      await txn.insert(_tableName, {
        'stageKey': stageKey,
        'levelId': levelIndex + 1,
        'score': score,
        'lastModified': DateTime.now().toIso8601String(),
        'syncedAt': null,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<void> reset() async {
    await _db.delete(_tableName);
  }

  /// Marks the row as synced, but only if it still holds [score].
  ///
  /// A newer, better score saved while the POST was in flight must stay dirty so that a later
  /// flush uploads it.
  Future<void> markSynced({
    required String stageKey,
    required int levelIndex,
    required int score,
  }) async {
    await _db.update(
      _tableName,
      {'syncedAt': DateTime.now().toIso8601String()},
      where: 'stageKey = ? AND levelId = ? AND score = ?',
      whereArgs: [stageKey, levelIndex + 1, score],
    );
  }
}

/// The learn progress, loaded from local storage.
final learnProgressProvider = AsyncNotifierProvider<LearnProgressNotifier, LearnProgress>(
  LearnProgressNotifier.new,
  name: 'LearnProgressProvider',
);

class LearnProgressNotifier() extends AsyncNotifier<LearnProgress> {
  @override
  Future<LearnProgress> build() async {
    final storage = await ref.watch(learnProgressStorageProvider.future);
    return await storage.fetch();
  }

  /// Saves [score] for the level at [levelIndex] of [stage], if it improves on the saved one.
  ///
  /// Improvements by logged-in users are also pushed to the server in the background. The local
  /// save is the source of truth: sync failures leave the row dirty for a later flush and never
  /// affect level completion.
  Future<void> saveScore(LearnStage stage, int levelIndex, int score) async {
    final current = await future;
    final next = current.withScore(stage, levelIndex, score);
    // Not an improvement: nothing to save, and never POST, since the server keeps whatever it
    // receives and would overwrite a better score with this one.
    if (identical(next, current)) return;
    state = AsyncData(next);
    final storage = await ref.read(learnProgressStorageProvider.future);
    await storage.saveScore(stageKey: stage.key, levelIndex: levelIndex, score: score);
    unawaited(_syncScore(stage.key, levelIndex, score));
  }

  Future<void> reset() async {
    final storage = await ref.read(learnProgressStorageProvider.future);
    await storage.reset();
    state = const AsyncData(LearnProgress.empty);
    unawaited(_syncReset());
  }

  /// Pushes one score to the server, stamping the row when it succeeds.
  ///
  /// Anonymous users have no server progress, and any failure simply leaves the row dirty.
  Future<void> _syncScore(String stageKey, int levelIndex, int score) async {
    if (ref.read(authControllerProvider) == null) return;
    try {
      await ref.withClient(
        (client) =>
            LearnRepository(client)
                .saveScore(stageKey: stageKey, levelId: levelIndex + 1, score: score),
      );
      final storage = await ref.read(learnProgressStorageProvider.future);
      await storage.markSynced(stageKey: stageKey, levelIndex: levelIndex, score: score);
    } catch (_) {
      // Stays dirty (syncedAt null); a later flush uploads it.
    }
  }

  Future<void> _syncReset() async {
    if (ref.read(authControllerProvider) == null) return;
    try {
      await ref.withClient((client) => LearnRepository(client).reset());
    } catch (_) {
      // Local progress is already reset; the server copy converges on the next score upload.
    }
  }
}
