import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'package:lichess_mobile/src/app_dependencies.dart';

part 'database.g.dart';

Future<Database> openDb(DatabaseFactory dbFactory, String path) async {
  return dbFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onOpen: (db) async {
        final tableExists = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='puzzle_history'",
        );
        if (tableExists.isNotEmpty) {
          final nDaysAgo = DateTime.now().subtract(const Duration(days: 60));
          await db.delete(
            'puzzle_history',
            where: 'solvedDate < ?',
            whereArgs: [DateFormat('yyyy-MM-dd').format(nDaysAgo)],
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
            data TEXT NOT NULL,
            solvedDate DATE NOT NULL,
            PRIMARY KEY (userId, angle, solvedDate)
          )
          ''',
        );
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
