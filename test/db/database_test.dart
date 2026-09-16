import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('App database v6', () {
    test('game table has composite index covering history paging', () async {
      final db = await openAppDatabase(databaseFactoryFfi, inMemoryDatabasePath);
      addTearDown(db.close);

      final indexes = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'game'",
      );
      expect(indexes.map((row) => row['name']), contains('idx_game_user_lastModified'));

      final plan = await db.rawQuery(
        'EXPLAIN QUERY PLAN SELECT * FROM game WHERE userId = ? ORDER BY lastModified DESC LIMIT 20',
        ['**anonymous**'],
      );
      final detail = plan.map((row) => row['detail']! as String).join(' ');
      expect(detail, contains('idx_game_user_lastModified'));
      expect(detail, isNot(contains('SCAN')));
    });
  });

  group('App database v8', () {
    test('an upgrade from v7 adds the practice progress table and keeps learn progress', () async {
      final dir = await Directory.systemTemp.createTemp('db_upgrade');
      addTearDown(() => dir.delete(recursive: true));
      final path = '${dir.path}/app.db';

      final v7 = await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 7,
          onCreate: (db, version) async {
            await db.execute(
              'CREATE TABLE learn_progress(stageKey TEXT NOT NULL, levelId INTEGER NOT NULL, '
              'score INTEGER NOT NULL, lastModified TEXT NOT NULL, syncedAt TEXT, '
              'PRIMARY KEY (stageKey, levelId))',
            );
            await db.insert('learn_progress', {
              'stageKey': 'rook',
              'levelId': 1,
              'score': 500,
              'lastModified': DateTime.now().toIso8601String(),
            });
          },
        ),
      );
      await v7.close();

      final db = await openAppDatabase(databaseFactoryFfi, path);
      addTearDown(db.close);

      expect(await db.getVersion(), 8);
      expect(await db.query('learn_progress'), hasLength(1));
      await db.insert('practice_progress', {
        'chapterId': 'dW7KIuoY',
        'nbMoves': 3,
        'lastModified': DateTime.now().toIso8601String(),
      });
      expect(await db.query('practice_progress'), hasLength(1));
    });
  });
}
