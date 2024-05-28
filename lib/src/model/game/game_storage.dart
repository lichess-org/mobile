import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'game_storage.g.dart';

@Riverpod(keepAlive: true)
GameStorage gameStorage(
  GameStorageRef ref,
) {
  final db = ref.watch(databaseProvider);
  return GameStorage(db);
}

@riverpod
Future<IList<StoredGame>> recentStoredGames(RecentStoredGamesRef ref) async {
  final session = ref.watch(authSessionProvider);
  final storage = ref.watch(gameStorageProvider);
  return storage.page(userId: session?.user.id);
}

const kGameStorageTable = 'game';

typedef StoredGame = ({
  UserId userId,
  DateTime lastModified,
  ArchivedGame game,
});

class GameStorage {
  const GameStorage(this._db);
  final Database _db;

  Future<IList<StoredGame>> page({
    UserId? userId,
    DateTime? until,
    int max = 20,
  }) async {
    final list = await _db.query(
      kGameStorageTable,
      where: [
        'userId = ?',
        if (until != null) 'lastModified < ?',
      ].join(' AND '),
      whereArgs: [
        userId ?? kStorageAnonId,
        if (until != null) until.toIso8601String(),
      ],
      orderBy: 'lastModified DESC',
      limit: max,
    );

    return list.map((e) {
      final raw = e['data']! as String;
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[GameStorage] cannot fetch game: expected an object',
        );
      }
      return (
        userId: UserId(e['userId']! as String),
        lastModified: DateTime.parse(e['lastModified']! as String),
        game: ArchivedGame.fromJson(json),
      );
    }).toIList();
  }

  Future<ArchivedGame?> fetch({
    required GameId gameId,
  }) async {
    final list = await _db.query(
      kGameStorageTable,
      where: 'gameId = ?',
      whereArgs: [gameId.toString()],
    );

    final raw = list.firstOrNull?['data'] as String?;

    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[GameStorage] cannot fetch game: expected an object',
        );
      }
      return ArchivedGame.fromJson(json);
    }
    return null;
  }

  Future<void> save(ArchivedGame game) async {
    await _db.insert(
      kGameStorageTable,
      {
        'userId': game.me?.user?.id.toString() ?? kStorageAnonId,
        'gameId': game.id.toString(),
        'lastModified': DateTime.now().toIso8601String(),
        'data': jsonEncode(game.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(GameId gameId) async {
    await _db.delete(
      kGameStorageTable,
      where: 'gameId = ?',
      whereArgs: [gameId.toString()],
    );
  }
}
