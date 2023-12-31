import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
        : PuzzlePrefState.defaults(id: id);
  }

  Future<void> setDifficulty(PuzzleDifficulty difficulty) async {
    final newState = state.copyWith(difficulty: difficulty);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_makeKey(id), jsonEncode(newState.toJson()));
    state = newState;
  }

  Future<void> setAutoNext(bool autoNext) async {
    final newState = state.copyWith(autoNext: autoNext);
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

    /// If `true`, will show next puzzle after successful completion. This has
    /// no effect on puzzle streaks, which always show next puzzle. Defaults to
    /// `false`.
    required bool autoNext,
  }) = _PuzzlePrefState;

  factory PuzzlePrefState.defaults({UserId? id}) => PuzzlePrefState(
        id: id,
        difficulty: PuzzleDifficulty.normal,
        autoNext: false,
      );

  factory PuzzlePrefState.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePrefStateFromJson(json);
}
