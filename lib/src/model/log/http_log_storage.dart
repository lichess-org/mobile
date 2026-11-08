import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:sqflite/sqflite.dart';

part 'http_log_storage.g.dart';
part 'http_log_storage.freezed.dart';

/// Provides an instance of [HttpLogStorage] using Riverpod.
final httpLogStorageProvider = FutureProvider<HttpLogStorage>((Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  return HttpLogStorage(db);
}, name: 'HttpLogStorageProvider');

const kHttpLogStorageTable = 'http_log';

/// Manages the storage of HTTP logs in a SQLite database.
class const HttpLogStorage(final Database _db) {
  /// Retrieves a paginated list of [HttpLogEntry] entries from the database.
  ///
  /// [searchQuery] filters entries whose request method, URL, or error message contain the query.
  Future<HttpLog> page({int? cursor, String? searchQuery, int limit = 100}) async {
    final whereParts = <String>[];
    final args = <dynamic>[];

    if (cursor != null) {
      whereParts.add('id <= ?');
      args.add(cursor);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereParts.add('(requestMethod LIKE ? OR requestUrl LIKE ? OR errorMessage LIKE ?)');
      final pattern = '%$searchQuery%';
      args.addAll([pattern, pattern, pattern]);
    }

    final res = await _db.query(
      kHttpLogStorageTable,
      limit: limit + 1,
      orderBy: 'id DESC',
      where: whereParts.isNotEmpty ? whereParts.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
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
    required HttpLogCache? cache,
  }) async {
    await _db.update(
      kHttpLogStorageTable,
      {
        'responseCode': responseCode,
        'responseDateTime': responseDateTime.toIso8601String(),
        'cache': cache?.name,
        'lastModified': DateTime.now().toIso8601String(),
      },
      where: 'httpLogId = ?',
      whereArgs: [httpLogId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Sets the size of the response body, once it has been fully received.
  Future<void> updateWithResponseSize(String httpLogId, {required int responseSize}) async {
    await _db.update(
      kHttpLogStorageTable,
      {'responseSize': responseSize, 'lastModified': DateTime.now().toIso8601String()},
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

/// The http client cache that served a response.
enum HttpLogCache() {
  /// The in-memory cache of the http clients.
  memory,

  /// The on-disk cache of the image http client.
  disk,
}

/// Represents an HTTP log entry.
@Freezed(fromJson: true, toJson: true)
sealed class const HttpLogEntry._() with _$HttpLogEntry {
  const factory({
    required String httpLogId,
    required String requestMethod,
    @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson) required Uri requestUrl,
    required DateTime requestDateTime,
    int? responseCode,
    DateTime? responseDateTime,
    String? errorMessage,

    /// The http client cache that served the response, or `null` if it came from the network.
    HttpLogCache? cache,

    /// The size in bytes of the response body, once it has been fully received.
    int? responseSize,
  }) = _HttpLogEntry;

  bool get hasResponse => responseCode != null && responseCode != 0;

  bool get fromCache => cache != null;

  Duration? get elapsed {
    if (responseDateTime == null) return null;
    return responseDateTime!.difference(requestDateTime);
  }

  factory fromJson(Map<String, dynamic> json) => _$HttpLogEntryFromJson(json);
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
  const factory({required IList<HttpLogEntry> items, required int? next}) = _HttpLog;

  factory fromJson(Map<String, dynamic> json) => _$HttpLogFromJson(json);
}
