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
    for (final stageEntry in _validServerScores(server).entries) {
      final stage = learnStageByKey(stageEntry.key)!;
      for (final levelEntry in stageEntry.value.entries) {
        merged = merged.withScore(stage, levelEntry.key, levelEntry.value);
      }
    }
    return merged;
  }
}

/// Whether this app version has a level at [levelIndex] of the stage [stageKey].
///
/// A stage or level outside the catalogue cannot be shown and the server rejects it, so such a
/// row must not be stored or uploaded.
bool isStorableLevel(String stageKey, int levelIndex) {
  final stage = learnStageByKey(stageKey);
  return stage != null && levelIndex >= 0 && levelIndex < stage.levels.length;
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

/// A level stored locally that the server does not know about yet.
typedef LearnUnsyncedRef = ({String stageKey, int levelIndex});

/// The storage key of an account, or the anonymous bucket when logged out.
String _accountKey(UserId? userId) => userId?.value ?? kStorageAnonId;

/// Local storage of the learn scores, scoped to one account.
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

  /// The levels saved but never uploaded to the server.
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

  /// Removes one level's row, used to discard a row this build cannot represent.
  Future<void> drop({
    required UserId? userId,
    required String stageKey,
    required int levelIndex,
  }) async {
    await _db.delete(
      _tableName,
      where: 'userId = ? AND stageKey = ? AND levelId = ?',
      whereArgs: [_accountKey(userId), stageKey, levelIndex + 1],
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

/// The learn progress, loaded from local storage.
final learnProgressProvider = AsyncNotifierProvider<LearnProgressNotifier, LearnProgress>(
  LearnProgressNotifier.new,
  name: 'LearnProgressProvider',
);

class LearnProgressNotifier() extends AsyncNotifier<LearnProgress> {
  final _logger = Logger('LearnProgressNotifier');

  /// The account this build of the notifier belongs to.
  ///
  /// Captured in [build], and compared against the live auth state before every read, write and
  /// POST. A getter cannot be used for the comparison: it would re-read the same provider and
  /// compare the live value with itself, which is always true and never catches a switch.
  ///
  /// The notifier is not `autoDispose`, so Riverpod reuses the same instance across a rebuild
  /// while `invalidate` cancels nothing. An `await` can therefore resume after the account
  /// changed, and everything below checks this first.
  UserId? _account;

  /// The account the user is signed in to right now, or null.
  UserId? get _signedIn => ref.read(authControllerProvider)?.user.id;

  /// Whether the signed-in account is still the one this build belongs to.
  bool get _accountUnchanged => _signedIn == _account;

  @override
  Future<LearnProgress> build() async {
    final userId = ref.watch(authControllerProvider.select((auth) => auth?.user.id));
    _account = userId;
    final storage = await ref.watch(learnProgressStorageProvider.future);
    final progress = await storage.fetch(userId);
    unawaited(_syncWithServer(storage, userId));
    return progress;
  }

  /// Saves [score] for the level at [levelIndex] of [stage], if it improves on the saved one.
  ///
  /// Improvements by logged-in users are also pushed to the server in the background. The local
  /// save is the source of truth: sync failures leave the row dirty for a later flush and never
  /// affect level completion.
  Future<void> saveScore(LearnStage stage, int levelIndex, int score) async {
    final current = await future;
    // Compared explicitly rather than by identity: the server overwrites unconditionally, so
    // POSTing a score that is not an improvement would destroy the server-side best. Do not
    // rely on withScore returning an identical instance, that is an implementation detail.
    if (current.levelScore(stage, levelIndex) >= score) return;
    // The row goes to [_account], the account whose progress is being mutated here, so the row
    // and the state can never disagree about whose they are. The upload is separate: the POST
    // authenticates as whoever is signed in at send time, so it only runs while that is still
    // this account. A level completed across a switch is kept locally and uploaded by the next
    // flush, which runs for the account that owns it.
    final userId = _account;
    state = AsyncData(current.withScore(stage, levelIndex, score));
    final storage = await ref.read(learnProgressStorageProvider.future);
    await storage.saveScore(
      userId: userId,
      stageKey: stage.key,
      levelIndex: levelIndex,
      score: score,
    );
    unawaited(_syncScore(userId, stage.key, levelIndex));
  }

  /// Resets the progress of the current account, locally and on the server.
  ///
  /// The local rows go immediately so the UI reflects the reset, but the server call is recorded
  /// as pending until it lands. Otherwise a reset done offline would be undone by the next
  /// start, which would read the still-intact server copy back into the local rows.
  Future<void> reset() async {
    final userId = _account;
    final storage = await ref.read(learnProgressStorageProvider.future);
    if (userId == null) {
      await storage.reset(null);
      state = const AsyncData(LearnProgress.empty);
      return;
    }
    await storage.setResetPending(userId, pending: true);
    await storage.reset(userId);
    if (!_accountUnchanged) {
      // The account switched while the local rows were being cleared. Clearing the state would
      // wipe what the new account is showing, and the server call would run as the new account.
      _logger.warning('Skipped the server half of the reset, the account changed');
      return;
    }
    state = const AsyncData(LearnProgress.empty);
    unawaited(_syncReset(userId));
  }

  /// Pushes a score just saved in this session.
  ///
  /// Anonymous users have no server progress, and a failure leaves the row dirty for the next
  /// flush.
  Future<void> _syncScore(UserId? userId, String stageKey, int levelIndex) async {
    if (userId == null) return;
    try {
      final storage = await ref.read(learnProgressStorageProvider.future);
      await _pushScore(storage, userId, stageKey, levelIndex);
    } catch (e, st) {
      // Reached from an unawaited call in saveScore, so a throw here would surface as an
      // unhandled zone error. The row stays dirty and the next flush picks it up.
      _logger.warning('Could not upload the learn score for $stageKey level $levelIndex', e, st);
    }
  }

  /// Merges the server scores into the local ones, then uploads whatever the server is missing.
  ///
  /// The merge runs first on purpose: flushing before it would push a stale local score over a
  /// better server one. After it, every level holds the best of both sides, so persisting and
  /// pushing can only raise a score, never lower one.
  Future<void> _syncWithServer(LearnProgressStorage storage, UserId? userId) async {
    if (userId == null) return;
    try {
      if (await storage.isResetPending(userId)) {
        // A previous reset never reached the server. Clear it there before reading progress
        // back, otherwise the merge would restore exactly what the user asked to erase.
        if (!await _resetOnServer(storage, userId)) {
          // The reset is still not on the server, so merging now would put the old progress
          // straight back into the local rows and keep resetting on every start. Wait for the
          // network instead.
          _logger.warning('Learn reset still pending, not merging the server progress yet');
          return;
        }
      }
      final server = _validServerScores(
        await ref.withClient((client) => LearnRepository(client).fetchProgress()),
      );
      if (!_accountUnchanged) return;
      if (server.isEmpty) {
        // Deliberately nothing here. An empty payload cannot be told apart from a payload this
        // build cannot make sense of, because _validServerScores drops both. Deleting on it
        // meant a lila stage rename, or a captive portal answering 200 with an empty object,
        // wiped every synced row while the server still held the data and nothing could restore
        // it. A reset done on the web therefore does not reach the app: a late update is better
        // than an unrecoverable deletion. Clearing it needs a server signal that distinguishes
        // "no progress" from "progress I do not understand".
        _logger.info('Server reported no learn progress, keeping the local copy');
      } else {
        for (final stageEntry in server.entries) {
          for (final levelEntry in stageEntry.value.entries) {
            if (!_accountUnchanged) return;
            // The keep-max guard leaves the local score alone when the server is behind.
            await storage.saveScore(
              userId: userId,
              stageKey: stageEntry.key,
              levelIndex: levelEntry.key,
              score: levelEntry.value,
            );
            // Stamps only when the row now holds exactly the server score, so a level where the
            // local copy is better stays dirty and is uploaded by the flush below.
            await storage.markSynced(
              userId: userId,
              stageKey: stageEntry.key,
              levelIndex: levelEntry.key,
              score: levelEntry.value,
            );
          }
        }
        if (!_accountUnchanged) return;
        final current = state.value;
        if (current != null) {
          // Merged into the current state, so a level completed during the round-trip is kept.
          final merged = current.mergedWithServer(server);
          if (!identical(merged, current)) state = AsyncData(merged);
        }
      }
    } catch (e, st) {
      // Offline or errored: the local progress stands, and the flush still gets its chance.
      _logger.warning('Could not read the server learn progress', e, st);
    }
    try {
      await _flushUnsynced(storage, userId);
    } catch (e, st) {
      _logger.warning('Could not flush the unsynced learn scores', e, st);
    }
  }

  /// Uploads the scores saved while offline, one row at a time.
  ///
  /// A row the server rejects does not stop the others, so a stage that lila no longer knows
  /// cannot stall the flush.
  Future<void> _flushUnsynced(LearnProgressStorage storage, UserId? userId) async {
    if (userId == null) return;
    var failed = 0;
    for (final unsynced in await storage.fetchUnsynced(userId)) {
      if (!_accountUnchanged) return;
      // A stage or level this build does not know can never be accepted, so retrying it on
      // every start would post the same doomed request forever. The row is dropped instead.
      if (!isStorableLevel(unsynced.stageKey, unsynced.levelIndex)) {
        _logger.warning(
          'Dropping ${unsynced.stageKey} level ${unsynced.levelIndex}, unknown to this version',
        );
        await storage.drop(
          userId: userId,
          stageKey: unsynced.stageKey,
          levelIndex: unsynced.levelIndex,
        );
        continue;
      }
      if (!await _pushScore(storage, userId, unsynced.stageKey, unsynced.levelIndex)) failed++;
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
  ///
  /// Returns false on failure, leaving the row dirty for the next flush.
  Future<bool> _pushScore(
    LearnProgressStorage storage,
    UserId userId,
    String stageKey,
    int levelIndex,
  ) async {
    if (!_accountUnchanged) return false;
    final score = await storage.fetchScore(
      userId: userId,
      stageKey: stageKey,
      levelIndex: levelIndex,
    );
    // The row disappeared (a reset) between the listing and now: nothing to upload.
    if (score == null) return true;
    try {
      await ref.withClient(
        (client) =>
            LearnRepository(client)
                .saveScore(stageKey: stageKey, levelId: levelIndex + 1, score: score),
      );
      // Re-checked after the await: the account may have changed while the POST was in flight,
      // and stamping the new account's row would mark an unsynced score as clean.
      if (!_accountUnchanged) return false;
      await storage.markSynced(
        userId: userId,
        stageKey: stageKey,
        levelIndex: levelIndex,
        score: score,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Wipes the server progress of [userId], clearing the pending flag once it lands.
  ///
  /// Returns whether the server confirmed it, so a caller can hold off on reading progress back.
  Future<bool> _resetOnServer(LearnProgressStorage storage, UserId userId) async {
    if (!_accountUnchanged) return false;
    try {
      await ref.withClient((client) => LearnRepository(client).reset());
      if (!_accountUnchanged) return false;
      await storage.setResetPending(userId, pending: false);
      return true;
    } catch (e, st) {
      _logger.warning('Could not reset the server learn progress', e, st);
      return false;
    }
  }

  Future<void> _syncReset(UserId userId) async {
    final storage = await ref.read(learnProgressStorageProvider.future);
    await _resetOnServer(storage, userId);
  }
}
