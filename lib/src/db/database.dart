import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'database.g.dart';

const puzzleTTL = Duration(days: 60);
const corresGameTTL = Duration(days: 60);

@Riverpod(keepAlive: true)
Database database(DatabaseRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  final db = ref.read(appDependenciesProvider).requireValue.database;
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

Future<Database> openDb(DatabaseFactory dbFactory, String path) async {
  return dbFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 3,
      onOpen: (db) async {
        await _deleteOldEntries(db, 'puzzle', puzzleTTL);
        await _deleteOldEntries(db, 'correspondence_game', corresGameTTL);
      },
      onCreate: (db, version) async {
        final batch = db.batch();
        _createPuzzleBatchTableV3(batch);
        _createPuzzleTableV3(batch);
        _createCorrespondenceGameTableV3(batch);
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final batch = db.batch();
        if (oldVersion == 1) {
          _createPuzzleTableV3(batch);
          _createCorrespondenceGameTableV3(batch);
        }
        if (oldVersion == 2) {
          _createCorrespondenceGameTableV3(batch);
        }
        await batch.commit();
      },
    ),
  );
}

void _createPuzzleBatchTableV3(Batch batch) {
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

void _createPuzzleTableV3(Batch batch) {
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

void _createCorrespondenceGameTableV3(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS correspondence_game');
  batch.execute('''
    CREATE TABLE correspondence_game(
    gameId TEXT NOT NULL,
    lastModified TEXT NOT NULL,
    data TEXT NOT NULL,
    PRIMARY KEY (gameId)
  )
    ''');
}

Future<void> _deleteOldEntries(Database db, String table, Duration ttl) async {
  final date = DateTime.now().subtract(ttl);
  final tableExists = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'",
  );
  if (tableExists.isEmpty) {
    return;
  }
  await db.delete(
    table,
    where: 'lastModified < ?',
    whereArgs: [date.toIso8601String()],
  );
}
