import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:lichess_mobile/src/app_dependencies.dart';

part 'database.g.dart';

const puzzleStorageTTL = Duration(days: 60);

@Riverpod(keepAlive: true)
Database database(DatabaseRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  final db = ref.watch(
    appDependenciesProvider.select((data) => data.requireValue.database),
  );
  ref.onDispose(db.close);
  return db;
}

Future<Database> openDb(DatabaseFactory dbFactory, String path) async {
  return dbFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 2,
      onOpen: (db) async {
        final nDaysAgo = DateTime.now().subtract(puzzleStorageTTL);
        final tableExists = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='puzzle'",
        );
        if (tableExists.isNotEmpty) {
          await db.delete(
            'puzzle',
            where: 'lastModified < ?',
            whereArgs: [nDaysAgo.toIso8601String()],
          );
        }
      },
      onCreate: (db, version) async {
        final batch = db.batch();
        _createPuzzleBatchTableV2(batch);
        _createPuzzleTableV2(batch);
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final batch = db.batch();
        if (oldVersion == 1) {
          _createPuzzleTableV2(batch);
        }
        await batch.commit();
      },
    ),
  );
}

void _createPuzzleBatchTableV2(Batch batch) {
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

void _createPuzzleTableV2(Batch batch) {
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
