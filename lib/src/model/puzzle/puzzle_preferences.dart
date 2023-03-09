import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';

part 'puzzle_preferences.freezed.dart';
part 'puzzle_preferences.g.dart';

const _prefKey = 'puzzle.preferences';

@Freezed(fromJson: true, toJson: true)
class PuzzlePrefs with _$PuzzlePrefs {
  const factory PuzzlePrefs({
    required UserId? id,
    required PuzzleDifficulty difficulty,
  }) = _PuzzlePrefs;

  factory PuzzlePrefs.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePrefsFromJson(json);
}

@riverpod
class PuzzlePrefsState extends _$PuzzlePrefsState {
  @override
  PuzzlePrefs build(UserId? id) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_makeKey(id));
    return stored != null
        ? PuzzlePrefs.fromJson(jsonDecode(stored) as Map<String, dynamic>)
        : PuzzlePrefs(id: id, difficulty: PuzzleDifficulty.normal);
  }

  Future<void> setDifficulty(PuzzleDifficulty difficulty) async {
    final newState = state.copyWith(difficulty: difficulty);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_makeKey(id), jsonEncode(newState.toJson()));
    state = newState;
  }

  String _makeKey(UserId? id) => '$_prefKey.${id ?? ''}';
}
