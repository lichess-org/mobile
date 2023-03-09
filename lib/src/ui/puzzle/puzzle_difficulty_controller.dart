import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';

part 'puzzle_difficulty_controller.g.dart';

@riverpod
class PuzzleDifficultyController extends _$PuzzleDifficultyController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<Puzzle?> changeDifficulty(
    UserId? userId,
    PuzzleTheme theme,
    PuzzleDifficulty difficulty,
  ) async {
    state = const AsyncLoading();

    await ref
        .read(
          puzzlePrefsStateProvider(userId).notifier,
        )
        .setDifficulty(difficulty);

    final nextPuzzle = await ref.read(defaultPuzzleServiceProvider).resetBatch(
          userId: userId,
          angle: theme,
        );

    state = const AsyncData(null);

    return nextPuzzle;
  }
}
