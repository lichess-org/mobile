import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:sqflite/sqflite.dart';

part 'puzzle_batch_storage.freezed.dart';
part 'puzzle_batch_storage.g.dart';

/// A provider for [PuzzleBatchStorage].
final puzzleBatchStorageProvider = FutureProvider<PuzzleBatchStorage>((Ref ref) async {
  final database = await ref.watch(databaseProvider.future);
  return PuzzleBatchStorage(database, ref);
}, name: 'PuzzleBatchStorageProvider');

const _anonUserKey = '**anon**';
const _tableName = 'puzzle_batchs';

final _themeKeys = puzzleThemeNameMap.keys.toList(growable: false);
final _themeKeysPlaceholders = List.filled(_themeKeys.length, '?').join(', ');

/// Counts the unsolved puzzles of a raw batch.
int _nbUnsolved(String raw) {
  final json = jsonDecode(raw);
  if (json is! Map<String, dynamic> || json['unsolved'] is! List) {
    throw const FormatException('[PuzzleBatchStorage] cannot count puzzles: expected an object');
  }
  return (json['unsolved']! as List<dynamic>).length;
}

/// Local storage for puzzles.
class PuzzleBatchStorage {
  const PuzzleBatchStorage(this._db, this._ref);

  final Database _db;
  final Ref _ref;

  Future<PuzzleBatch?> fetch({
    required UserId? userId,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
  }) async {
    final list = await _db.query(
      _tableName,
      where: '''
      userId = ? AND
      angle = ?
    ''',
      whereArgs: [userId ?? _anonUserKey, angle.key],
    );

    final raw = list.firstOrNull?['data'] as String?;

    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[PuzzleBatchStorage] cannot fetch puzzles: expected an object',
        );
      }
      return PuzzleBatch.fromJson(json);
    }
    return null;
  }

  Future<void> save({
    required UserId? userId,
    required PuzzleBatch data,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
  }) async {
    await _db.insert(_tableName, {
      'userId': userId ?? _anonUserKey,
      'angle': angle.key,
      'data': jsonEncode(data.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    if (_ref.mounted) _ref.invalidateSelf();
  }

  Future<void> delete({
    required UserId? userId,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
  }) async {
    await _db.delete(
      _tableName,
      where: '''
      userId = ? AND
      angle = ?
    ''',
      whereArgs: [userId ?? _anonUserKey, angle.key],
    );
    if (_ref.mounted) _ref.invalidateSelf();
  }

  /// Fetches the angles of all saved puzzle batches (except mix) for the given user.
  Future<IList<PuzzleAngle>> fetchAllAngles({required UserId? userId}) async {
    final list = await _db.query(
      _tableName,
      columns: ['angle'],
      where: 'userId = ?',
      whereArgs: [userId ?? _anonUserKey],
      orderBy: 'lastModified DESC',
    );
    return list
        .map((entry) {
          final angleStr = entry['angle'] as String?;

          if (angleStr == null) return null;

          final angle = PuzzleAngle.fromKey(angleStr);

          if (angle == const PuzzleTheme(PuzzleThemeKey.mix)) return null;

          return angle;
        })
        .nonNulls
        .toIList();
  }

  /// Fetches the number of unsolved puzzles saved for each theme of the given user.
  Future<IMap<PuzzleThemeKey, int>> fetchSavedThemes({required UserId? userId}) async {
    final list = await _db.query(
      _tableName,
      columns: ['angle', 'data'],
      where: 'userId = ? AND angle IN ($_themeKeysPlaceholders)',
      whereArgs: [userId ?? _anonUserKey, ..._themeKeys],
    );

    return list.fold<IMap<PuzzleThemeKey, int>>(IMap<PuzzleThemeKey, int>(const {}), (acc, map) {
      final angle = map['angle'] as String?;
      final raw = map['data'] as String?;

      final theme = angle != null ? puzzleThemeNameMap.get(angle) : null;

      return theme != null && raw != null ? acc.add(theme, _nbUnsolved(raw)) : acc;
    });
  }

  /// Fetches the keys of all saved opening batches for the given user.
  ///
  /// Counting their puzzles is left to [fetchNbUnsolved], because the openings list only displays
  /// a handful of them at a time.
  Future<ISet<String>> fetchSavedOpenings({required UserId? userId}) async {
    final list = await _db.query(
      _tableName,
      columns: ['angle'],
      where: 'userId = ? AND angle NOT IN ($_themeKeysPlaceholders)',
      whereArgs: [userId ?? _anonUserKey, ..._themeKeys],
    );

    return list.map((map) => map['angle'] as String?).nonNulls.toISet();
  }

  /// Returns the number of unsolved puzzles saved for [angle], or 0 if it has no saved batch.
  Future<int> fetchNbUnsolved({required UserId? userId, required PuzzleAngle angle}) async {
    final list = await _db.query(
      _tableName,
      columns: ['data'],
      where: 'userId = ? AND angle = ?',
      whereArgs: [userId ?? _anonUserKey, angle.key],
    );

    final raw = list.firstOrNull?['data'] as String?;

    return raw != null ? _nbUnsolved(raw) : 0;
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class PuzzleBatch with _$PuzzleBatch {
  const factory PuzzleBatch({
    required IList<PuzzleSolution> solved,
    required IList<Puzzle> unsolved,
  }) = _PuzzleBatch;

  factory PuzzleBatch.fromJson(Map<String, dynamic> json) => _$PuzzleBatchFromJson(json);
}
