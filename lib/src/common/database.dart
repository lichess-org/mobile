import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:lichess_mobile/src/app_dependencies.dart';

part 'database.g.dart';

Future<Database> openDb(DatabaseFactory dbFactory, String path) async {
  return dbFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE puzzle_batchs(
            userId TEXT NOT NULL,
            angle TEXT NOT NULL,
            data TEXT NOT NULL,
            PRIMARY KEY (userId, angle)
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
