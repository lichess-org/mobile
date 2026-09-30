import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';
import 'package:lichess_mobile/src/model/learn/learn_repository.dart';
import 'package:lichess_mobile/src/model/learn/learn_score.dart';
import 'package:lichess_mobile/src/model/learn/learn_stages.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
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

  /// Returns a copy where each level holds the best score of this progress and the [server]
  /// scores, keyed by stage key and level index.
  LearnProgress mergedWithServer(IMap<String, IMap<int, int>> server) {
    var merged = this;
    for (final stageEntry in server.entries) {
      final stage = learnStageByKey(stageEntry.key);
      if (stage == null) continue;
      for (final levelEntry in stageEntry.value.entries) {
        if (levelEntry.key >= 0 && levelEntry.key < stage.levels.length) {
          merged = merged.withScore(stage, levelEntry.key, levelEntry.value);
        }
      }
    }
    return merged;
  }
}

/// The [server] scores this app version can store and display: a stage it knows, a level within
/// that stage, and a positive score.
///
/// Applied before anything is written, so a malformed or outdated payload cannot leave rows that
/// are stored and re-POSTed on every start. It also empties the map for a payload the build
/// cannot make sense of, which is indistinguishable from "no progress": callers must not read
/// an empty result as a reset.
IMap<String, IMap<int, int>> _validServerScores(IMap<String, IMap<int, int>> server) {
  return {
    for (final stageEntry in server.entries)
      if (learnStageByKey(stageEntry.key) case final stage?)
        stageEntry.key: {
          for (final levelEntry in stageEntry.value.entries)
            if (levelEntry.key >= 0 && levelEntry.key < stage.levels.length && levelEntry.value > 0)
              levelEntry.key: levelEntry.value,
        }.lock,
  }.lock;
}

/// A provider for [LearnProgressStorage].
final learnProgressStorageProvider = FutureProvider<LearnProgressStorage>((Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  return LearnProgressStorage(db);
}, name: 'LearnProgressStorageProvider');

const _tableName = 'learn_progress';
const _stateTableName = 'learn_sync_state';

/// A score the server has not accepted yet, identified by its level.
typedef LearnUnsyncedRef = ({String stageKey, int levelIndex});

/// The outcome of posting one score.
enum _PushResult() {
  /// The server has it.
  ok,

  /// A transient failure. The row stays dirty and is retried.
  retry,

  /// The server refused the payload itself, so posting it again cannot succeed.
  rejected,
}

/// Whether a status code means the score payload is wrong, rather than the request being
/// temporarily unacceptable.
///
/// 401 is excluded because `LichessClient` treats it as an expired token and retries, 403 because
/// the scope can be re-granted, and 408/429 because they are throttling and timeouts.
bool _isPermanentRejection(int statusCode) =>
    statusCode == 400 || statusCode == 404 || statusCode == 422;

String _accountKey(UserId? userId) => userId?.value ?? kStorageAnonId;

