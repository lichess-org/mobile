import 'dart:async' show unawaited;
import 'dart:math' show max;

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';

part 'puzzle_service.freezed.dart';

/// A provider for [PuzzleService].
final puzzleServiceProvider = FutureProvider<PuzzleService>((Ref ref) {
  final nbOfflinePuzzles = ref.watch(
    puzzlePreferencesProvider.select((prefs) => prefs.nbOfflinePuzzles),
  );
  return ref.read(puzzleServiceFactoryProvider)(queueLength: nbOfflinePuzzles);
}, name: 'PuzzleServiceProvider');

/// A provider for [PuzzleServiceFactory].
final puzzleServiceFactoryProvider = Provider<PuzzleServiceFactory>((Ref ref) {
  return PuzzleServiceFactory(ref);
}, name: 'PuzzleServiceFactoryProvider');

class PuzzleServiceFactory {
  PuzzleServiceFactory(this._ref);

  final Ref _ref;

  Future<PuzzleService> call({required int queueLength}) async {
    return PuzzleService(
      _ref,
      batchStorage: await _ref.read(puzzleBatchStorageProvider.future),
      puzzleStorage: await _ref.read(puzzleStorageProvider.future),
      queueLength: queueLength,
    );
  }
}

@freezed
sealed class PuzzleContext with _$PuzzleContext {
  const factory PuzzleContext({
    required Puzzle puzzle,
    required PuzzleAngle angle,
    required UserId? userId,

    /// Current Glicko rating of the user if available.
    PuzzleGlicko? glicko,

    /// List of solved puzzle results if available.
    IList<PuzzleRound>? rounds,

    /// If true, the result won't be recorded on the server for this puzzle.
    bool? casual,
    bool? isPuzzleStreak,

    /// Remaining puzzle IDs to replay after the current one.
    IList<PuzzleId>? replayRemaining,
  }) = _PuzzleContext;
}

class PuzzleService {
  PuzzleService(
    this._ref, {
    required this.batchStorage,
    required this.puzzleStorage,
    required this.queueLength,
  });

  final Ref _ref;
  final int queueLength;
  final PuzzleBatchStorage batchStorage;
  final PuzzleStorage puzzleStorage;
  final Logger _log = Logger('PuzzleService');

  /// Guards [_backgroundFill] against overlapping runs issuing duplicate
  /// requests.
  bool _isFilling = false;

  /// Loads the next puzzle from database and the glicko rating if available.
  ///
  /// Will sync with server if necessary.
  /// This future should never fail on network errors.
  Future<PuzzleContext?> nextPuzzle({
    required UserId? userId,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
  }) {
    return Result.release(
      _syncAndLoadData(userId, angle).map(
        (data) => data.$1 != null && data.$1!.unsolved.isNotEmpty
            ? PuzzleContext(
                puzzle: data.$1!.unsolved[0],
                angle: angle,
                userId: userId,
                glicko: data.$2,
                rounds: data.$3,
              )
            : null,
      ),
    );
  }

  /// Update puzzle queue with the solved puzzle, sync with server and returns
  /// the next puzzle with the glicko rating if available.
  ///
  /// This future should never fail on network errors.
  Future<PuzzleContext?> solve({
    required UserId? userId,
    required PuzzleSolution solution,
    required Puzzle puzzle,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
  }) async {
    puzzleStorage.save(puzzle: puzzle);
    const emptyBatch = PuzzleBatch(solved: IListConst([]), unsolved: IListConst([]));
    final data = await batchStorage.fetch(userId: userId, angle: angle) ?? emptyBatch;
    await batchStorage.save(
      userId: userId,
      angle: angle,
      data: PuzzleBatch(
        solved: IList([...data.solved, solution]),
        unsolved: data.unsolved.removeWhere((e) => e.puzzle.id == solution.id),
      ),
    );
    return nextPuzzle(userId: userId, angle: angle);
  }

  /// Clears the current puzzle batch, fetches a new one and returns the next puzzle.
  Future<PuzzleContext?> resetBatch({
    required UserId? userId,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
  }) async {
    await batchStorage.delete(userId: userId, angle: angle);
    return nextPuzzle(userId: userId, angle: angle);
  }

  /// Deletes the puzzle batch of [angle] from the local storage.
  Future<void> deleteBatch({required UserId? userId, required PuzzleAngle angle}) async {
    await batchStorage.delete(userId: userId, angle: angle);
  }

