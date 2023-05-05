import 'package:async/async.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_history_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
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
  // ignore: avoid_manual_providers_as_generated_provider_dependency
  final puzzleService = ref.watch(defaultPuzzleServiceProvider);
  final userId = session?.user.id;
  return puzzleService.nextPuzzle(
    userId: userId,
    angle: theme,
  );
}

@riverpod
Future<PuzzleStreakResponse> streak(StreakRef ref) {
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.streak());
}

@Riverpod(keepAlive: true)
Future<Puzzle> puzzle(
  PuzzleRef ref,
  PuzzleId id,
) async {
  // ignore: avoid_manual_providers_as_generated_provider_dependency
  final historyRepo = ref.watch(puzzleHistoryStorageProvider);
  final puzzle = await historyRepo.fetchPuzzle(
    puzzleId: id,
  );

  if (puzzle != null) {
    return puzzle;
  }
  final puzzleRepo = ref.watch(puzzleRepositoryProvider);
  return Result.release(puzzleRepo.fetch(id));
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

@Riverpod(keepAlive: true)
Future<IList<PuzzleHistoryDay>?> recentPuzzleHistory(
  RecentPuzzleHistoryRef ref,
) {
  final session = ref.watch(authSessionProvider);
  final repo = ref.watch(puzzleHistoryStorageProvider);
  return repo.fetchRecent(userId: session?.user.id);
}
