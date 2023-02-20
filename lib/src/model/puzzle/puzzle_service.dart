import 'dart:math' show max;
import 'package:logging/logging.dart';
import 'package:tuple/tuple.dart';
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'puzzle_local_db.dart';
import 'puzzle_repository.dart';
import 'puzzle.dart';
import 'puzzle_theme.dart';

part 'puzzle_service.g.dart';

@Riverpod(keepAlive: true)
PuzzleService puzzleOfflineService(PuzzleOfflineServiceRef ref) {
  final db = ref.watch(puzzleLocalDBProvider);
  final repository = ref.watch(puzzleRepositoryProvider);
  return PuzzleService(Logger('PuzzleService'), db: db, repository: repository);
}

class PuzzleService {
  const PuzzleService(
    this._log, {
    required this.db,
    required this.repository,
    this.localQueueLength = kPuzzleLocalQueueLength,
  });

  final int localQueueLength;
  final PuzzleLocalDB db;
  final PuzzleRepository repository;
  final Logger _log;

  /// Loads the next puzzle from database. Will sync with server if necessary.
  ///
  /// This future should never fail on network errors.
  Future<Puzzle?> nextPuzzle({
    String? userId,
    PuzzleTheme angle = PuzzleTheme.mix,
  }) {
    return Result.release(
      _syncAndLoadData(userId, angle).map((data) => data?.unsolved[0]),
    );
  }

  /// Update puzzle queue with the solved puzzle and sync with server
  ///
  /// This future should never fail on network errors.
  Future<void> solve({
    String? userId,
    PuzzleTheme angle = PuzzleTheme.mix,
    required PuzzleSolution solution,
  }) async {
    final data = db.fetch(userId: userId, angle: angle);
    if (data != null) {
      await db.save(
        userId: userId,
        angle: angle,
        data: PuzzleLocalData(
          solved: IList([...data.solved, solution]),
          unsolved:
              data.unsolved.removeWhere((e) => e.puzzle.id == solution.id),
        ),
      );
      await _syncAndLoadData(userId, angle);
    }
  }

  /// Synchronize offline puzzle queue with server and gets latest data.
  ///
  /// This task will fetch missing puzzles so the queue length is always equal to
  /// `localQueueLength`.
  /// It will also call the `solveBatchTask` with solved puzzles.
  ///
  /// This method should never fail, as if the network is down it will fallback
  /// to the local database.
  FutureResult<PuzzleLocalData?> _syncAndLoadData(
    String? userId,
    PuzzleTheme angle,
  ) {
    final data = db.fetch(userId: userId, angle: angle);

    final unsolved = data?.unsolved ?? IList(const []);
    final solved = data?.solved ?? IList(const []);

    final deficit = max(0, localQueueLength - unsolved.length);

    if (deficit > 0) {
      _log.fine('Have a puzzle deficit of $deficit, will sync with lichess');

      final batchResult = solved.isNotEmpty
          ? repository.solveBatch(nb: deficit, solved: solved, angle: angle)
          : repository.selectBatch(nb: deficit, angle: angle);

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
          await db.save(
            userId: userId,
            angle: angle,
            data: newData,
          );
        }
        return Result.value(newData);
      });
    }

    return Future.value(Result.value(data));
  }
}
