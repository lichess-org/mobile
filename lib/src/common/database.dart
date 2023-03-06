import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'package:lichess_mobile/src/app_dependencies.dart';

part 'database.g.dart';

Future<Database> openDb() async {
  return openDatabase(
    p.join(await getDatabasesPath(), 'lichess_mobile.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE puzzle_batchs(userId TEXT PRIMARY KEY, angle TEXT, difficulty TEXT, data TEXT)',
      );
    },
    version: 1,
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
