import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
const _historyTable = 'puzzle_history';
const _puzzleTable = 'puzzle';

class PuzzleHistoryStorage {
  const PuzzleHistoryStorage(this._db);
  final Database _db;

  Future<IList<PuzzleIdAndResult>?> fetch({
    required UserId? userId,
    required PuzzleTheme angle,
    required DateTime date,
  }) async {
    final list = await _db.query(
      _historyTable,
      where: '''
      userId = ? AND
      angle = ? AND
      solvedDate = ?
      ''',
      whereArgs: [
        userId?.value ?? _anonUserKey,
        angle.name,
        date.toIso8601String(),
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
      return _PuzzleHistoryData.fromJson(json).puzzles;
    }
    return null;
  }

  Future<Puzzle?> fetchPuzzle({
    required PuzzleId puzzleId,
  }) async {
    final list = await _db.query(
      _puzzleTable,
      where: '''
      puzzleId = ?
      ''',
      whereArgs: [puzzleId.toString()],
    );

    final raw = list.firstOrNull?['data'] as String?;
    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleHistoryStorage] cannot fetch puzzles: expected an object',
        );
      }
      return Puzzle.fromJson(json);
    }
    return null;
  }

  Future<IList<PuzzleHistory>?> fetchall({
    required UserId? userId,
  }) async {
    final list = await _db.query(
      _historyTable,
      where: '''
      userId = ?
      ''',
      whereArgs: [
        userId?.value ?? _anonUserKey,
      ],
    );

    final puzzleList = await _db.query(
      _puzzleTable,
    );

    final puzzles = puzzleList.map((e) {
      final raw = e['data'] as String?;
      final json = jsonDecode(raw!);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleHistoryStorage] cannot fetch puzzles from $_puzzleTable: expected an object',
        );
      }
      return Puzzle.fromJson(json);
    });

    if (puzzles.isEmpty) return null;
    final history = list.map(
      (entry) {
        final raw = entry['data'] as String?;
        final angle = entry['angle'] as String?;
        final date = entry['solvedDate'] as String?;
        if (raw == null || angle == null || date == null) {
          throw const FormatException(
            'PuzzleHistoryStorage: connot fetch puzzles: expected an object',
          );
        }
        final json = jsonDecode(raw);
        if (json is! Map<String, dynamic>) {
          throw const FormatException(
            '[PuzzleHistoryStorage] cannot fetch puzzles: expected an object',
          );
        }
        final data = _PuzzleHistoryData.fromJson(json);
        final puzzleAndResult = data.puzzles.map((entry) {
          return PuzzleAndResult(
            puzzle: puzzles.firstWhere(
              (p) => p.puzzle.id == entry.puzzleId,
              orElse: () => throw FormatException(
                '[PuzzleHistoryStorage] Cannot find puzzle ${entry.puzzleId}',
              ),
            ),
            result: entry.result,
          );
        }).toIList();
        return PuzzleHistory(
          puzzles: puzzleAndResult,
          angle: puzzleThemeNameMap[angle]!,
          date: DateTime.parse(date),
        );
      },
    ).toIList();

    return history.isEmpty ? null : history;
  }

  Future<void> save({
    required UserId? userId,
    required PuzzleTheme angle,
    required PuzzleIdAndResult data,
    required Puzzle puzzle,
  }) async {
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day);

    final list = await _db.query(
      _historyTable,
      where: '''
      userId = ? AND
      angle = ? AND
      solvedDate = ?
      ''',
      whereArgs: [
        userId?.value ?? _anonUserKey,
        angle.name,
        dateOnly.toIso8601String(),
      ],
    );

    var savedPuzzles = IList<PuzzleIdAndResult>();
    final raw = list.firstOrNull?['data'] as String?;
    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleHistoryStorage] cannot fetch puzzles: expected an object',
        );
      }
      savedPuzzles = _PuzzleHistoryData.fromJson(json).puzzles;
    }

    await _db.insert(
      _historyTable,
      {
        'userId': userId?.value ?? _anonUserKey,
        'angle': angle.name,
        'solvedDate': dateOnly.toIso8601String(),
        'data': jsonEncode(
          _PuzzleHistoryData(
            puzzles: IList(
              [if (savedPuzzles.isNotEmpty) ...savedPuzzles, data],
            ).toISet().toIList(),
          ).toJson(),
        ),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _db.insert(
      _puzzleTable,
      {
        'puzzleId': puzzle.puzzle.id.toString(),
        'lastModified': dateOnly.toIso8601String(),
        'data': jsonEncode(puzzle.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

@Freezed(fromJson: true, toJson: true)
class PuzzleHistory with _$PuzzleHistory {
  const factory PuzzleHistory({
    required IList<PuzzleAndResult> puzzles,
    required DateTime date,
    required PuzzleTheme angle,
  }) = _PuzzleHistory;

  factory PuzzleHistory.fromJson(Map<String, dynamic> json) =>
      _$PuzzleHistoryFromJson(json);
}

// only used for parsing and saving PuzzleIdAndResult from database
@Freezed(fromJson: true, toJson: true)
class _PuzzleHistoryData with _$_PuzzleHistoryData {
  const factory _PuzzleHistoryData({
    required IList<PuzzleIdAndResult> puzzles,
  }) = __PuzzleHistoryData;

  factory _PuzzleHistoryData.fromJson(Map<String, dynamic> json) =>
      _$_PuzzleHistoryDataFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class PuzzleIdAndResult with _$PuzzleIdAndResult {
  const factory PuzzleIdAndResult({
    required PuzzleId puzzleId,
    required bool result,
  }) = _PuzzleIdAndResult;

  factory PuzzleIdAndResult.fromJson(Map<String, dynamic> json) =>
      _$PuzzleIdAndResultFromJson(json);
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
