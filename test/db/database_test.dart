import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:path/path.dart' as p;
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
    test('correspondence table denormalizes status and registered move behind indexes', () async {
      final db = await openAppDatabase(databaseFactoryFfi, inMemoryDatabasePath);
      addTearDown(db.close);

      final columns = await db.rawQuery('PRAGMA table_info(correspondence_game)');
      expect(columns.map((row) => row['name']), containsAll(['status', 'hasRegisteredMove']));

      final indexes = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'correspondence_game'",
      );
      expect(
        indexes.map((row) => row['name']),
        containsAll([
          'idx_correspondence_game_user_status',
          'idx_correspondence_game_user_hasRegisteredMove',
        ]),
      );

      final ongoingPlan = await db.rawQuery(
        'EXPLAIN QUERY PLAN SELECT * FROM correspondence_game WHERE userId = ? AND status = ?',
        ['**anonymous**', 'started'],
      );
      final ongoingDetail = ongoingPlan.map((row) => row['detail']! as String).join(' ');
      expect(ongoingDetail, contains('idx_correspondence_game_user_status'));
      expect(ongoingDetail, isNot(contains('SCAN')));

      final registeredPlan = await db.rawQuery(
        'EXPLAIN QUERY PLAN SELECT * FROM correspondence_game WHERE userId = ? AND hasRegisteredMove = 1',
        ['**anonymous**'],
      );
      final registeredDetail = registeredPlan.map((row) => row['detail']! as String).join(' ');
      expect(registeredDetail, contains('idx_correspondence_game_user_hasRegisteredMove'));
      expect(registeredDetail, isNot(contains('SCAN')));
    });

    test('upgrade from v7 backfills status and registered move from JSON data', () async {
      final dir = await Directory.systemTemp.createTemp('correspondence_db_test');
      addTearDown(() => dir.delete(recursive: true));
      final path = p.join(dir.path, 'lichess_mobile.db');

      final oldDb = await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 7,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE correspondence_game(
              gameId TEXT NOT NULL,
              userId TEXT NOT NULL,
              lastModified TEXT NOT NULL,
              data TEXT NOT NULL,
              PRIMARY KEY (gameId)
            )
            ''');
          },
        ),
      );
      final now = DateTime.now().toIso8601String();
      await oldDb.insert('correspondence_game', {
        'gameId': 'game1',
        'userId': 'user1',
        'lastModified': now,
        'data': '{"status":"started","registeredMoveAtPgn":["e2e4","e2e4"]}',
      });
      await oldDb.insert('correspondence_game', {
        'gameId': 'game2',
        'userId': 'user1',
        'lastModified': now,
        'data': '{"status":"resign"}',
      });
      await oldDb.close();

      final db = await openAppDatabase(databaseFactoryFfi, path);
      addTearDown(db.close);

      final rows = await db.query('correspondence_game', orderBy: 'gameId');
      expect(rows.length, 2);
      expect(rows[0]['status'], 'started');
      expect(rows[0]['hasRegisteredMove'], 1);
      expect(rows[1]['status'], 'resign');
      expect(rows[1]['hasRegisteredMove'], 0);
    });
  });
}
