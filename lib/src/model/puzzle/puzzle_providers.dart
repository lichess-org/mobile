import 'dart:async';

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
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_providers.g.dart';

@riverpod
Future<PuzzleContext?> nextPuzzle(
  NextPuzzleRef ref,
  PuzzleAngle angle,
) {
  final session = ref.watch(authSessionProvider);
  final puzzleService = ref.read(puzzleServiceFactoryProvider)(
    queueLength: kPuzzleLocalQueueLength,
  );

  return puzzleService.nextPuzzle(
    userId: session?.user.id,
    angle: angle,
  );
}

@riverpod
Future<PuzzleStreakResponse> streak(StreakRef ref) {
  return ref.withClient((client) => PuzzleRepository(client).streak());
}

@riverpod
Future<PuzzleStormResponse> storm(StormRef ref) {
  return ref.withClient((client) => PuzzleRepository(client).storm());
}

/// Fetches a puzzle from the local storage if available, otherwise fetches it from the server.
@riverpod
Future<Puzzle> puzzle(PuzzleRef ref, PuzzleId id) async {
  final puzzleStorage = ref.watch(puzzleStorageProvider);
  final puzzle = await puzzleStorage.fetch(puzzleId: id);
  if (puzzle != null) return puzzle;
  return ref.withClient((client) => PuzzleRepository(client).fetch(id));
}

@riverpod
Future<Puzzle> dailyPuzzle(DailyPuzzleRef ref) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).daily(),
    const Duration(hours: 6),
  );
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
Future<PuzzleDashboard?> puzzleDashboard(
  PuzzleDashboardRef ref,
) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return null;
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleDashboard(),
    const Duration(hours: 3),
  );
}

@riverpod
Future<IList<PuzzleHistoryEntry>?> puzzleRecentActivity(
  PuzzleRecentActivityRef ref,
) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return null;
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleActivity(20),
    const Duration(hours: 3),
  );
}

@riverpod
Future<StormDashboard?> stormDashboard(StormDashboardRef ref, UserId id) async {
  return ref.withClient(
    (client) => PuzzleRepository(client).stormDashboard(id),
  );
}

@riverpod
Future<IMap<PuzzleThemeKey, PuzzleThemeData>> puzzleThemes(
  PuzzleThemesRef ref,
) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleThemes(),
    const Duration(days: 1),
  );
}

@riverpod
Future<IList<PuzzleOpeningFamily>> puzzleOpenings(PuzzleOpeningsRef ref) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleOpenings(),
    const Duration(days: 1),
  );
}
