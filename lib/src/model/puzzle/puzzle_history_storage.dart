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
const _pageLimit = 10;

class PuzzleHistoryStorage {
  const PuzzleHistoryStorage(this._db);
  final Database _db;

  Future<Puzzle?> fetchPuzzle({
    required PuzzleId puzzleId,
  }) async {
    final list = await _db.query(
      _puzzleTable,
      where: "puzzleId = ?",
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

  Future<IList<PuzzleHistoryDay>?> fetchPuzzleHistoryPage({
    required UserId? userId,
    required int page,
  }) async {
    final historyList = await _db.query(
      _historyTable,
      where: 'userId = ?',
      whereArgs: [userId?.value ?? _anonUserKey],
      orderBy: 'solvedDate DESC',
      limit: _pageLimit,
      offset: page * _pageLimit,
    );

    final puzzleList = await _db.query(
      _puzzleTable,
    );

    final puzzles = _getPuzzleList(puzzleList);

    if (puzzles.isEmpty) return null;

    return historyList.map((entry) {
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
      final allPuzzles = data.puzzles.map((entry) {
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
      return PuzzleHistoryDay(
        puzzles: allPuzzles,
        day: DateTime.parse(date),
        angle: puzzleThemeNameMap[angle]!,
      );
    }).toIList();
  }

  Future<IList<PuzzleHistoryDay>?> fetchRecent({
    required UserId? userId,
  }) async {
    final historyList = await _db.query(
      _historyTable,
      where: 'userId = ?',
      whereArgs: [userId?.value ?? _anonUserKey],
      orderBy: 'solvedDate DESC',
      limit: _pageLimit,
    );
    final puzzles = _getPuzzleList(await _db.query(_puzzleTable));
    if (puzzles.isEmpty) return null;

    var totalPuzzles = 0;
    final first10 = <PuzzleHistoryDay>[];

    for (final entry in historyList) {
      final remaining = 10 - totalPuzzles;
      if (remaining <= 0) {
        break;
      }
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
      final allPuzzles = data.puzzles.map((entry) {
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

      final puzzleAndResult = allPuzzles.take(remaining).toIList();
      totalPuzzles += puzzleAndResult.length;

      first10.add(
        PuzzleHistoryDay(
          puzzles: puzzleAndResult,
          day: DateTime.parse(date),
          angle: puzzleThemeNameMap[angle]!,
        ),
      );
    }

    return first10.toIList();
  }

  Future<void> save({
    required UserId? userId,
    required PuzzleTheme angle,
    required bool result,
    required Puzzle puzzle,
  }) async {
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day, now.hour);

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

    var savedPuzzlesIds = IList<_PuzzleIdAndResult>();
    final raw = list.firstOrNull?['data'] as String?;
    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleHistoryStorage] cannot fetch puzzles: expected an object',
        );
      }
      savedPuzzlesIds = _PuzzleHistoryData.fromJson(json).puzzles;
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
              [
                if (savedPuzzlesIds.isNotEmpty) ...savedPuzzlesIds,
                _PuzzleIdAndResult(puzzleId: puzzle.puzzle.id, result: result)
              ],
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

  IList<Puzzle> _getPuzzleList(List<Map<String, Object?>> puzzleList) {
    return puzzleList.map((e) {
      final raw = e['data'] as String?;
      final json = jsonDecode(raw!);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleHistoryStorage] cannot fetch puzzles from $_puzzleTable: expected an object',
        );
      }
      return Puzzle.fromJson(json);
    }).toIList();
  }
}

@Freezed(fromJson: true, toJson: true)
class PuzzleHistoryDay with _$PuzzleHistoryDay {
  const factory PuzzleHistoryDay({
    required IList<PuzzleAndResult> puzzles,
    required DateTime day,
    required PuzzleTheme angle,
  }) = _PuzzleHistoryDay;

  factory PuzzleHistoryDay.fromJson(Map<String, dynamic> json) =>
      _$PuzzleHistoryDayFromJson(json);
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

// only used for parsing and saving PuzzleIdAndResult from database
@Freezed(fromJson: true, toJson: true)
class _PuzzleHistoryData with _$_PuzzleHistoryData {
  const factory _PuzzleHistoryData({
    required IList<_PuzzleIdAndResult> puzzles,
  }) = __PuzzleHistoryData;

  factory _PuzzleHistoryData.fromJson(Map<String, dynamic> json) =>
      _$_PuzzleHistoryDataFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class _PuzzleIdAndResult with _$_PuzzleIdAndResult {
  const factory _PuzzleIdAndResult({
    required PuzzleId puzzleId,
    required bool result,
  }) = __PuzzleIdAndResult;

  factory _PuzzleIdAndResult.fromJson(Map<String, dynamic> json) =>
      _$_PuzzleIdAndResultFromJson(json);
}
