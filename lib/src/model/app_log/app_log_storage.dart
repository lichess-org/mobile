import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';

part 'app_log_storage.g.dart';
part 'app_log_storage.freezed.dart';

/// Provides an instance of [AppLogStorage] using Riverpod.
final appLogStorageProvider = FutureProvider<AppLogStorage>((Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  return AppLogStorage(db);
}, name: 'AppLogStorageProvider');

const kAppLogStorageTable = 'app_log';

/// Manages the storage of app logs in a SQLite database.
class AppLogStorage {
  const AppLogStorage(this._db);
  final Database _db;

  /// Retrieves a paginated list of [AppLogEntry] entries from the database.
  ///
  /// If [minLevelValue] is provided, only entries with a level value greater than
  /// or equal to [minLevelValue] are returned.
  Future<AppLogPage> page({int? cursor, int? minLevelValue, int limit = 100}) async {
    final whereClause = [
      if (cursor != null) 'id <= $cursor',
      if (minLevelValue != null) 'levelValue >= $minLevelValue',
    ];
    final res = await _db.query(
      kAppLogStorageTable,
      limit: limit + 1,
      orderBy: 'id DESC',
      where: whereClause.isNotEmpty ? whereClause.join(' AND ') : null,
    );
    return AppLogPage(
      items: res.take(limit).map(AppLogEntry.fromJson).toIList(),
      next: res.elementAtOrNull(limit)?['id'] as int?,
    );
  }

  /// Saves an [AppLogEntry] to the database.
  Future<void> save(AppLogEntry entry) async {
    await _db.insert(kAppLogStorageTable, {
      ...entry.toJson(),
      'lastModified': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Deletes all app log entries from the database.
  Future<void> deleteAll() async {
    await _db.delete(kAppLogStorageTable);
  }
}

/// Represents a persisted app log entry.
@Freezed(fromJson: true, toJson: true)
sealed class AppLogEntry with _$AppLogEntry {
  const AppLogEntry._();

  const factory AppLogEntry({
    required DateTime logTime,
    required String loggerName,
    required int levelValue,
    required String levelName,
    required String message,
    String? error,
    String? stackTrace,
  }) = _AppLogEntry;

  factory AppLogEntry.fromLogRecord(LogRecord record) => AppLogEntry(
    logTime: record.time,
    loggerName: record.loggerName,
    levelValue: record.level.value,
    levelName: record.level.name,
    message: record.message,
    error: record.error?.toString(),
    stackTrace: record.stackTrace?.toString(),
  );

  factory AppLogEntry.fromJson(Map<String, dynamic> json) => _$AppLogEntryFromJson(json);
}

/// A paginated collection of app log entries.
@freezed
sealed class AppLogPage with _$AppLogPage {
  const factory AppLogPage({required IList<AppLogEntry> items, required int? next}) = _AppLogPage;
}
