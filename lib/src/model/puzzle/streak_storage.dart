import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'streak_storage.g.dart';

@riverpod
StreakStorage streakStorage(Ref ref, UserId? userId) {
  return StreakStorage(ref, userId);
}

/// Fetches the current streak score from the local storage if available, returns null otherwise.
@riverpod
Future<int?> savedStreakScore(Ref ref) async {
  final session = ref.watch(authSessionProvider);
  // cannot use ref.watch because it would create a circular dependency
  // as we invalidate this provider in the storage saveActiveStreak and clearActiveStreak methods
  final streakStorage = ref.read(streakStorageProvider(session?.user.id));
  final streak = await streakStorage.loadActiveStreak();
  return streak?.index;
}

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
