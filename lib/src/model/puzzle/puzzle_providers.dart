import 'package:async/async.dart';
import 'package:tuple/tuple.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';

part 'puzzle_providers.g.dart';

@riverpod
Future<PuzzleContext?> nextPuzzle(
  NextPuzzleRef ref,
  PuzzleTheme theme,
) {
  final session = ref.watch(authSessionProvider);
  final puzzleService = ref.watch(defaultPuzzleServiceProvider);
  final userId = session?.user.id;
  return puzzleService.nextPuzzle(
    userId: userId,
    angle: theme,
  );
}

@riverpod
Future<Tuple2<UserId?, StreakData>> streak(StreakRef ref) async {
  final session = ref.watch(authSessionProvider);
  final userId = session?.user.id;
  final store = ref.watch(streakStoreProvider(userId));
  final savedStreak = await store.get();
  if (savedStreak != null) {
    return Tuple2(userId, savedStreak);
  }
  final repo = ref.watch(puzzleRepositoryProvider);
  final resp = await Result.release(repo.streak());
  return Tuple2(
    userId,
    StreakData(
      streak: resp.streak,
      puzzle: resp.puzzle,
      index: 0,
      hasSkipped: false,
    ),
  );
}

@Riverpod(keepAlive: true)
Future<Puzzle> dailyPuzzle(DailyPuzzleRef ref) {
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.daily());
}

@riverpod
Future<ISet<PuzzleTheme>> savedThemes(SavedThemesRef ref) {
  final session = ref.watch(authSessionProvider);
  final storage = ref.watch(puzzleBatchStorageProvider);
  return storage.fetchSavedThemes(userId: session?.user.id);
}

@riverpod
Future<PuzzleDashboard> puzzleDashboard(PuzzleDashboardRef ref, int days) {
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.puzzleDashboard(days));
}
