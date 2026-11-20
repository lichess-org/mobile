import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('Openings database', () {
    test('openings table has index on epd covering fetchFromFen', () async {
      final db = await databaseFactoryFfi.openDatabase(
        File('assets/chess_openings.db').absolute.path,
        options: OpenDatabaseOptions(readOnly: true),
      );
      addTearDown(db.close);

      final indexes = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'openings'",
      );
      expect(indexes.map((row) => row['name']), contains('idx_openings_epd'));

      final plan = await db.rawQuery(
        'EXPLAIN QUERY PLAN SELECT * FROM openings WHERE epd = ? LIMIT 1',
        ['rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -'],
      );
      final detail = plan.map((row) => row['detail']! as String).join(' ');
      expect(detail, contains('idx_openings_epd'));
      expect(detail, isNot(contains('SCAN')));
    });
  });
}
