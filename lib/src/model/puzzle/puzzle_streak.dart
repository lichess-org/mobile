import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';

part 'puzzle_streak.freezed.dart';
part 'puzzle_streak.g.dart';

typedef PuzzleStreak = IList<PuzzleId>;

@Riverpod(keepAlive: true)
StreakStore streakStore(StreakStoreRef ref, UserId? userId) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StreakStore(prefs, userId: userId);
}

class StreakStore {
  const StreakStore(
    SharedPreferences prefs, {
    required this.userId,
  }) : _store = prefs;

  final UserId? userId;
  final SharedPreferences _store;

  Future<StreakData?> get() {
    final stored = _store.getString(_storageKey);
    if (stored == null) {
      return Future.value(null);
    }
    return Future.value(
      StreakData.fromJson(
        jsonDecode(stored) as Map<String, dynamic>,
      ),
    );
  }

  Future<void> save(StreakData data) async {
    await _store.setString(_storageKey, jsonEncode(data.toJson()));
  }

  Future<void> clear() async {
    await _store.remove(_storageKey);
  }

  String get _storageKey => 'puzzle_streak.${userId ?? 'anon'}';
}

@Freezed(fromJson: true, toJson: true)
class StreakData with _$StreakData {
  const factory StreakData({
    required PuzzleStreak streak,
    required Puzzle puzzle,
    required int index,
    required bool hasSkipped,
  }) = _StreakData;

  factory StreakData.fromJson(Map<String, dynamic> json) =>
      _$StreakDataFromJson(json);
}
