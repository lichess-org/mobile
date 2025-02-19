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
  final db = await ref.read(databaseProvider.future);
  return HttpLogStorage(db);
}

const kHttpLogStorageTable = 'http_log';

/// Manages the storage of HTTP logs in a SQLite database.
class HttpLogStorage {
  const HttpLogStorage(this._db);
  final Database _db;

  /// Retrieves a paginated list of [HttpLog] entries from the database.
  Future<HttpLogs> page({int? cursor, int limit = 100}) async {
    final res = await _db.query(
      kHttpLogStorageTable,
      limit: limit + 1,
      orderBy: 'httpLogId DESC',
      where: cursor != null ? 'httpLogId <= $cursor' : null,
    );
    final items = res.map(HttpLog.fromJson).toList();
    final next = items.elementAtOrNull(limit);
    items.remove(next);
    return HttpLogs(items: items.toIList(), next: next?.httpLogId);
  }

  /// Saves an [HttpLog] entry to the database.
  Future<void> save(HttpLog httpLog) async {
    await _db.insert(
      kHttpLogStorageTable,
      httpLog.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> deleteAll() async {
    await _db.delete(kHttpLogStorageTable);
  }
}

/// Represents an HTTP log entry.
@Freezed(fromJson: true, toJson: true)
class HttpLog with _$HttpLog {
  const factory HttpLog({
   int? httpLogId,
   required String requestHashCode,
   required String requestMethod,
   required String requestUrl,
   int? responseCode,
   String? responseBody,
   required DateTime lastModified,
  }) = _HttpLog;

  factory HttpLog.fromJson(Map<String, dynamic> json) => _$HttpLogFromJson(json);
}

/// A class representing a collection of HTTP logs.
///
/// The `HttpLogs` class contains the following properties:
/// - `items`: A required list of `HttpLog` items.
/// - `next`: An optional integer representing the next cursor.
@Freezed(fromJson: true, toJson: true)
class HttpLogs with _$HttpLogs {
  const factory HttpLogs({
    required IList<HttpLog> items,
    required int? next,
  }) = _HttpLogs;

  factory HttpLogs.fromJson(Map<String, dynamic> json) => _$HttpLogsFromJson(json);
}
