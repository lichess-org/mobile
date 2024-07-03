import 'dart:io';

import 'package:lichess_mobile/src/app_initialization.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'database.g.dart';

const kLichessDatabaseName = 'lichess_mobile.db';

const puzzleTTL = Duration(days: 60);
const corresGameTTL = Duration(days: 60);
const gameTTL = Duration(days: 90);
const chatReadMessagesTTL = Duration(days: 60);

const kStorageAnonId = '**anonymous**';

@Riverpod(keepAlive: true)
Database database(DatabaseRef ref) {
  // requireValue is possible because appInitializationProvider is loaded before
  // anything. See: lib/src/app.dart
  final db = ref.read(appInitializationProvider).requireValue.database;
  ref.onDispose(db.close);
  return db;
}

/// Returns the sqlite version as an integer.
@Riverpod(keepAlive: true)
Future<int?> sqliteVersion(SqliteVersionRef ref) async {
  final db = ref.read(databaseProvider);
  try {
    final versionStr = (await db.rawQuery('SELECT sqlite_version()'))
        .first
        .values
        .first
        .toString();
    final versionCells =
        versionStr.split('.').map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  } catch (_) {
    return null;
  }
}

@Riverpod(keepAlive: true)
Future<int> getDbSizeInBytes(GetDbSizeInBytesRef ref) async {
  final dbPath = join(await getDatabasesPath(), kLichessDatabaseName);
  final dbFile = File(dbPath);

  return dbFile.length();
}

/// Clears all database rows regardless of TTL.
Future<void> clearDatabase(Database db) async {
  await Future.wait([
    _deleteEntry(db, 'puzzle_batchs'),
    _deleteEntry(db, 'puzzle'),
    _deleteEntry(db, 'correspondence_game'),
    _deleteEntry(db, 'game'),
    _deleteEntry(db, 'chat_read_messages'),
  ]);
  await db.execute('VACUUM');
}

Future<Database> openDb(DatabaseFactory dbFactory, String path) async {
  return dbFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 2,
      onOpen: (db) async {
        await Future.wait([
          _deleteOldEntries(db, 'puzzle', puzzleTTL),
          _deleteOldEntries(db, 'correspondence_game', corresGameTTL),
          _deleteOldEntries(db, 'game', gameTTL),
          _deleteOldEntries(
            db,
            'chat_read_messages',
            chatReadMessagesTTL,
          ),
        ]);
      },
      onCreate: (db, version) async {
        final batch = db.batch();
        _createPuzzleBatchTableV1(batch);
        _createPuzzleTableV1(batch);
        _createCorrespondenceGameTableV1(batch);
        _createChatReadMessagesTableV1(batch);
        _createGameTableV2(batch);
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final batch = db.batch();
        if (oldVersion == 1) {
          _createGameTableV2(batch);
        }
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
    ),
  );
}

void _createPuzzleBatchTableV1(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS puzzle_batchs');
  batch.execute('''
    CREATE TABLE puzzle_batchs(
      userId TEXT NOT NULL,
      angle TEXT NOT NULL,
      data TEXT NOT NULL,
      PRIMARY KEY (userId, angle)
    )
    ''');
}

void _createPuzzleTableV1(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS puzzle');
  batch.execute('''
    CREATE TABLE puzzle(
    puzzleId TEXT NOT NULL,
    lastModified TEXT NOT NULL,
    data TEXT NOT NULL,
    PRIMARY KEY (puzzleId)
  )
    ''');
}

void _createCorrespondenceGameTableV1(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS correspondence_game');
  batch.execute('''
    CREATE TABLE correspondence_game(
    gameId TEXT NOT NULL,
    userId TEXT NOT NULL,
    lastModified TEXT NOT NULL,
    data TEXT NOT NULL,
    PRIMARY KEY (gameId)
  )
    ''');
}

void _createGameTableV2(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS game');
  batch.execute('''
    CREATE TABLE game(
    gameId TEXT NOT NULL,
    userId TEXT NOT NULL,
    lastModified TEXT NOT NULL,
    data TEXT NOT NULL,
    PRIMARY KEY (gameId)
  )
    ''');
}

void _createChatReadMessagesTableV1(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS chat_read_messages');
  batch.execute('''
    CREATE TABLE chat_read_messages(
    id TEXT NOT NULL,
    lastModified TEXT NOT NULL,
    nbRead INTEGER NOT NULL,
    PRIMARY KEY (id)
  )
    ''');
}

Future<void> _deleteOldEntries(Database db, String table, Duration ttl) async {
  final date = DateTime.now().subtract(ttl);

  if (!await _doesTableExist(db, table)) {
    return;
  }

  await db.delete(
    table,
    where: 'lastModified < ?',
    whereArgs: [date.toIso8601String()],
  );
}

Future<void> _deleteEntry(Database db, String table) async {
  if (!await _doesTableExist(db, table)) {
    return;
  }

  await db.delete(table);
}

Future<bool> _doesTableExist(Database db, String table) async {
  final tableExists = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'",
  );

  return tableExists.isNotEmpty;
}
