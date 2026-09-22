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
class const PuzzleStorage(final Database _db) {
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

  /// Returns the ids among [ids] that are not stored.
  Future<IList<PuzzleId>> missingIds(IList<PuzzleId> ids) async {
    if (ids.isEmpty) return ids;
    final rows = await _db.query(
      _tableName,
      columns: ['puzzleId'],
      where: 'puzzleId IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids.map((id) => id.toString()).toList(),
    );
    final stored = rows.map((row) => row['puzzleId']! as String).toSet();
    return ids.where((id) => !stored.contains(id.toString())).toIList();
  }

  Future<void> save({required Puzzle puzzle}) => saveAll([puzzle]);

  Future<void> saveAll(Iterable<Puzzle> puzzles) async {
    final batch = _db.batch();
    final now = DateTime.now().toIso8601String();
    for (final puzzle in puzzles) {
      batch.insert(_tableName, {
        'puzzleId': puzzle.puzzle.id.toString(),
        'lastModified': now,
        'data': jsonEncode(puzzle.toJson()),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
