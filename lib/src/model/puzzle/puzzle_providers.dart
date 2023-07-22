import 'dart:async';

import 'package:async/async.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/storm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

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

@riverpod
Future<PuzzleStormResponse> storm(StormRef ref) {
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.storm());
}

@Riverpod(keepAlive: true)
Future<Puzzle> puzzle(PuzzleRef ref, PuzzleId id) async {
  final puzzleStorage = ref.watch(puzzleStorageProvider);
  final puzzle = await puzzleStorage.fetch(puzzleId: id);
  if (puzzle != null) return puzzle;
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.fetch(id));
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
Future<PuzzleDashboard> puzzleDashboard(
  PuzzleDashboardRef ref,
  int days,
) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(puzzleRepositoryProvider);
  final result = await repo.puzzleDashboard(days);
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<StormDashboard> stormDashboard(StormDashboardRef ref) {
  ref.cacheFor(const Duration(minutes: 30));
  final session = ref.watch(authSessionProvider);
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.stormDashboard(session!.user.id));
}
