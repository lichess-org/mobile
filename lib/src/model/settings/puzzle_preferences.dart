import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/db/shared_preferences.dart';

part 'puzzle_preferences.freezed.dart';
part 'puzzle_preferences.g.dart';

const _prefKey = 'preferences.puzzle';

@Riverpod(keepAlive: true)
class PuzzlePreferences extends _$PuzzlePreferences {
  @override
  PuzzlePrefs build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? PuzzlePrefs.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : const PuzzlePrefs(
            nextPuzzleImmediately: true,
          );
  }

  Future<void> toggleNextPuzzleImmediately() {
    return _save(
      state.copyWith(nextPuzzleImmediately: !state.nextPuzzleImmediately),
    );
  }

  Future<void> _save(PuzzlePrefs newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class PuzzlePrefs with _$PuzzlePrefs {
  const factory PuzzlePrefs({
    required bool nextPuzzleImmediately,
  }) = _PuzzlePrefs;

  factory PuzzlePrefs.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePrefsFromJson(json);
}
