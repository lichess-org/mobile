import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'database.g.dart';

const puzzleHistoryTTL = Duration(days: 60);

Future<Database> openDb(DatabaseFactory dbFactory, String path) async {
  return dbFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onOpen: (db) async {
        var tableExists = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='puzzle_history'",
        );
        final nDaysAgo = DateTime.now().subtract(puzzleHistoryTTL);
        if (tableExists.isNotEmpty) {
          await db.delete(
            'puzzle_history',
            where: 'solvedDate < ?',
            whereArgs: [nDaysAgo.toIso8601String()],
          );
        }

        tableExists = await db.rawQuery(
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
        await db.execute('''
          CREATE TABLE puzzle_batchs(
            userId TEXT NOT NULL,
            angle TEXT NOT NULL,
            data TEXT NOT NULL,
            PRIMARY KEY (userId, angle)
          )
            ''');

        await db.execute(
          '''
            CREATE TABLE puzzle_history(
            userId TEXT NOT NULL,
            angle TEXT NOT NULL,
            solvedDate DATE NOT NULL,
            data TEXT NOT NULL,
            PRIMARY KEY (userId, angle, solvedDate)
          )
          ''',
        );

        await db.execute('''
          CREATE TABLE puzzle(
          puzzleId TEXT NOT NULL,
          lastModified DATE NOT NULL,
          data TEXT NOT NULL,
          PRIMARY KEY (puzzleId)
        )
          ''');
      },
    ),
  );
}

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
