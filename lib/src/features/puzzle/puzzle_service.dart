import 'dart:math' show max;
import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;
import 'package:fpdart/fpdart.dart';

import './data/puzzle_local_db.dart';
import './data/puzzle_repository.dart';
import './model/puzzle.dart';

final puzzleOfflineServiceProvider = Provider<PuzzleService>((ref) {
  final db = ref.watch(puzzleLocalDbProvider);
  final repository = ref.watch(puzzleRepositoryProvider);
  return PuzzleService(Logger('PuzzleService'), db: db, repository: repository);
});

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
  Future<Puzzle?> nextPuzzle({String? userId, String angle = 'mix'}) async {
    final data = await _syncAndLoadData(userId, angle).run();
    return data?.unsolved[0];
  }

  /// Update puzzle queue with the solved puzzle and sync with server
  Future<void> solve({
    String? userId,
    String angle = 'mix',
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
      await _syncAndLoadData(userId, angle).run();
    }
  }

  /// Synchronize offline puzzle queue with server and gets latest data.
  ///
  /// This task will fetch missing puzzles so the queue length is always equal to
  /// `localQueueLength`.
  /// It will also call the `solveBatchTask` with solved puzzles.
  Task<PuzzleLocalData?> _syncAndLoadData(String? userId, String angle) {
    final data = db.fetch(userId: userId, angle: angle);

    final unsolved = data?.unsolved ?? IList(const []);
    final solved = data?.solved ?? IList(const []);

    final deficit = max(0, localQueueLength - unsolved.length);

    if (deficit > 0) {
      _log.fine('Have a puzzle deficit of $deficit, will sync with lichess');

      final repoTask = solved.isNotEmpty
          ? repository.solveBatchTask(nb: deficit, solved: solved, angle: angle)
          : repository.selectBatchTask(nb: deficit, angle: angle);

      return repoTask
          .match(
            (_) => Tuple2(data, false),
            (data) => Tuple2(
                PuzzleLocalData(
                    solved: IList(const []),
                    unsolved: IList([...unsolved, ...data])),
                true),
          )
          .flatMap((tuple) => Task(() async {
                final newData = tuple.first;
                final shouldSave = tuple.second;
                if (newData != null && shouldSave) {
                  await db.save(
                    userId: userId,
                    angle: angle,
                    data: newData,
                  );
                }
                return newData;
              }));
    }

    return Task.of(data);
  }
}
