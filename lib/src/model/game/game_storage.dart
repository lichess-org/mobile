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

  Future<IList<StoredGame>> page({
    UserId? userId,
    DateTime? until,
    int max = 20,
    GameFilterState filter = const GameFilterState(),
  }) async {
    final list = await _db.query(
      kGameStorageTable,
      where: ['userId = ?', if (until != null) 'lastModified < ?'].join(' AND '),
      whereArgs: [userId ?? kStorageAnonId, if (until != null) until.toIso8601String()],
      orderBy: 'lastModified DESC',
      limit: max,
    );

    return list
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
        .toIList();
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
