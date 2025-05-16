import 'dart:math' show max;

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_service.freezed.dart';
part 'puzzle_service.g.dart';

/// Size of puzzle local cache
const kPuzzleLocalQueueLength = 50;

@Riverpod(keepAlive: true)
Future<PuzzleService> puzzleService(Ref ref) {
  return ref.read(puzzleServiceFactoryProvider)(queueLength: kPuzzleLocalQueueLength);
}

@Riverpod(keepAlive: true)
PuzzleServiceFactory puzzleServiceFactory(Ref ref) {
  return PuzzleServiceFactory(ref);
}

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
        (data) =>
            data.$1 != null && data.$1!.unsolved.isNotEmpty
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
    final data = await batchStorage.fetch(userId: userId, angle: angle);
    if (data != null) {
      await batchStorage.save(
        userId: userId,
        angle: angle,
        data: PuzzleBatch(
          solved: IList([...data.solved, solution]),
          unsolved: data.unsolved.removeWhere((e) => e.puzzle.id == solution.id),
        ),
      );
    }
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
  /// This task will fetch missing puzzles so the queue length is always equal to
  /// `queueLength`.
  /// It will call [PuzzleRepository.solveBatch] if necessary.
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

    if (deficit > 0) {
      _log.fine('Have a puzzle deficit of $deficit, will sync with lichess');

      final difficulty = _ref.read(puzzlePreferencesProvider).difficulty;

      // anonymous users can't solve puzzles so we just download the deficit
      // we send the request even if the deficit is 0 to get the glicko rating
      final batchResponse = _ref.withClient(
        (client) => Result.capture(
          solved.isNotEmpty && userId != null
              ? PuzzleRepository(
                client,
              ).solveBatch(nb: deficit, solved: solved, angle: angle, difficulty: difficulty)
              : PuzzleRepository(
                client,
              ).selectBatch(nb: deficit, angle: angle, difficulty: difficulty),
        ),
      );

      return batchResponse
          .fold(
            (value) => Result.value((
              PuzzleBatch(
                solved: IList(const []),
                unsolved: IList([...unsolved, ...value.puzzles]),
              ),
              value.glicko,
              value.rounds,
              true, // should save the batch
            )),

            // we don't need to save the batch if the request failed
            (_, _) => Result.value((data, null, null, false)),
          )
          .flatMap((tuple) async {
            final (newBatch, glicko, rounds, shouldSave) = tuple;
            if (newBatch != null && shouldSave) {
              await batchStorage.save(userId: userId, angle: angle, data: newBatch);
            }
            return Result.value((newBatch, glicko, rounds));
          });
    }

    return Result.value((data, null, null));
  }
}
