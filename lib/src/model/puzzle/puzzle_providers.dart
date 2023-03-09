import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';

part 'puzzle_providers.g.dart';

@riverpod
Future<Tuple2<UserId?, Puzzle?>> nextPuzzle(
  NextPuzzleRef ref,
  PuzzleTheme theme,
) async {
  final session = ref.watch(userSessionStateProvider);
  final puzzleService = ref.watch(puzzleServiceProvider);
  final userId = session?.user.id;
  final difficulty = ref.watch(
    puzzlePrefsStateProvider(userId).select(
      (state) => state.difficulty,
    ),
  );
  final puzzle = await puzzleService.nextPuzzle(
    userId: userId,
    difficulty: difficulty,
    angle: theme,
  );
  return Tuple2(session?.user.id, puzzle);
}

@riverpod
Future<Puzzle> dailyPuzzle(DailyPuzzleRef ref) {
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.daily());
}