  /// Synchronize offline puzzle queue with server and gets latest data.
  ///
  /// Does a single request so the next puzzle is available without blocking.
  /// A large offline queue can't be filled in one call (the server caps each
  /// batch at 50), so any remaining deficit is filled by [_backgroundFill]
  /// rather than making the user wait.
  ///
  /// This method should never fail, as if the network is down it will fallback
  /// to the local database.
  FutureResult<(PuzzleBatch?, PuzzleGlicko?, IList<PuzzleRound>?)> _syncAndLoadData(
    UserId? userId,
    PuzzleAngle angle,
  ) async {
    final data = await batchStorage.fetch(userId: userId, angle: angle);

    final unsolved = data?.unsolved ?? IList(const []);
    final solved = data?.solved ?? IList(const []);

    final deficit = max(0, queueLength - unsolved.length);

    if (deficit <= 0 && solved.isEmpty) {
      return Result.value((data, null, null));
    }

    final difficulty = _ref.read(puzzlePreferencesProvider).difficulty;

    // One request keeps the next puzzle responsive; the rest fills in the
    // background.
    final batchResult = await _fetchBatch(
      userId: userId,
      angle: angle,
      difficulty: difficulty,
      nb: deficit,
      solved: solved,
    );

    if (batchResult.isError) {
      // Offline: fall back to the local database.
      return Result.value((data, null, null));
    }

    final value = batchResult.asValue!.value;
    final newBatch = PuzzleBatch(
      solved: IList(const []),
      unsolved: IList([...unsolved, ...value.puzzles]),
    );
    await batchStorage.save(userId: userId, angle: angle, data: newBatch);

    // Fill the rest without blocking so a large queue is cached before the
    // user goes offline.
    if (value.puzzles.isNotEmpty && newBatch.unsolved.length < queueLength) {
      unawaited(_backgroundFill(userId, angle, difficulty));
    }

    return Result.value((newBatch, value.glicko, value.rounds));
  }

  /// Downloads a single batch, submitting [solved] if there is anything to
  /// report (and the user is logged in), otherwise just fetching new puzzles.
  FutureResult<PuzzleBatchResponse> _fetchBatch({
    required UserId? userId,
    required PuzzleAngle angle,
    required PuzzleDifficulty difficulty,
    required int nb,
    IList<PuzzleSolution> solved = const IListConst([]),
  }) {
    _log.fine('Will sync puzzles with lichess (nb: $nb, solved: ${solved.length})');
    // anonymous users can't solve puzzles so we just download the deficit.
    return _ref.withClient(
      (client) => Result.capture(
        solved.isNotEmpty && userId != null
            ? PuzzleRepository(
                client,
              ).solveBatch(nb: nb, solved: solved, angle: angle, difficulty: difficulty)
            : PuzzleRepository(client).selectBatch(nb: nb, angle: angle, difficulty: difficulty),
      ),
    );
  }

  /// Tops up the offline queue to `queueLength` in the background.
  ///
  /// Re-reads storage each pass and merges by puzzle id so a solve made while
  /// the fill runs is never clobbered. Guarded by [_isFilling] so overlapping
  /// calls can't double-fetch.
  Future<void> _backgroundFill(
    UserId? userId,
    PuzzleAngle angle,
    PuzzleDifficulty difficulty,
  ) async {
    if (_isFilling) return;
    _isFilling = true;
    try {
      while (true) {
        final current = await batchStorage.fetch(userId: userId, angle: angle);
        final unsolved = current?.unsolved ?? IList(const []);
        final deficit = max(0, queueLength - unsolved.length);
        if (deficit <= 0) break;

        final batchResult = await _fetchBatch(
          userId: userId,
          angle: angle,
          difficulty: difficulty,
          nb: deficit,
        );
        if (batchResult.isError) break;

        final value = batchResult.asValue!.value;
        // Server has no more puzzles: stop rather than spin forever below
        // an unreachable `queueLength`.
        if (value.puzzles.isEmpty) break;

        // Skip ids already stored so a re-read after a mid-fill solve can't
        // reintroduce a duplicate.
        final existingIds = unsolved.map((p) => p.puzzle.id).toISet();
        final additions = value.puzzles.where((p) => !existingIds.contains(p.puzzle.id));
        if (additions.isEmpty) break;

        await batchStorage.save(
          userId: userId,
          angle: angle,
          data: PuzzleBatch(
            solved: current?.solved ?? IList(const []),
            unsolved: IList([...unsolved, ...additions]),
          ),
        );
      }
    } finally {
      _isFilling = false;
    }
  }
}
