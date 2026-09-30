import 'dart:convert';

import 'package:sqflite/sqflite.dart';

/// Helpers for tables that store a JSON document in a `data` column.
///
/// Several storages (games, correspondence games, puzzles, logs) share the same single-row
/// fetch/save/delete shape. These helpers implement it once, so the storages only declare
/// their table, key columns, and mapping functions.
extension JsonRowExtension on DatabaseExecutor {
  /// Reads the `data` column of the first row matching [where] and decodes it with [fromJson].
  ///
  /// Returns `null` when no row matches. Throws a [FormatException] with [errorMessage] when the
  /// stored value is not a JSON object.
  Future<T?> fetchJsonRow<T>({
    required String table,
    required String where,
    required List<Object?> whereArgs,
    required T Function(Map<String, dynamic>) fromJson,
    required String errorMessage,
    String column = 'data',
  }) async {
    final list = await query(table, columns: [column], where: where, whereArgs: whereArgs);
    final raw = list.firstOrNull?[column] as String?;
    if (raw == null) return null;
    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) {
      throw FormatException(errorMessage);
    }
    return fromJson(json);
  }

  /// Inserts or replaces a row, typically built from key columns plus a JSON-encoded `data` column.
  Future<void> saveJsonRow(String table, Map<String, Object?> values) {
    return insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Deletes the rows matching [where].
  Future<void> deleteJsonRow(
    String table, {
    required String where,
    required List<Object?> whereArgs,
  }) {
    return delete(table, where: where, whereArgs: whereArgs);
  }
}
