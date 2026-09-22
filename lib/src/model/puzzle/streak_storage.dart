import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the streak storage for a given user.
///
/// Not auto-disposed, so that a run can still be saved once the streak screen has been left.
final streakStorageProvider = Provider.family<StreakStorage, UserId?>((Ref ref, UserId? userId) {
  return StreakStorage(ref, userId);
});

/// Fetches the score of the run in progress from the local storage if any, returns null otherwise.
final savedStreakScoreProvider = FutureProvider.autoDispose<int?>((Ref ref) async {
  final authUser = ref.watch(authControllerProvider);
  // cannot use ref.watch because it would create a circular dependency
  // as we invalidate this provider in the storage saveActiveStreak and clearActiveStreak methods
  final streakStorage = ref.read(streakStorageProvider(authUser?.user.id));
  final streak = await streakStorage.loadActiveStreak();
  return streak == null || streak.finished ? null : streak.index;
});

/// Local storage for the current puzzle streak.
class const StreakStorage(final Ref ref, final UserId? userId) {
  Future<PuzzleStreak?> loadActiveStreak() async {
    final stored = _store.getString(_storageKey);
    if (stored == null) {
      return null;
    }

    return PuzzleStreak.fromJson(jsonDecode(stored) as Map<String, dynamic>);
  }

  Future<void> saveActiveStreak(PuzzleStreak streak) async {
    await _store.setString(_storageKey, jsonEncode(streak));
    ref.invalidate(savedStreakScoreProvider);
  }

  Future<void> clearActiveStreak() async {
    await _store.remove(_storageKey);
    ref.invalidate(savedStreakScoreProvider);
  }

  SharedPreferencesWithCache get _store => LichessBinding.instance.sharedPreferences;

  String get _storageKey => 'puzzle_streak.${userId ?? '**anon**'}';
}
