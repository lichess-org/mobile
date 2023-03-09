import 'dart:math' show max;
import 'package:logging/logging.dart';
import 'package:tuple/tuple.dart';
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'puzzle_storage.dart';
import 'puzzle_repository.dart';
import 'puzzle.dart';
import 'puzzle_theme.dart';
import 'puzzle_difficulty.dart';

part 'puzzle_service.g.dart';

/// Size of puzzle local cache
const kPuzzleLocalQueueLength = 100;

@Riverpod(keepAlive: true)
PuzzleService puzzleService(PuzzleServiceRef ref) {
  final storage = ref.watch(puzzleStorageProvider);
  final repository = ref.watch(puzzleRepositoryProvider);
  return PuzzleService(
    Logger('PuzzleService'),
    storage: storage,
    repository: repository,
  );
}

class PuzzleService {
  const PuzzleService(
    this._log, {
    required this.storage,
    required this.repository,
    this.queueLength = kPuzzleLocalQueueLength,
  });

  final int queueLength;
  final PuzzleStorage storage;
  final PuzzleRepository repository;
  final Logger _log;

  /// Loads the next puzzle from database. Will sync with server if necessary.
  ///
  /// This future should never fail on network errors.
  Future<Puzzle?> nextPuzzle({
    required UserId? userId,
    required PuzzleDifficulty difficulty,
    PuzzleTheme angle = PuzzleTheme.mix,
  }) {
    return Result.release(
      _syncAndLoadData(userId, angle, difficulty).map(
        (data) =>
            data != null && data.unsolved.isNotEmpty ? data.unsolved[0] : null,
      ),
    );
  }

  /// Update puzzle queue with the solved puzzle, sync with server and returns
  /// the next puzzle.
  ///
  /// This future should never fail on network errors.
  Future<Puzzle?> solve({
    required UserId? userId,
    required PuzzleDifficulty difficulty,
    required PuzzleSolution solution,
    PuzzleTheme angle = PuzzleTheme.mix,
  }) async {
    final data = await storage.fetch(
      userId: userId,
      angle: angle,
      difficulty: difficulty,
    );
    if (data != null) {
      await storage.save(
        userId: userId,
        angle: angle,
        difficulty: difficulty,
        data: PuzzleLocalData(
          solved: IList([...data.solved, solution]),
          unsolved:
              data.unsolved.removeWhere((e) => e.puzzle.id == solution.id),
        ),
      );
      return nextPuzzle(userId: userId, angle: angle, difficulty: difficulty);
    }
    return Future.value(null);
  }

  /// Synchronize offline puzzle queue with server and gets latest data.
  ///
  /// This task will fetch missing puzzles so the queue length is always equal to
  /// `queueLength`.
  /// It will call [PuzzleRepository.solveBatch] if necessary.
  ///
  /// This method should never fail, as if the network is down it will fallback
  /// to the local database.
  FutureResult<PuzzleLocalData?> _syncAndLoadData(
    UserId? userId,
    PuzzleTheme angle,
    PuzzleDifficulty difficulty,
  ) async {
    final data = await storage.fetch(
      userId: userId,
      angle: angle,
      difficulty: difficulty,
    );

    final unsolved = data?.unsolved ?? IList(const []);
    final solved = data?.solved ?? IList(const []);

    final deficit = max(0, queueLength - unsolved.length);

    if (deficit > 0) {
      _log.fine('Have a puzzle deficit of $deficit, will sync with lichess');

      // anonymous users can't solve puzzles so we just download the deficit
      final batchResult = solved.isNotEmpty && userId != null
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

      return batchResult
          .fold(
        (value) => Result.value(
          Tuple2(
            PuzzleLocalData(
              solved: IList(const []),
              unsolved: IList([...unsolved, ...value]),
            ),
            true,
          ),
        ),
        (_, __) => Result.value(Tuple2(data, false)),
      )
          .flatMap((tuple) async {
        final newData = tuple.item1;
        final shouldSave = tuple.item2;
        if (newData != null && shouldSave) {
          await storage.save(
            userId: userId,
            angle: angle,
            difficulty: difficulty,
            data: newData,
          );
        }
        return Result.value(newData);
      });
    }

    return Result.value(data);
  }
}
