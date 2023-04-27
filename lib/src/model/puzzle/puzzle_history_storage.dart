import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/db/database.dart';

import 'puzzle.dart';

part 'puzzle_history_storage.freezed.dart';
part 'puzzle_history_storage.g.dart';

@Riverpod(keepAlive: true)
PuzzleHistoryStorage puzzleHistoryStorage(PuzzleHistoryStorageRef ref) {
  final database = ref.watch(databaseProvider);
  return PuzzleHistoryStorage(database);
}

const _anonUserKey = '**anon**';
const _dbName = 'puzzle_history';

class PuzzleHistoryStorage {
  const PuzzleHistoryStorage(this._db);
  final Database _db;

  Future<IList<PuzzleAndResult>?> fetch({
    required UserId? userId,
    required PuzzleTheme angle,
    required DateTime date,
  }) async {
    final list = await _db.query(
      _dbName,
      where: '''
      userId = ? AND
      angle = ? AND
      solvedDate = ?
      ''',
      whereArgs: [
        userId?.value ?? _anonUserKey,
        angle.name,
        DateFormat('yyyy-MM-dd').format(date),
      ],
    );

    final raw = list.firstOrNull?['data'] as String?;
    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleHistoryStorage] cannot fetch puzzles: expected an object',
        );
      }
      return PuzzleHistoryData.fromJson(json).puzzles;
    }
    return null;
  }

  Future<Puzzle?> fetchPuzzle({
    required UserId? userId,
    required PuzzleTheme angle,
    required DateTime date,
    required PuzzleId puzzleId,
  }) async {
    final list = await _db.query(
      _dbName,
      where: '''
      userId = ?
      angle = ?
      date = ?
      ''',
      whereArgs: [
        userId?.value ?? _anonUserKey,
        angle.name,
        DateFormat('yyyy-MM-dd').format(date),
      ],
    );

    final raw = list.firstOrNull?['data'] as String?;
    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleHistoryStorage] cannot fetch puzzles: expected an object',
        );
      }
      return PuzzleHistoryData.fromJson(json)
          .puzzles
          .firstWhereOrNull((e) => e.puzzle.puzzle.id == puzzleId)
          ?.puzzle;
    }
    return null;
  }

  Future<IList<PuzzleHistory>?> fetchall({
    required UserId? userId,
  }) async {
    final list = await _db.query(
      _dbName,
      where: '''
      userId = ?
      ''',
      whereArgs: [
        userId?.value ?? _anonUserKey,
      ],
    );

    final history = list.map(
      (entry) {
        final raw = entry['data'] as String?;
        final angle = entry['angle'] as String?;
        final date = entry['solvedDate'] as String?;
        final json = jsonDecode(raw!);
        if (json is! Map<String, dynamic>) {
          throw const FormatException(
            '[PuzzleHistoryStorage] cannot fetch puzzles: expected an object',
          );
        }
        final data = PuzzleHistoryData.fromJson(json);
        return PuzzleHistory(
          puzzles: data.puzzles,
          angle: puzzleThemeNameMap[angle!]!,
          date: date!,
        );
      },
    ).toIList();

    return history.isEmpty ? null : history;
  }

  Future<void> save({
    required UserId? userId,
    required DateTime date,
    required PuzzleTheme angle,
    required IList<PuzzleAndResult> data,
  }) async {
    await _db.insert(
      _dbName,
      {
        'userId': userId?.value ?? _anonUserKey,
        'angle': angle.name,
        'data': jsonEncode(
          PuzzleHistoryData(puzzles: removeDuplicatePuzzles(data)).toJson(),
        ),
        'solvedDate': DateFormat('yyyy-MM-dd').format(date)
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

@Freezed(fromJson: true, toJson: true)
class PuzzleHistory with _$PuzzleHistory {
  const factory PuzzleHistory({
    required IList<PuzzleAndResult> puzzles,
    required String date,
    required PuzzleTheme angle,
  }) = _PuzzleHistory;

  factory PuzzleHistory.fromJson(Map<String, dynamic> json) =>
      _$PuzzleHistoryFromJson(json);
}

// only used for parsing and saving PuzzleAndResult from database
@Freezed(fromJson: true, toJson: true)
class PuzzleHistoryData with _$PuzzleHistoryData {
  const factory PuzzleHistoryData({
    required IList<PuzzleAndResult> puzzles,
  }) = _PuzzleHistoryData;

  factory PuzzleHistoryData.fromJson(Map<String, dynamic> json) =>
      _$PuzzleHistoryDataFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class PuzzleAndResult with _$PuzzleAndResult {
  const factory PuzzleAndResult({
    required Puzzle puzzle,
    required bool result,
  }) = _PuzzleAndResult;

  factory PuzzleAndResult.fromJson(Map<String, dynamic> json) =>
      _$PuzzleAndResultFromJson(json);
}

IList<PuzzleAndResult> removeDuplicatePuzzles(IList<PuzzleAndResult> data) =>
    data.toList().toSet().toIList();
