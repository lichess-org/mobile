import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
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

/// Fetches the next puzzle for the given [PuzzleAngle].
final nextPuzzleProvider = FutureProvider.autoDispose.family<PuzzleContext?, PuzzleAngle>((
  Ref ref,
  PuzzleAngle angle,
) async {
  final authUser = ref.watch(authControllerProvider);
  final puzzleService = await ref.read(puzzleServiceFactoryProvider)(
    queueLength: kPuzzleLocalQueueLength,
  );
  // useful for for preview puzzle list in puzzle tab (providers in a list can
  // be invalidated multiple times when the user scrolls the list)
  ref.cacheFor(const Duration(minutes: 1));

  return puzzleService.nextPuzzle(userId: authUser?.user.id, angle: angle);
}, name: 'NextPuzzleProvider');

/// Fetches a storm of puzzles.
final stormProvider = FutureProvider.autoDispose<PuzzleStormResponse>((Ref ref) {
  return ref.withClient((client) => PuzzleRepository(client).storm());
}, name: 'StormProvider');

/// Fetches a puzzle from the local storage if available, otherwise fetches it from the server.
final puzzleProvider = FutureProvider.autoDispose.family<Puzzle, PuzzleId>((
  Ref ref,
  PuzzleId id,
) async {
  final puzzleStorage = await ref.watch(puzzleStorageProvider.future);
  final puzzle = await puzzleStorage.fetch(puzzleId: id);
  if (puzzle != null) return puzzle;
  return ref.withClient((client) => PuzzleRepository(client).fetch(id));
}, name: 'PuzzleProvider');

/// Fetches the daily puzzle.
final dailyPuzzleProvider = FutureProvider.autoDispose<Puzzle>((Ref ref) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).daily(),
    const Duration(hours: 6),
  );
}, name: 'DailyPuzzleProvider');

/// Fetches all saved puzzle batches for the current user.
final savedBatchesProvider = FutureProvider.autoDispose<IList<(PuzzleAngle, int)>>((Ref ref) async {
  final authUser = ref.watch(authControllerProvider);
  final storage = await ref.watch(puzzleBatchStorageProvider.future);
  return storage.fetchAll(userId: authUser?.user.id);
}, name: 'SavedBatchesProvider');

/// Fetches saved puzzle theme batches for the current user.
final savedThemeBatchesProvider = FutureProvider.autoDispose<IMap<PuzzleThemeKey, int>>((
  Ref ref,
) async {
  final authUser = ref.watch(authControllerProvider);
  final storage = await ref.watch(puzzleBatchStorageProvider.future);
  return storage.fetchSavedThemes(userId: authUser?.user.id);
}, name: 'SavedThemeBatchesProvider');

/// Fetches saved puzzle opening batches for the current user.
final savedOpeningBatchesProvider = FutureProvider.autoDispose<IMap<String, int>>((Ref ref) async {
  final authUser = ref.watch(authControllerProvider);
  final storage = await ref.watch(puzzleBatchStorageProvider.future);
  return storage.fetchSavedOpenings(userId: authUser?.user.id);
}, name: 'SavedOpeningBatchesProvider');

/// Fetches the puzzle dashboard for the current user for the given number of [days].
final puzzleDashboardProvider = FutureProvider.autoDispose.family<PuzzleDashboard?, int>((
  Ref ref,
  int days,
) {
  final authUser = ref.watch(authControllerProvider);
  if (authUser == null) return null;
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleDashboard(days),
    const Duration(hours: 3),
  );
}, name: 'PuzzleDashboardProvider');

/// Fetches recent puzzle activity for the current user.
final puzzleRecentActivityProvider = FutureProvider.autoDispose<IList<PuzzleHistoryEntry>?>((
  Ref ref,
) {
  final authUser = ref.watch(authControllerProvider);
  if (authUser == null) return null;
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleActivity(20),
    const Duration(hours: 3),
  );
}, name: 'PuzzleRecentActivityProvider');

/// Fetches the storm dashboard for a given user [UserId].
final stormDashboardProvider = FutureProvider.autoDispose.family<StormDashboard?, UserId>((
  Ref ref,
  UserId id,
) {
  return ref.withClient((client) => PuzzleRepository(client).stormDashboard(id));
}, name: 'StormDashboardProvider');

/// Fetches available puzzle themes.
final puzzleThemesProvider = FutureProvider.autoDispose<IMap<PuzzleThemeKey, PuzzleThemeData>>((
  Ref ref,
) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleThemes(),
    const Duration(days: 1),
  );
}, name: 'PuzzleThemesProvider');

/// Fetches available puzzle openings.
final puzzleOpeningsProvider = FutureProvider.autoDispose<IList<PuzzleOpeningFamily>>((Ref ref) {
  return ref.withClientCacheFor(
    (client) => PuzzleRepository(client).puzzleOpenings(),
    const Duration(days: 1),
  );
}, name: 'PuzzleOpeningsProvider');
