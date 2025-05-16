import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'http_log_storage.g.dart';
part 'http_log_storage.freezed.dart';

/// Provides an instance of [HttpLogStorage] using Riverpod.
@Riverpod(keepAlive: true)
Future<HttpLogStorage> httpLogStorage(Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  return HttpLogStorage(db);
}

const kHttpLogStorageTable = 'http_log';

/// Manages the storage of HTTP logs in a SQLite database.
class HttpLogStorage {
  const HttpLogStorage(this._db);
  final Database _db;

  /// Retrieves a paginated list of [HttpLogEntry] entries from the database.
  Future<HttpLog> page({int? cursor, int limit = 100}) async {
    final res = await _db.query(
      kHttpLogStorageTable,
      limit: limit + 1,
      orderBy: 'id DESC',
      where: cursor != null ? 'id <= $cursor' : null,
    );
    return HttpLog(
      items: res.take(limit).map(HttpLogEntry.fromJson).toIList(),
      next: res.elementAtOrNull(limit)?['id'] as int?,
    );
  }

  /// Saves an [HttpLogEntry] entry to the database.
  Future<void> save(HttpLogEntry httpLog) async {
    await _db.insert(kHttpLogStorageTable, {
      ...httpLog.toJson(),
      'lastModified': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateWithResponse(
    String httpLogId, {
    required int responseCode,
    required DateTime responseDateTime,
  }) async {
    await _db.update(
      kHttpLogStorageTable,
      {
        'responseCode': responseCode,
        'responseDateTime': responseDateTime.toIso8601String(),
        'lastModified': DateTime.now().toIso8601String(),
      },
      where: 'httpLogId = ?',
      whereArgs: [httpLogId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateWithError(String httpLogId, {String? errorMessage}) async {
    await _db.update(
      kHttpLogStorageTable,
      {
        'responseCode': 0,
        'lastModified': DateTime.now().toIso8601String(),
        'errorMessage': errorMessage,
      },
      where: 'httpLogId = ?',
      whereArgs: [httpLogId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteAll() async {
    await _db.delete(kHttpLogStorageTable);
  }
}

/// Represents an HTTP log entry.
@Freezed(fromJson: true, toJson: true)
sealed class HttpLogEntry with _$HttpLogEntry {
  const HttpLogEntry._();

  const factory HttpLogEntry({
    required String httpLogId,
    required String requestMethod,
    @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson) required Uri requestUrl,
    required DateTime requestDateTime,
    int? responseCode,
    DateTime? responseDateTime,
    String? errorMessage,
  }) = _HttpLogEntry;

  bool get hasResponse => responseCode != null && responseCode != 0;

  Duration? get elapsed {
    if (responseDateTime == null) return null;
    return responseDateTime!.difference(requestDateTime);
  }

  factory HttpLogEntry.fromJson(Map<String, dynamic> json) => _$HttpLogEntryFromJson(json);
}

String _urlToJson(Uri url) => url.toString();
Uri _urlFromJson(String url) => Uri.parse(url);

/// A class representing a collection of HTTP logs.
///
/// The `HttpLog` class contains the following properties:
/// - `items`: A required list of `HttpLog` items.
/// - `next`: An optional integer representing the next cursor.
@Freezed(fromJson: true, toJson: true)
sealed class HttpLog with _$HttpLog {
  const factory HttpLog({required IList<HttpLogEntry> items, required int? next}) = _HttpLog;

  factory HttpLog.fromJson(Map<String, dynamic> json) => _$HttpLogFromJson(json);
}
