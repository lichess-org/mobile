import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_preferences.freezed.dart';
part 'puzzle_preferences.g.dart';

@Riverpod(keepAlive: true)
class PuzzlePreferences extends _$PuzzlePreferences with SessionPreferencesStorage<PuzzlePrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.puzzle;

  @override
  PuzzlePrefs defaults({LightUser? user}) => PuzzlePrefs.defaults(id: user?.id);

  @override
  PuzzlePrefs fromJson(Map<String, dynamic> json) => PuzzlePrefs.fromJson(json);

  @override
  PuzzlePrefs build() {
    return fetch();
  }

  Future<void> setDifficulty(PuzzleDifficulty difficulty) async {
    save(state.copyWith(difficulty: difficulty));
  }

  Future<void> setAutoNext(bool autoNext) async {
    save(state.copyWith(autoNext: autoNext));
  }

  Future<void> setRated(bool rated) async {
    save(state.copyWith(rated: rated));
  }
}

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
  }) = _PuzzlePrefs;

  factory PuzzlePrefs.defaults({UserId? id}) =>
      PuzzlePrefs(id: id, difficulty: PuzzleDifficulty.normal, autoNext: false, rated: true);

  factory PuzzlePrefs.fromJson(Map<String, dynamic> json) => _$PuzzlePrefsFromJson(json);
}
