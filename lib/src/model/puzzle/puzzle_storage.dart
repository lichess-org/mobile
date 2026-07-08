import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:sqflite/sqflite.dart';

/// A provider for [PuzzleStorage].
final puzzleStorageProvider = FutureProvider<PuzzleStorage>((Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  return PuzzleStorage(db);
}, name: 'PuzzleStorageProvider');

const _tableName = 'puzzle';

/// Local storage for puzzles.
class PuzzleStorage {
  const PuzzleStorage(this._db);
  final Database _db;

  Future<Puzzle?> fetch({required PuzzleId puzzleId}) async {
    final list = await _db.query(
      _tableName,
      where: 'puzzleId = ?',
      whereArgs: [puzzleId.toString()],
    );

    final raw = list.firstOrNull?['data'] as String?;

    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleHistoryStorage] cannot fetch puzzle: expected an object',
        );
      }
      return Puzzle.fromJson(json);
    }
    return null;
  }

  /// Returns which of [ids] are already stored, in a single query.
  Future<ISet<PuzzleId>> cachedPuzzleIds({required IList<PuzzleId> ids}) async {
    if (ids.isEmpty) return ISet();
    final placeholders = List.filled(ids.length, '?').join(', ');
    final rows = await _db.query(
      _tableName,
      columns: ['puzzleId'],
      where: 'puzzleId IN ($placeholders)',
      whereArgs: [for (final id in ids) id.toString()],
    );
    return ISet(rows.map((row) => PuzzleId(row['puzzleId']! as String)));
  }

  Future<void> save({required Puzzle puzzle}) async {
    await _db.insert(_tableName, {
      'puzzleId': puzzle.puzzle.id.toString(),
      'lastModified': DateTime.now().toIso8601String(),
      'data': jsonEncode(puzzle.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Saves [puzzles] in a single transaction.
  Future<void> saveAll({required IList<Puzzle> puzzles}) async {
    final batch = _db.batch();
    final lastModified = DateTime.now().toIso8601String();
    for (final puzzle in puzzles) {
      batch.insert(_tableName, {
        'puzzleId': puzzle.puzzle.id.toString(),
        'lastModified': lastModified,
        'data': jsonEncode(puzzle.toJson()),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
