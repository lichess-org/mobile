import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _logger = Logger('StreakStorage');

/// Provider for the streak storage for a given user.
final streakStorageProvider = Provider.family<StreakStorage, UserId?>((Ref ref, UserId? userId) {
  return StreakStorage(ref, userId);
});

/// Fetches the current streak score from the local storage if available, returns null otherwise.
final savedStreakScoreProvider = FutureProvider.autoDispose<int?>((Ref ref) async {
  final authUser = ref.watch(authControllerProvider);
  // cannot use ref.watch because it would create a circular dependency
  // as we invalidate this provider in the storage saveActiveStreak and clearActiveStreak methods
  final streakStorage = ref.read(streakStorageProvider(authUser?.user.id));
  final streak = await streakStorage.loadActiveStreak();
  return streak?.score;
});

/// Local storage for the current puzzle streak.
class StreakStorage {
  const StreakStorage(this.ref, this.userId);
  final Ref ref;
  final UserId? userId;

  Future<PuzzleStreak?> loadActiveStreak() async {
    final stored = _store.getString(_storageKey);
    if (stored == null) {
      return null;
    }

    try {
      return PuzzleStreak.fromJson(jsonDecode(stored) as Map<String, dynamic>);
    } catch (e) {
      // Written by another version of the app. The next run overwrites it.
      _logger.warning('Ignoring an unreadable saved streak', e);
      return null;
    }
  }

  Future<void> saveActiveStreak(PuzzleStreak streak) async {
    await _store.setString(_storageKey, jsonEncode(streak));
    ref.invalidate(savedStreakScoreProvider);
  }

  Future<void> clearActiveStreak() async {
    await _store.remove(_storageKey);
    ref.invalidate(savedStreakScoreProvider);
  }

  /// The score of a run that has ended but has not been posted yet.
  Future<int?> loadPendingScore() async => _store.getInt(_pendingScoreKey);

  /// Queues [score] to be posted. Only the best pending score is kept: the server keeps the best
  /// score anyway, so several runs that ended before a post went through count as one.
  Future<void> savePendingScore(int score) async {
    final existing = _store.getInt(_pendingScoreKey);
    await _store.setInt(_pendingScoreKey, existing == null ? score : max(existing, score));
  }

  /// Clears the pending score unless it beats [score], the one that has just been posted.
  Future<void> clearPendingScoreIfAtMost(int score) async {
    final pending = _store.getInt(_pendingScoreKey);
    if (pending == null || pending <= score) {
      await _store.remove(_pendingScoreKey);
    }
  }

  SharedPreferencesWithCache get _store => LichessBinding.instance.sharedPreferences;

  String get _storageKey => 'puzzle_streak.${userId ?? '**anon**'}';

  String get _pendingScoreKey => 'puzzle_streak.pending_score.${userId ?? '**anon**'}';
}
