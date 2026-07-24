import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'puzzle_preferences.freezed.dart';
part 'puzzle_preferences.g.dart';

final puzzlePreferencesProvider = NotifierProvider<PuzzlePreferences, PuzzlePrefs>(
  PuzzlePreferences.new,
  name: 'PuzzlePreferencesProvider',
);

class PuzzlePreferences extends Notifier<PuzzlePrefs> with SessionPreferencesStorage<PuzzlePrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.puzzle;

  @override
  PuzzlePrefs defaults({LightUser? user}) => PuzzlePrefs.defaults(id: user?.id);

  @override
  PuzzlePrefs fromJson(Map<String, dynamic> json) => PuzzlePrefs.fromJson(json);

  @override
  PuzzlePrefs build() {
    final prefs = fetch();
    // Clamp the offline queue length loaded from storage: corrupted or
    // manually edited prefs could otherwise bypass the bounds enforced by
    // [setNbOfflinePuzzles] and trigger very large downloads.
    final clamped = prefs.nbOfflinePuzzles.clamp(kMinOfflinePuzzles, kMaxOfflinePuzzles);
    return clamped == prefs.nbOfflinePuzzles ? prefs : prefs.copyWith(nbOfflinePuzzles: clamped);
  }

  Future<void> setDifficulty(PuzzleDifficulty difficulty) {
    return save(state.copyWith(difficulty: difficulty));
  }

  Future<void> setAutoNext(bool autoNext) {
    return save(state.copyWith(autoNext: autoNext));
  }

  Future<void> setRated(bool rated) {
    return save(state.copyWith(rated: rated));
  }

  Future<void> setNbOfflinePuzzles(int nbOfflinePuzzles) {
    return save(
      state.copyWith(
        nbOfflinePuzzles: nbOfflinePuzzles.clamp(kMinOfflinePuzzles, kMaxOfflinePuzzles),
      ),
    );
  }
}

/// Minimum number of puzzles kept in the offline queue.
const kMinOfflinePuzzles = 100;

/// Maximum number of puzzles kept in the offline queue.
const kMaxOfflinePuzzles = 300;

/// Available choices for the size of the offline puzzle queue.
const kOfflinePuzzlesChoices = [100, 150, 200, 250, 300];

@Freezed(fromJson: true, toJson: true)
sealed class PuzzlePrefs with _$PuzzlePrefs implements Serializable {
  const factory PuzzlePrefs({
    required UserId? id,
    required PuzzleDifficulty difficulty,

    /// If `true`, will show next puzzle after successful completion. This has
    /// no effect on puzzle streaks, which always show next puzzle. Defaults to
    /// `false`.
    @Default(false) bool autoNext,

    /// If `true`, the puzzle will be rated for logged in users.
    /// Defaults to `true`.
    @Default(true) bool rated,

    /// Number of puzzles to keep downloaded in the offline queue.
    /// Defaults to `100`.
    @Default(100) int nbOfflinePuzzles,
  }) = _PuzzlePrefs;

  factory PuzzlePrefs.defaults({UserId? id}) => PuzzlePrefs(
    id: id,
    difficulty: PuzzleDifficulty.normal,
    autoNext: false,
    rated: true,
    nbOfflinePuzzles: 100,
  );

  factory PuzzlePrefs.fromJson(Map<String, dynamic> json) => _$PuzzlePrefsFromJson(json);
}
