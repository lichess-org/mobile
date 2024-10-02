import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_preferences.g.dart';

@riverpod
class PuzzlePreferences extends _$PuzzlePreferences
    with SessionPreferencesStorage<PuzzlePrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  final prefCategory = Category.puzzle;

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
}
