import 'dart:math' show max;
import 'package:logging/logging.dart';
import 'package:tuple/tuple.dart';
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'puzzle_batch_storage.dart';
import 'puzzle_repository.dart';
import 'puzzle.dart';
import 'puzzle_theme.dart';
import 'puzzle_preferences.dart';

part 'puzzle_service.g.dart';
part 'puzzle_service.freezed.dart';

/// Size of puzzle local cache
const kPuzzleLocalQueueLength = 50;

@Riverpod(keepAlive: true)
PuzzleService puzzleService(PuzzleServiceRef ref, {required int queueLength}) {
  final storage = ref.watch(puzzleBatchStorageProvider);
  final repository = ref.watch(puzzleRepositoryProvider);
  return PuzzleService(
    ref,
    Logger('PuzzleService'),
    storage: storage,
    repository: repository,
    queueLength: queueLength,
  );
}

/// Puzzle service provider with the default queue length.
final defaultPuzzleServiceProvider = puzzleServiceProvider(
  queueLength: kPuzzleLocalQueueLength,
);

@freezed
class PuzzleContext with _$PuzzleContext {
  const factory PuzzleContext({
    required Puzzle puzzle,
    required PuzzleTheme theme,
    required UserId? userId,

    /// Current Glicko rating of the user if available.
    PuzzleGlicko? glicko,

    /// List of solved puzzle results if available.
    IList<PuzzleRound>? rounds,
  }) = _PuzzleContext;
}

class PuzzleService {
  const PuzzleService(
    this._ref,
    this._log, {
    required this.storage,
    required this.repository,
    required this.queueLength,
  });

  final PuzzleServiceRef _ref;
  final int queueLength;
  final PuzzleBatchStorage storage;
  final PuzzleRepository repository;
  final Logger _log;

  /// Loads the next puzzle from database and the glicko rating if available.
  ///
  /// Will sync with server if necessary.
  /// This future should never fail on network errors.
  Future<PuzzleContext?> nextPuzzle({
    required UserId? userId,
    PuzzleTheme angle = PuzzleTheme.mix,
  }) {
    return Result.release(
      _syncAndLoadData(userId, angle).map(
        (data) => data.item1 != null && data.item1!.unsolved.isNotEmpty
            ? PuzzleContext(
                puzzle: data.item1!.unsolved[0],
                theme: angle,
                userId: userId,
                glicko: data.item2,
                rounds: data.item3,
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
    PuzzleTheme angle = PuzzleTheme.mix,
  }) async {
    final data = await storage.fetch(
      userId: userId,
      angle: angle,
    );
    if (data != null) {
      await storage.save(
        userId: userId,
        angle: angle,
        data: PuzzleBatch(
          solved: IList([...data.solved, solution]),
          unsolved:
              data.unsolved.removeWhere((e) => e.puzzle.id == solution.id),
        ),
      );
      return nextPuzzle(userId: userId, angle: angle);
    }
    return Future.value(null);
  }

  /// Clears the current puzzle batch, fetches a new one and returns the next puzzle.
  Future<PuzzleContext?> resetBatch({
    required UserId? userId,
    PuzzleTheme angle = PuzzleTheme.mix,
  }) async {
    await storage.delete(userId: userId, angle: angle);
    return nextPuzzle(userId: userId, angle: angle);
  }

  /// Synchronize offline puzzle queue with server and gets latest data.
  ///
  /// This task will fetch missing puzzles so the queue length is always equal to
  /// `queueLength`.
  /// It will call [PuzzleRepository.solveBatch] if necessary.
  ///
  /// This method should never fail, as if the network is down it will fallback
  /// to the local database.
  FutureResult<Tuple3<PuzzleBatch?, PuzzleGlicko?, IList<PuzzleRound>?>>
      _syncAndLoadData(
    UserId? userId,
    PuzzleTheme angle,
  ) async {
    final data = await storage.fetch(
      userId: userId,
      angle: angle,
    );

    final unsolved = data?.unsolved ?? IList(const []);
    final solved = data?.solved ?? IList(const []);

    final deficit = max(0, queueLength - unsolved.length);

    _log.fine('Have a puzzle deficit of $deficit, will sync with lichess');

    final difficulty = _ref.read(puzzlePreferencesProvider(userId)).difficulty;

    // anonymous users can't solve puzzles so we just download the deficit
    // we send the request even if the deficit is 0 to get the glicko rating
    final batchResponse = solved.isNotEmpty && userId != null
        ? repository.solveBatch(
            nb: deficit,
            solved: solved,
            angle: angle,
            difficulty: difficulty,
          )
        : repository.selectBatch(
            nb: deficit,
            angle: angle,
            difficulty: difficulty,
          );

    return batchResponse
        .fold(
      (value) => Result.value(
        Tuple4(
          PuzzleBatch(
            solved: IList(const []),
            unsolved: IList([...unsolved, ...value.puzzles]),
          ),
          value.glicko,
          value.rounds,
          true, // should save the batch
        ),
      ),

      // we don't need to save the batch if the request failed
      (_, __) => Result.value(Tuple4(data, null, null, false)),
    )
        .flatMap((tuple) async {
      final newBatch = tuple.item1;
      final glitcho = tuple.item2;
      final rounds = tuple.item3;
      final shouldSave = tuple.item4;
      if (newBatch != null && shouldSave) {
        await storage.save(
          userId: userId,
          angle: angle,
          data: newBatch,
        );
      }
      return Result.value(Tuple3(newBatch, glitcho, rounds));
    });
  }
}
