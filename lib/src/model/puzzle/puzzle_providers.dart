import 'dart:async';

import 'package:async/async.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/storm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_opening.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

part 'puzzle_providers.g.dart';

@riverpod
Future<PuzzleContext?> nextPuzzle(
  NextPuzzleRef ref,
  PuzzleAngle angle,
) {
  final session = ref.watch(authSessionProvider);
  // ignore: avoid_manual_providers_as_generated_provider_dependency
  final puzzleService = ref.watch(defaultPuzzleServiceProvider);
  final userId = session?.user.id;
  return puzzleService.nextPuzzle(
    userId: userId,
    angle: angle,
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

@riverpod
Future<Puzzle> puzzle(PuzzleRef ref, PuzzleId id) async {
  final puzzleStorage = ref.watch(puzzleStorageProvider);
  final puzzle = await puzzleStorage.fetch(puzzleId: id);
  if (puzzle != null) return puzzle;
  final repo = ref.watch(puzzleRepositoryProvider);
  return Result.release(repo.fetch(id));
}

@riverpod
Future<Puzzle> dailyPuzzle(DailyPuzzleRef ref) async {
  final link = ref.cacheFor(const Duration(days: 1));
  final repo = ref.watch(puzzleRepositoryProvider);
  final result = await repo.daily();
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<IMap<PuzzleThemeKey, int>> savedThemes(SavedThemesRef ref) {
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
Future<StormDashboard> stormDashboard(StormDashboardRef ref) async {
  final link = ref.cacheFor(const Duration(minutes: 30));
  final session = ref.watch(authSessionProvider);
  final repo = ref.watch(puzzleRepositoryProvider);
  final result = await repo.stormDashboard(session!.user.id);
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<IMap<PuzzleThemeKey, PuzzleThemeData>> puzzleThemes(
  PuzzleThemesRef ref,
) async {
  final link = ref.cacheFor(const Duration(days: 1));
  final repo = ref.watch(puzzleRepositoryProvider);
  final result = await repo.puzzleThemes();
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<IList<PuzzleOpeningFamily>> puzzleOpenings(PuzzleOpeningsRef ref) async {
  final link = ref.cacheFor(const Duration(days: 1));
  final repo = ref.watch(puzzleRepositoryProvider);
  final result = await repo.puzzleOpenings();
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}
