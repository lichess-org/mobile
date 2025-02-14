import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'http_log_storage.g.dart';

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
  Future<IList<HttpLog>> page({
    int offset = 0,
    int limit = 100,
  }) async {
    final list = await _db.query(
      kHttpLogStorageTable,
      limit: limit,
      offset: offset,
    );

    return list.map(HttpLog.fromMap).toIList();
  }

  /// Saves an [HttpLog] entry to the database.
  Future<void> save(HttpLog httpLog) async {
    await _db.insert(kHttpLogStorageTable, httpLog.toMap());
  }
}

/// Represents an HTTP log entry.
class HttpLog {
  final DateTime lastModified;
  final String requestMethod;
  final String requestUrl;
  final int? responseCode;
  final String? responseBody;

  /// Creates an instance of [HttpLog].
  HttpLog({
    required this.lastModified,
    required this.requestMethod,
    required this.requestUrl,
    this.responseCode,
    this.responseBody,
  });

  /// Creates an [HttpLog] from a map.
  factory HttpLog.fromMap(Map<String, dynamic> map) {
    return HttpLog(
      requestMethod: map['requestMethod'] as String,
      requestUrl: map['requestUrl'] as String,
      responseCode: map['responseCode'] as int?,
      responseBody: map['responseBody'] as String?,
      lastModified: DateTime.parse(map['lastModified'] as String),
    );
  }

  /// Converts the [HttpLog] to a map.
  Map<String, dynamic> toMap() {
    return {
      'requestMethod': requestMethod,
      'requestUrl': requestUrl,
      'responseCode': responseCode,
      'responseBody': responseBody,
      'lastModified': lastModified.toIso8601String(),
    };
  }
}
