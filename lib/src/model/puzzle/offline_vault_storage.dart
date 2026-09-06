import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:sqflite/sqflite.dart';

/// A provider for [OfflineVaultStorage].
final offlineVaultStorageProvider = FutureProvider<OfflineVaultStorage>((Ref ref) async {
  final database = await ref.watch(databaseProvider.future);
  return OfflineVaultStorage(database, ref);
}, name: 'OfflineVaultStorageProvider');

const _anonUserKey = '**anon**';

/// Row-per-puzzle store for large offline goals.
///
/// Small queues (<=1000) stay in `puzzle_batchs` blob. This table serves
/// large goals where a blob must not load all rows to read one.
/// `done=1` marks solved; sync pushes done in 50s then deletes done first.
class OfflineVaultStorage {
  const OfflineVaultStorage(this._db, this._ref);

  final Database _db;
  final Ref _ref;

  String _uid(UserId? userId) => userId?.value ?? _anonUserKey;

  /// Next unsolved puzzle: lowest rating first for stable order.
  Future<Map<String, Object?>?> fetchNext({required UserId? userId, String angle = 'mix'}) async {
    final rows = await _db.query(
      'offline_puzzles',
      where: 'userId = ? AND angle = ? AND done = 0',
      whereArgs: [_uid(userId), angle],
      orderBy: 'rating ASC, puzzleId ASC',
      limit: 1,
    );
    return rows.firstOrNull;
  }

  Future<int> countKept({required UserId? userId, String angle = 'mix'}) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) AS n FROM offline_puzzles WHERE userId = ? AND angle = ? AND done = 0',
      [_uid(userId), angle],
    );
    return (rows.first['n'] as num? ?? 0).toInt();
  }

  Future<int> countDone({required UserId? userId, String angle = 'mix'}) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) AS n FROM offline_puzzles WHERE userId = ? AND angle = ? AND done = 1',
      [_uid(userId), angle],
    );
    return (rows.first['n'] as num? ?? 0).toInt();
  }

  /// Done rows to push on reconnect, oldest first, max [limit] (use 50).
  Future<List<Map<String, Object?>>> fetchDoneBatch({
    required UserId? userId,
    String angle = 'mix',
    int limit = 50,
  }) async {
    return _db.query(
      'offline_puzzles',
      columns: ['puzzleId', 'win', 'rated'],
      where: 'userId = ? AND angle = ? AND done = 1',
      whereArgs: [_uid(userId), angle],
      orderBy: 'lastModified ASC',
      limit: limit,
    );
  }

  Future<void> markDone({
    required UserId? userId,
    required String puzzleId,
    required bool win,
    bool rated = true,
  }) async {
    await _db.update(
      'offline_puzzles',
      {'done': 1, 'win': win ? 1 : 0, 'rated': rated ? 1 : 0},
      where: 'userId = ? AND puzzleId = ?',
      whereArgs: [_uid(userId), puzzleId],
    );
    if (_ref.mounted) _ref.invalidateSelf();
  }

  /// Insert rows, skip ids already stored. Insert in one batch call.
  Future<void> insertBatch({
    required UserId? userId,
    required List<Map<String, Object?>> rows,
    String angle = 'mix',
  }) async {
    if (rows.isEmpty) return;
    final batch = _db.batch();
    for (final r in rows) {
      batch.insert('offline_puzzles', {
        'puzzleId': r['puzzleId'],
        'userId': _uid(userId),
        'angle': angle,
        'rating': r['rating'] ?? 0,
        'themes': r['themes'] ?? '',
        'fen': r['fen'] ?? '',
        'moves': r['moves'] ?? '',
        'data': r['data'] ?? '{}',
        'done': 0,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
    if (_ref.mounted) _ref.invalidateSelf();
  }

  /// Free space: delete pushed done rows first, then oldest unsolved past [keep].
  Future<void> prune({required UserId? userId, required int keep, String angle = 'mix'}) async {
    await _db.delete(
      'offline_puzzles',
      where: 'userId = ? AND angle = ? AND done = 1',
      whereArgs: [_uid(userId), angle],
    );
    final kept = await countKept(userId: userId, angle: angle);
    final over = kept - keep;
    if (over > 0) {
      await _db.rawDelete(
        '''DELETE FROM offline_puzzles WHERE rowid IN (
          SELECT rowid FROM offline_puzzles
          WHERE userId = ? AND angle = ? AND done = 0
          ORDER BY lastModified ASC LIMIT ?)''',
        [_uid(userId), angle, over],
      );
    }
    if (_ref.mounted) _ref.invalidateSelf();
  }

  Future<void> wipe({required UserId? userId, String angle = 'mix'}) async {
    await _db.delete(
      'offline_puzzles',
      where: 'userId = ? AND angle = ?',
      whereArgs: [_uid(userId), angle],
    );
    if (_ref.mounted) _ref.invalidateSelf();
  }
}
