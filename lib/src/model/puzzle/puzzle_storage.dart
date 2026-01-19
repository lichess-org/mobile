import 'dart:convert';

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

  Future<void> save({required Puzzle puzzle}) async {
    await _db.insert(_tableName, {
      'puzzleId': puzzle.puzzle.id.toString(),
      'lastModified': DateTime.now().toIso8601String(),
      'data': jsonEncode(puzzle.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
