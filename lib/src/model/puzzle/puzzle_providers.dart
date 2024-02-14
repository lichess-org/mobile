import 'dart:async';

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_opening.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/storm.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_providers.g.dart';

@riverpod
Future<PuzzleContext?> nextPuzzle(
  NextPuzzleRef ref,
  PuzzleAngle angle,
) {
  final session = ref.watch(authSessionProvider);
  final client = ref.watch(httpClientFactoryProvider)();

  ref.onDispose(client.close);

  final puzzleService = ref.watch(puzzleServiceFactoryProvider)(
    client,
    queueLength: kPuzzleLocalQueueLength,
  );
  final userId = session?.user.id;
  return puzzleService.nextPuzzle(
    userId: userId,
    angle: angle,
  );
}

@riverpod
Future<PuzzleStreakResponse> streak(StreakRef ref) {
  final client = ref.watch(httpClientFactoryProvider)();
  final repo = PuzzleRepository(client);
  ref.onDispose(client.close);
  return repo.streak();
}

@riverpod
Future<PuzzleStormResponse> storm(StormRef ref) {
  final client = ref.watch(httpClientFactoryProvider)();
  final repo = PuzzleRepository(client);
  ref.onDispose(client.close);
  return repo.storm();
}

@riverpod
Future<Puzzle> puzzle(PuzzleRef ref, PuzzleId id) async {
  final puzzleStorage = ref.watch(puzzleStorageProvider);
  final puzzle = await puzzleStorage.fetch(puzzleId: id);
  if (puzzle != null) return puzzle;
  final client = ref.watch(httpClientFactoryProvider)();
  final repo = PuzzleRepository(client);
  ref.onDispose(client.close);
  return repo.fetch(id);
}

@riverpod
Future<Puzzle> dailyPuzzle(DailyPuzzleRef ref) async {
  final link = ref.cacheFor(const Duration(hours: 2));
  final client = ref.watch(httpClientFactoryProvider)();
  final repo = PuzzleRepository(client);
  ref.onDispose(client.close);
  try {
    return repo.daily();
  } catch (e) {
    link.close();
    rethrow;
  }
}

@riverpod
Future<IMap<PuzzleThemeKey, int>> savedThemeBatches(SavedThemeBatchesRef ref) {
  final session = ref.watch(authSessionProvider);
  final storage = ref.watch(puzzleBatchStorageProvider);
  return storage.fetchSavedThemes(userId: session?.user.id);
}

@riverpod
Future<IMap<String, int>> savedOpeningBatches(
  SavedOpeningBatchesRef ref,
) async {
  final session = ref.watch(authSessionProvider);
  final storage = ref.watch(puzzleBatchStorageProvider);
  return storage.fetchSavedOpenings(userId: session?.user.id);
}

@riverpod
Future<PuzzleDashboard> puzzleDashboard(
  PuzzleDashboardRef ref,
) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final client = ref.watch(httpClientFactoryProvider)();
  final repo = PuzzleRepository(client);
  ref.onDispose(client.close);
  final result = await Result.capture(repo.puzzleDashboard());
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<StormDashboard> stormDashboard(StormDashboardRef ref) async {
  final link = ref.cacheFor(const Duration(minutes: 30));
  final session = ref.watch(authSessionProvider);
  final client = ref.watch(httpClientFactoryProvider)();
  final repo = PuzzleRepository(client);
  ref.onDispose(client.close);
  final result = await Result.capture(repo.stormDashboard(session!.user.id));
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
  final client = ref.watch(httpClientFactoryProvider)();
  final repo = PuzzleRepository(client);
  ref.onDispose(client.close);
  final result = await Result.capture(repo.puzzleThemes());
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@riverpod
Future<IList<PuzzleOpeningFamily>> puzzleOpenings(PuzzleOpeningsRef ref) async {
  final link = ref.cacheFor(const Duration(days: 1));
  final client = ref.watch(httpClientFactoryProvider)();
  final repo = PuzzleRepository(client);
  ref.onDispose(client.close);
  final result = await Result.capture(repo.puzzleOpenings());
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}
