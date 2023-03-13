import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';

part 'puzzle_preferences.freezed.dart';
part 'puzzle_preferences.g.dart';

const _prefKey = 'puzzle.preferences';

@riverpod
class PuzzlePreferences extends _$PuzzlePreferences {
  @override
  PuzzlePrefState build(UserId? id) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_makeKey(id));
    return stored != null
        ? PuzzlePrefState.fromJson(jsonDecode(stored) as Map<String, dynamic>)
        : PuzzlePrefState(id: id, difficulty: PuzzleDifficulty.normal);
  }

  Future<void> setDifficulty(PuzzleDifficulty difficulty) async {
    final newState = state.copyWith(difficulty: difficulty);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_makeKey(id), jsonEncode(newState.toJson()));
    state = newState;
  }

  String _makeKey(UserId? id) => '$_prefKey.${id ?? ''}';
}

@Freezed(fromJson: true, toJson: true)
class PuzzlePrefState with _$PuzzlePrefState {
  const factory PuzzlePrefState({
    required UserId? id,
    required PuzzleDifficulty difficulty,
  }) = _PuzzlePrefState;

  factory PuzzlePrefState.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePrefStateFromJson(json);
}
