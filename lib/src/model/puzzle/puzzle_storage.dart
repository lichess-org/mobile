import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/db/json_row.dart';
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
  Future<Puzzle?> fetch({required PuzzleId puzzleId}) {
    return _db.fetchJsonRow(
      table: _tableName,
      where: 'puzzleId = ?',
      whereArgs: [puzzleId.toString()],
      fromJson: Puzzle.fromJson,
      errorMessage: '[PuzzleHistoryStorage] cannot fetch puzzle: expected an object',
    );
  }

  Future<void> save({required Puzzle puzzle}) {
    return _db.saveJsonRow(_tableName, {
      'puzzleId': puzzle.puzzle.id.toString(),
      'lastModified': DateTime.now().toIso8601String(),
      'data': jsonEncode(puzzle.toJson()),
    });
  }
}
