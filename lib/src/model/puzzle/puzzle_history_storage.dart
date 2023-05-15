import 'dart:convert';

import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:sqflite/sqflite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'puzzle_history_storage.g.dart';

@Riverpod(keepAlive: true)
PuzzleHistoryStorage puzzleHistoryStorage(PuzzleHistoryStorageRef ref) {
  final db = ref.watch(databaseProvider);
  return PuzzleHistoryStorage(db);
}

const _dbName = 'puzzle';

class PuzzleHistoryStorage {
  const PuzzleHistoryStorage(this._db);
  final Database _db;

  Future<Puzzle?> fetch({
    required PuzzleId puzzleId,
  }) async {
    final list = await _db.query(
      _dbName,
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

  Future<void> save({
    required Puzzle puzzle,
  }) async {
    await _db.insert(
      _dbName,
      {
        'puzzleId': puzzle.puzzle.id,
        'lastModified': DateTime.now().toIso8601String(),
        'data': jsonEncode(puzzle.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
