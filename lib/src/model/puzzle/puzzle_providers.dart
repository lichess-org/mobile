import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
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
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_providers.g.dart';

@riverpod
Future<PuzzleContext?> nextPuzzle(Ref ref, PuzzleAngle angle) async {
  final session = ref.watch(authSessionProvider);
  final puzzleService = await ref.read(puzzleServiceFactoryProvider)(
    queueLength: kPuzzleLocalQueueLength,
  );
  // useful for for preview puzzle list in puzzle tab (providers in a list can
  // be invalidated multiple times when the user scrolls the list)
  ref.cacheFor(const Duration(minutes: 1));

  return puzzleService.nextPuzzle(userId: session?.user.id, angle: angle);
}

@riverpod
Future<PuzzleStormResponse> storm(Ref ref) {
  return ref.withClient((client) => PuzzleRepository(client).storm());
}

/// Fetches a puzzle from the local storage if available, otherwise fetches it from the server.
@riverpod
Future<Puzzle> puzzle(Ref ref, PuzzleId id) async {
  final puzzleStorage = await ref.watch(puzzleStorageProvider.future);
  final puzzle = await puzzleStorage.fetch(puzzleId: id);
  if (puzzle != null) return puzzle;
  return ref.withClient((client) => PuzzleRepository(client).fetch(id));
}

@riverpod
Future<Puzzle> dailyPuzzle(Ref ref) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).daily(),
    const Duration(hours: 6),
  );
}

@riverpod
Future<IList<(PuzzleAngle, int)>> savedBatches(Ref ref) async {
  final session = ref.watch(authSessionProvider);
  final storage = await ref.watch(puzzleBatchStorageProvider.future);
  return storage.fetchAll(userId: session?.user.id);
}

@riverpod
Future<IMap<PuzzleThemeKey, int>> savedThemeBatches(Ref ref) async {
  final session = ref.watch(authSessionProvider);
  final storage = await ref.watch(puzzleBatchStorageProvider.future);
  return storage.fetchSavedThemes(userId: session?.user.id);
}

@riverpod
Future<IMap<String, int>> savedOpeningBatches(Ref ref) async {
  final session = ref.watch(authSessionProvider);
  final storage = await ref.watch(puzzleBatchStorageProvider.future);
  return storage.fetchSavedOpenings(userId: session?.user.id);
}

@riverpod
Future<PuzzleDashboard?> puzzleDashboard(Ref ref, int days) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return null;
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleDashboard(days),
    const Duration(hours: 3),
  );
}

@riverpod
Future<IList<PuzzleHistoryEntry>?> puzzleRecentActivity(Ref ref) async {
  final session = ref.watch(authSessionProvider);
  if (session == null) return null;
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleActivity(20),
    const Duration(hours: 3),
  );
}

@riverpod
Future<StormDashboard?> stormDashboard(Ref ref, UserId id) {
  return ref.withClient(
    (client) => PuzzleRepository(client).stormDashboard(id),
  );
}

@riverpod
Future<IMap<PuzzleThemeKey, PuzzleThemeData>> puzzleThemes(Ref ref) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleThemes(),
    const Duration(days: 1),
  );
}

@riverpod
Future<IList<PuzzleOpeningFamily>> puzzleOpenings(Ref ref) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleOpenings(),
    const Duration(days: 1),
  );
}
