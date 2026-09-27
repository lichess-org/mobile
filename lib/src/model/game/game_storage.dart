import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/db/json_row.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:sqflite/sqflite.dart';

/// A provider for [GameStorage].
final gameStorageProvider = FutureProvider<GameStorage>((Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  return GameStorage(db);
}, name: 'GameStorageProvider');

const kGameStorageTable = 'game';

typedef StoredGame = ({UserId userId, DateTime lastModified, ExportedGame game});

class const GameStorage(final Database _db) {
  Future<int> count({UserId? userId}) async {
    final result = await _db.rawQuery(
      'SELECT COUNT(*) as cnt FROM $kGameStorageTable WHERE userId = ?',
      [userId ?? kStorageAnonId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Returns up to [max] games of [userId], newest first, that match [filter].
  ///
  /// The filter is applied in memory, so a batch of [max] rows can yield fewer results than
  /// requested: older rows are then fetched until the page is full or the storage is
  /// exhausted. That way callers can keep paginating with the last game of the page for as
  /// long as this returns a full page.
  Future<IList<StoredGame>> page({
    UserId? userId,
    DateTime? until,
    int max = 20,
    GameFilterState filter = const GameFilterState(),
  }) async {
    final results = <StoredGame>[];
    var cursor = until;
    while (results.length < max) {
      final rows = await _db.query(
        kGameStorageTable,
        where: ['userId = ?', if (cursor != null) 'lastModified < ?'].join(' AND '),
        whereArgs: [userId ?? kStorageAnonId, if (cursor != null) cursor.toIso8601String()],
        orderBy: 'lastModified DESC',
        limit: max,
      );
      if (rows.isEmpty) break;

      results.addAll(
        rows
            .map((e) {
              final raw = e['data']! as String;
              final json = jsonDecode(raw);
              if (json is! Map<String, dynamic>) {
                throw const FormatException('[GameStorage] cannot fetch game: expected an object');
              }
              return (
                userId: UserId(e['userId']! as String),
                lastModified: DateTime.parse(e['lastModified']! as String),
                game: ExportedGame.fromJson(json),
              );
            })
            .where((e) => filter.perfs.isEmpty || filter.perfs.contains(e.game.meta.perf))
            .where((e) => filter.side == null || filter.side == e.game.youAre)
            .where((e) => filter.result != GameResultFilter.won || e.game.isWonByMe),
      );

      if (rows.length < max) break;
      cursor = DateTime.parse(rows.last['lastModified']! as String);
    }

    return results.take(max).toIList();
  }

  Future<ExportedGame?> fetch({required GameId gameId}) {
    return _db.fetchJsonRow(
      table: kGameStorageTable,
      where: 'gameId = ?',
      whereArgs: [gameId.toString()],
      fromJson: ExportedGame.fromJson,
      errorMessage: '[GameStorage] cannot fetch game: expected an object',
    );
  }

  Future<void> save(ExportedGame game) {
    return _db.saveJsonRow(kGameStorageTable, {
      'userId': game.me?.user?.id.toString() ?? kStorageAnonId,
      'gameId': game.id.toString(),
      'lastModified': DateTime.now().toIso8601String(),
      'data': jsonEncode(game.toJson()),
    });
  }

  Future<void> delete(GameId gameId) {
    return _db.deleteJsonRow(
      kGameStorageTable,
      where: 'gameId = ?',
      whereArgs: [gameId.toString()],
    );
  }
}
