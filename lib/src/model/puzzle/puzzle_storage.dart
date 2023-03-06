import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sqflite/sqflite.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/database.dart';

import 'puzzle.dart';
import 'puzzle_theme.dart';
import 'puzzle_difficulty.dart';

part 'puzzle_storage.freezed.dart';
part 'puzzle_storage.g.dart';

@Riverpod(keepAlive: true)
PuzzleStorage puzzleStorage(PuzzleStorageRef ref) {
  final database = ref.watch(databaseProvider);
  return PuzzleStorage(database);
}

class PuzzleStorage {
  const PuzzleStorage(this._db);

  final Database _db;

  Future<PuzzleLocalData?> fetch({
    required UserId? userId,
    PuzzleTheme angle = PuzzleTheme.mix,
    PuzzleDifficulty difficulty = PuzzleDifficulty.normal,
  }) async {
    final list = await _db.query(
      'puzzle_batchs',
      where: '''
      userId = ? AND
      angle = ? AND
      difficulty = ?
    ''',
      whereArgs: [
        userId?.value,
        angle.name,
        difficulty.name,
      ],
    );

    final raw = list.firstOrNull?['data'] as String?;

    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleStorage] cannot fetch puzzles: expected an object',
        );
      }
      return PuzzleLocalData.fromJson(json);
    }
    return null;
  }

  Future<void> save({
    required UserId? userId,
    PuzzleTheme angle = PuzzleTheme.mix,
    required PuzzleLocalData data,
  }) async {
    await _db.insert(
      'puzzle_batchs',
      {
        'userId': userId?.value,
        'angle': angle.name,
        'difficulty': PuzzleDifficulty.normal.name,
        'data': jsonEncode(data.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

@Freezed(fromJson: true, toJson: true)
class PuzzleLocalData with _$PuzzleLocalData {
  const factory PuzzleLocalData({
    required IList<PuzzleSolution> solved,
    required IList<Puzzle> unsolved,
  }) = _PuzzleLocalData;

  factory PuzzleLocalData.fromJson(Map<String, dynamic> json) =>
      _$PuzzleLocalDataFromJson(json);
}
