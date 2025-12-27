import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
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

class GameStorage {
  const GameStorage(this._db);
  final Database _db;

  Future<int> count({UserId? userId}) async {
    final list = await _db.query(
      kGameStorageTable,
      where: 'userId = ?',
      whereArgs: [userId ?? kStorageAnonId],
    );
    return list.length;
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

  Future<ExportedGame?> fetch({required GameId gameId}) async {
    final list = await _db.query(
      kGameStorageTable,
      where: 'gameId = ?',
      whereArgs: [gameId.toString()],
    );

    final raw = list.firstOrNull?['data'] as String?;

    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException('[GameStorage] cannot fetch game: expected an object');
      }
      return ExportedGame.fromJson(json);
    }
    return null;
  }

  Future<void> save(ExportedGame game) async {
    await _db.insert(kGameStorageTable, {
      'userId': game.me?.user?.id.toString() ?? kStorageAnonId,
      'gameId': game.id.toString(),
      'lastModified': DateTime.now().toIso8601String(),
      'data': jsonEncode(game.toJson()),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(GameId gameId) async {
    await _db.delete(kGameStorageTable, where: 'gameId = ?', whereArgs: [gameId.toString()]);
  }
}
