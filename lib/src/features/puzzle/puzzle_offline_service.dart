import 'dart:math' show max;
import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import './data/puzzle_local_db.dart';
import './data/puzzle_repository.dart';
import './model/puzzle.dart';

final puzzleOfflineServiceProvider = Provider<PuzzleOfflineService>((ref) {
  final db = ref.watch(puzzleLocalDbProvider);
  final repository = ref.watch(puzzleRepositoryProvider);
  return PuzzleOfflineService(Logger('PuzzleOfflineService'),
      db: db, repository: repository);
});

class PuzzleOfflineService {
  const PuzzleOfflineService(
    this._log, {
    required this.db,
    required this.repository,
  });

  final PuzzleLocalDB db;
  final PuzzleRepository repository;
  final Logger _log;

  /// Synchronize offline puzzle queue with server.
  ///
  /// This task will fetch missing puzzles so the queue length is always equal to
  /// `kPuzzleBufferLength`.
  /// It will also call the `solveBatchTask` with solved puzzles.
  TaskEither<IOError, List<Puzzle>> _sync(
      {String? userId, String angle = 'mix'}) {
    final data = db.fetch(userId: userId, angle: angle);

    final unsolved = data?.unsolved ?? IList(const []);
    final solved = data?.solved ?? IList(const []);

    final deficit = max(0, kPuzzleBufferLength - unsolved.length);

    if (deficit > 0) {
      final task = solved.isNotEmpty
          ? repository.solveBatchTask(nb: deficit, solved: solved, angle: angle)
          : repository.selectBatchTask(nb: deficit, angle: angle);

      return task.flatMap(
        (data) => TaskEither(() async {
          await db.save(
              userId: userId,
              angle: angle,
              data: PuzzleLocalData(
                  solved: IList(const []),
                  unsolved: IList([...unsolved, ...data])));
          return Either.right(data);
        }),
      );
    }

    return TaskEither.right([]);
  }
}
