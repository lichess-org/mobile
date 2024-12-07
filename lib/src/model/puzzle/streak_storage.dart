import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'streak_storage.g.dart';

@Riverpod(keepAlive: true)
StreakStorage streakStorage(Ref ref, UserId? userId) {
  return StreakStorage(userId);
}

/// Local storage for the current puzzle streak.
class StreakStorage {
  const StreakStorage(this.userId);
  final UserId? userId;

  Future<PuzzleStreak?> loadActiveStreak() async {
    final stored = _store.getString(_storageKey);
    if (stored == null) {
      return null;
    }

    return PuzzleStreak.fromJson(
      jsonDecode(stored) as Map<String, dynamic>,
    );
  }

  Future<void> saveActiveStreak(PuzzleStreak streak) async {
    await _store.setString(
      _storageKey,
      jsonEncode(streak),
    );
  }

  Future<void> clearActiveStreak() async {
    await _store.remove(_storageKey);
  }

  SharedPreferencesWithCache get _store =>
      LichessBinding.instance.sharedPreferences;

  String get _storageKey => 'puzzle_streak.${userId ?? '**anon**'}';
}