/// The learn scores held locally, scoped to one account.
///
/// Only improvements are saved: a lower score never overwrites a higher one.
class const LearnProgressStorage(final Database _db) {
  Future<LearnProgress> fetch(UserId? userId) async {
    final rows = await _db.query(
      _tableName,
      columns: ['stageKey', 'levelId', 'score'],
      where: 'userId = ?',
      whereArgs: [_accountKey(userId)],
    );
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
    required UserId? userId,
    required String stageKey,
    required int levelIndex,
    required int score,
  }) async {
    await _db.transaction((txn) async {
      final existing = await txn.query(
        _tableName,
        columns: ['score'],
        where: 'userId = ? AND stageKey = ? AND levelId = ?',
        whereArgs: [_accountKey(userId), stageKey, levelIndex + 1],
      );
      final existingScore = existing.firstOrNull?['score'] as int?;
      if (existingScore != null && existingScore >= score) return;
      await txn.insert(_tableName, {
        'userId': _accountKey(userId),
        'stageKey': stageKey,
        'levelId': levelIndex + 1,
        'score': score,
        'lastModified': DateTime.now().toIso8601String(),
        'syncedAt': null,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  /// The current score of a level, or null if the level has no row.
  Future<int?> fetchScore({
    required UserId? userId,
    required String stageKey,
    required int levelIndex,
  }) async {
    final rows = await _db.query(
      _tableName,
      columns: ['score'],
      where: 'userId = ? AND stageKey = ? AND levelId = ?',
      whereArgs: [_accountKey(userId), stageKey, levelIndex + 1],
    );
    return rows.firstOrNull?['score'] as int?;
  }

  /// Stamps a row the server permanently refused, so it is never posted again.
  ///
  /// The score is kept: the level really was completed, and the usual cause of a refusal is that
  /// lila does not know this stage or level. Only the upload is given up on. A build that does
  /// know the stage can leave the row dirty again to retry it.
  Future<void> quarantine({
    required UserId? userId,
    required String stageKey,
    required int levelIndex,
  }) async {
    await _db.update(
      _tableName,
      {'syncedAt': DateTime.now().toIso8601String()},
      where: 'userId = ? AND stageKey = ? AND levelId = ?',
      whereArgs: [_accountKey(userId), stageKey, levelIndex + 1],
    );
  }

  /// The scores the server has not accepted yet.
  ///
  /// Only the keys: the score must be read again right before the POST, see [fetchScore].
  Future<IList<LearnUnsyncedRef>> fetchUnsynced(UserId? userId) async {
    final rows = await _db.query(
      _tableName,
      columns: ['stageKey', 'levelId'],
      where: 'userId = ? AND syncedAt IS NULL',
      whereArgs: [_accountKey(userId)],
    );
    return [
      for (final row in rows)
        (
          stageKey: row['stageKey']! as String,
          // Level ids start at 1, as on lichess.org.
          levelIndex: (row['levelId']! as int) - 1,
        ),
    ].lock;
  }

  Future<void> reset(UserId? userId) async {
    await _db.delete(_tableName, where: 'userId = ?', whereArgs: [_accountKey(userId)]);
  }

  /// Marks the row as synced, but only if it still holds [score].
  ///
  /// A newer, better score saved while the POST was in flight must stay dirty so that a later
  /// flush uploads it.
  Future<void> markSynced({
    required UserId? userId,
    required String stageKey,
    required int levelIndex,
    required int score,
  }) async {
    await _db.update(
      _tableName,
      {'syncedAt': DateTime.now().toIso8601String()},
      where: 'userId = ? AND stageKey = ? AND levelId = ? AND score = ?',
      whereArgs: [_accountKey(userId), stageKey, levelIndex + 1, score],
    );
  }

  /// Whether a reset of [userId] is still waiting to reach the server.
  Future<bool> isResetPending(UserId? userId) async {
    final rows = await _db.query(
      _stateTableName,
      columns: ['resetPending'],
      where: 'userId = ?',
      whereArgs: [_accountKey(userId)],
    );
    return rows.firstOrNull?['resetPending'] == 1;
  }

  /// Records that [userId] asked for a reset whose server call has not landed yet.
  Future<void> setResetPending(UserId? userId, {required bool pending}) async {
    await _db.insert(_stateTableName, {
      'userId': _accountKey(userId),
      'resetPending': pending ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

/// The learn progress, merged from local storage and the server.
final learnProgressProvider = AsyncNotifierProvider<LearnProgressNotifier, LearnProgress>(
  LearnProgressNotifier.new,
  name: 'LearnProgressProvider',
);

class LearnProgressNotifier() extends AsyncNotifier<LearnProgress> {
  final _logger = Logger('LearnProgressNotifier');

  /// Serializes the operations that touch the account, the progress and the server.
  ///
  /// Without it, a merge in flight re-inserts the rows a reset just deleted, and a score saved
  /// during a merge is posted over a better server one.
  Future<void> _queue = Future.value();

  Future<T> _serialize<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  /// Bumped by [build] and [reset], and carried by every operation it starts.
  ///
  /// The notifier is not `autoDispose`, so one instance is reused across rebuilds: a captured
  /// account field would be overwritten by the next `build`, and a guard comparing it with the
  /// live account would compare the live value with itself. A generation cannot be overwritten,
  /// so an operation from an earlier build can still tell that it is stale.
  int _generation = 0;

  UserId? get _signedIn => ref.read(authControllerProvider)?.user.id;

  @override
  Future<LearnProgress> build() async {
    final userId = ref.watch(authControllerProvider.select((auth) => auth?.user.id));
    final generation = ++_generation;
    final storage = await ref.watch(learnProgressStorageProvider.future);
    final progress = await storage.fetch(userId);
    unawaited(_syncWithServer(storage, userId, generation));
    return progress;
  }

  /// Saves [score] for the level at [levelIndex] of [stage], if it improves on the saved one.
  ///
  /// Improvements by logged-in users are also pushed to the server in the background. The local
  /// save is the source of truth: sync failures leave the row dirty for a later flush and never
  /// affect level completion.
  ///
  /// Never throws. The stage controller calls this without awaiting, so an escaping storage error
  /// would surface as an unhandled zone error in the middle of a level.
  Future<void> saveScore(LearnStage stage, int levelIndex, int score) {
    return _guard('saveScore', () => _saveScore(stage, levelIndex, score));
  }

  Future<void> _saveScore(LearnStage stage, int levelIndex, int score) {
    // Read before the first await, not after: the score belongs to whoever was signed in when the
    // level was completed, so an account change while it waits in the queue must not redirect it
    // to the account that replaced that one.
    final userId = _signedIn;
    return _serialize(() async {
      // Read after the queue is ours, not before: a snapshot taken up front is stale the moment
      // another operation lands, and would drop the score it wrote.
      final current = state.value ?? await future;
      // Compared explicitly rather than by identity: the server overwrites unconditionally, so
      // POSTing a score that is not an improvement would destroy the server-side best. Do not
      // rely on withScore returning an identical instance, that is an implementation detail.
      if (current.levelScore(stage, levelIndex) >= score) return;
      final generation = _generation;
      final storage = await ref.read(learnProgressStorageProvider.future);
      // A reset bumps the generation from inside this queue, so this only rejects a write that
      // would resurrect the rows a reset deleted.
      if (generation != _generation) return;
      state = AsyncData(current.withScore(stage, levelIndex, score));
      await storage.saveScore(
        userId: userId,
        stageKey: stage.key,
        levelIndex: levelIndex,
        score: score,
      );
      unawaited(_syncScore(userId, stage.key, levelIndex, generation));
    });
  }

  /// Resets the progress of the current account, locally and on the server.
  ///
  /// The local rows go immediately so the UI reflects the reset, but the server call is recorded
  /// as pending until it lands. Otherwise a reset done offline would be undone by the next
  /// start, which would read the still-intact server copy back into the local rows.
  ///
  /// Never throws: the learn screen calls this without awaiting.
  Future<void> reset() {
    return _guard('reset', _reset);
  }

  /// Runs [action], logging anything it throws.
  ///
  /// Everything reached from an unawaited call goes through here. Swallowing is deliberate: the
  /// stage controller and the learn screen both call this without awaiting, so rethrowing would
  /// surface as an unhandled zone error in the middle of a level. A storage failure means the
  /// score is not persisted, which the log records.
  Future<void> _guard(String what, Future<void> Function() action) async {
    try {
      await action();
    } catch (e, st) {
      _logger.warning('Learn $what failed', e, st);
    }
  }

  Future<void> _reset() {
    return _serialize(() async {
      final userId = _signedIn;
      final storage = await ref.read(learnProgressStorageProvider.future);
      if (userId == null) {
        await storage.reset(null);
        if (userId != _signedIn) return;
        state = const AsyncData(LearnProgress.empty);
        return;
      }
      await storage.setResetPending(userId, pending: true);
      await storage.reset(userId);
      // Bumped after the local rows are gone, so a merge still in flight from before the reset
      // can no longer re-insert them. Serialized, so it also cannot be mid-write.
      final generation = ++_generation;
      state = const AsyncData(LearnProgress.empty);
      unawaited(_syncReset(userId, generation));
    });
  }

  /// Pushes a score just saved in this session, once the sync queue is free.
  ///
  /// Queued behind the merge on purpose: the server overwrites unconditionally, so posting before
  /// the merge has folded in the server copy would destroy a better server one.
  ///
  /// A failure leaves the row dirty for the next flush.
  Future<void> _syncScore(UserId? userId, String stageKey, int levelIndex, int generation) {
    if (userId == null) return Future.value();
    return _serialize(() async {
      if (generation != _generation) return;
      try {
        final storage = await ref.read(learnProgressStorageProvider.future);
        await _pushScore(storage, userId, stageKey, levelIndex, generation);
      } catch (e, st) {
        // Reached from an unawaited call, so a throw here would surface as an unhandled zone
        // error. The row stays dirty and the next flush picks it up.
        _logger.warning('Could not upload the learn score for $stageKey level $levelIndex', e, st);
      }
    });
  }

  /// Merges the server scores into the local ones, then uploads whatever the server is missing.
  ///
  /// The merge runs first on purpose: flushing before it would push a stale local score over a
  /// better server one. After it, every level holds the best of both sides, so persisting and
  /// pushing can only raise a score, never lower one.
  Future<void> _syncWithServer(LearnProgressStorage storage, UserId? userId, int generation) {
    return _serialize(() async {
      if (userId == null || generation != _generation) return;
      var merge = true;
      try {
        if (await storage.isResetPending(userId)) {
          // A previous reset never reached the server. Clear it there before reading progress
          // back, otherwise the merge would restore exactly what the user asked to erase.
          if (!await _resetOnServer(storage, userId, generation)) {
            // The reset is still not on the server, so merging now would put the old progress
            // straight back into the local rows and keep resetting on every start. Wait for the
            // network instead. The flush still runs, so scores completed after the reset are not
            // held back by it.
            _logger.warning('Learn reset still pending, not merging the server progress yet');
            merge = false;
          }
        }
        if (merge && generation == _generation) {
          final server = _validServerScores(
            await ref.withClient((client) => LearnRepository(client).fetchProgress()),
          );
          if (generation != _generation) return;
          if (server.isEmpty) {
            // Nothing is deleted here, and it cannot be: _validServerScores empties the map both
            // when the server has no progress and when this build cannot read the payload it
            // sent, and the two are indistinguishable here. Deleting would destroy the local copy
            // on a lila stage rename, or on any proxy answering 200 with an empty object. So a
            // reset done on the web does not reach the app; clearing it needs the server to
            // report a reset explicitly rather than by omission.
            _logger.info('Server reported no learn progress, keeping the local copy');
          } else {
            for (final stageEntry in server.entries) {
              for (final levelEntry in stageEntry.value.entries) {
                if (generation != _generation) return;
                // The keep-max guard in saveScore leaves the local score alone when the server
                // is behind, and markSynced below is what keeps such a row dirty for the flush.
                await storage.saveScore(
                  userId: userId,
                  stageKey: stageEntry.key,
                  levelIndex: levelEntry.key,
                  score: levelEntry.value,
                );
                await storage.markSynced(
                  userId: userId,
                  stageKey: stageEntry.key,
                  levelIndex: levelEntry.key,
                  score: levelEntry.value,
                );
              }
            }
            if (generation != _generation) return;
            final current = state.value;
            if (current != null) {
              final merged = current.mergedWithServer(server);
              if (!identical(merged, current)) state = AsyncData(merged);
            }
          }
        }
      } catch (e, st) {
        // Offline or errored: the local progress stands, and the flush still gets its chance.
        _logger.warning('Could not read the server learn progress', e, st);
      }
      if (generation != _generation) return;
      try {
        await _flushUnsynced(storage, userId, generation);
      } catch (e, st) {
        _logger.warning('Could not flush the unsynced learn scores', e, st);
      }
    });
  }

  /// Uploads the scores saved while offline, one row at a time.
  ///
  /// A row the server rejects does not stop the others, so one bad row cannot stall the flush.
  Future<void> _flushUnsynced(LearnProgressStorage storage, UserId? userId, int generation) async {
    if (userId == null) return;
    var failed = 0;
    for (final unsynced in await storage.fetchUnsynced(userId)) {
      if (generation != _generation) return;
      final result = await _pushScore(
        storage,
        userId,
        unsynced.stageKey,
        unsynced.levelIndex,
        generation,
      );
      switch (result) {
        case _PushResult.ok:
          break;
        case _PushResult.retry:
          failed++;
        // The server will never accept this payload, so the row reaches a terminal state
        // instead of being posted again on every start. It is kept, not deleted: the level was
        // really completed, and lila normally knows a superset of this build's stages, so the
        // common cause is that the app is behind rather than that the row is wrong.
        case _PushResult.rejected:
          _logger.warning(
            'Server permanently rejected ${unsynced.stageKey} level ${unsynced.levelIndex},'
            ' keeping the local score and not retrying',
          );
          await storage.quarantine(
            userId: userId,
            stageKey: unsynced.stageKey,
            levelIndex: unsynced.levelIndex,
          );
      }
    }
    if (failed > 0) {
      _logger.warning('$failed learn scores still unsynced, they will be retried on next start');
    }
  }

  /// Posts the current score of a level and stamps the row when the server accepted it.
  ///
  /// The score is re-read here rather than taken from a snapshot taken when the flush started:
  /// a better score saved in between must be the one uploaded, because the server overwrites
  /// unconditionally and would otherwise keep the older, lower value while the local row stays
  /// marked clean.
  Future<_PushResult> _pushScore(
    LearnProgressStorage storage,
    UserId userId,
    String stageKey,
    int levelIndex,
    int generation,
  ) async {
    if (generation != _generation) return _PushResult.retry;
    final score = await storage.fetchScore(
      userId: userId,
      stageKey: stageKey,
      levelIndex: levelIndex,
    );
    // The row disappeared (a reset) between the listing and now: nothing to upload.
    if (score == null) return _PushResult.ok;
    try {
      await ref.withClient(
        (client) =>
            LearnRepository(client)
                .saveScore(stageKey: stageKey, levelId: levelIndex + 1, score: score),
      );
    } on ServerException catch (e) {
      // Only a code that means the payload itself is wrong is permanent. 401 is a token problem
      // the client already retried, and 403/408/429 are recoverable, so those keep the row dirty.
      return _isPermanentRejection(e.statusCode) ? _PushResult.rejected : _PushResult.retry;
    } catch (_) {
      return _PushResult.retry;
    }
    // The POST succeeded, so the server holds this score. The row is stamped even when the
    // generation moved on, because markSynced only touches a row still holding this exact score:
    // a reset deleted it, or a better score replaced it, and both leave the update matching
    // nothing. A row that still matches is one this account still owes nothing for.
    // After an account change the POST credited whichever token was live, so that row keeps its
    // own pending push.
    if (generation != _generation && userId != ref.read(authControllerProvider)?.user.id) {
      return _PushResult.retry;
    }
    await storage.markSynced(
      userId: userId,
      stageKey: stageKey,
      levelIndex: levelIndex,
      score: score,
    );
    return _PushResult.ok;
  }

  /// Wipes the server progress of [userId], clearing the pending flag once it lands.
  ///
  /// Returns whether the server confirmed it, so a caller can hold off on reading progress back.
  Future<bool> _resetOnServer(LearnProgressStorage storage, UserId userId, int generation) async {
    if (generation != _generation) return false;
    try {
      await ref.withClient((client) => LearnRepository(client).reset());
      // Cleared before the staleness check, not after: the POST has landed, so the reset reached
      // the server whatever happened to this operation since. Bailing out first would leave the
      // flag set for good, and every later start would wipe whatever the user earned on the web.
      await storage.setResetPending(userId, pending: false);
      return generation == _generation;
    } on ServerException catch (e) {
      _logger.warning('Server refused the learn reset (${e.statusCode})', e);
      return false;
    } catch (e, st) {
      _logger.warning('Could not reset the server learn progress', e, st);
      return false;
    }
  }

  Future<void> _syncReset(UserId userId, int generation) {
    return _serialize(() async {
      if (generation != _generation) return;
      try {
        final storage = await ref.read(learnProgressStorageProvider.future);
        await _resetOnServer(storage, userId, generation);
      } catch (e, st) {
        // Reached from an unawaited call, so a throw here would surface as an unhandled zone
        // error. The pending flag stays set, and the next start clears the server before merging.
        _logger.warning('Could not reset the server learn progress', e, st);
      }
    });
  }
}
