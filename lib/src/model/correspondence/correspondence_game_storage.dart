import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import 'offline_correspondence_game.dart';

part 'correspondence_game_storage.g.dart';

@Riverpod(keepAlive: true)
CorrespondenceGameStorage correspondenceGameStorage(
  CorrespondenceGameStorageRef ref,
) {
  final db = ref.watch(databaseProvider);
  return CorrespondenceGameStorage(db, ref);
}

@riverpod
Future<IList<(DateTime, OfflineCorrespondenceGame)>>
    offlineOngoingCorrespondenceGames(
  OfflineOngoingCorrespondenceGamesRef ref,
) async {
  // cannot use ref.watch because it would create a circular dependency
  final storage = ref.read(correspondenceGameStorageProvider);
  return storage.fetchOngoingGames();
}

const _tableName = 'correspondence_game';

class CorrespondenceGameStorage {
  const CorrespondenceGameStorage(this._db, this.ref);
  final Database _db;
  final CorrespondenceGameStorageRef ref;

  Future<IList<(DateTime, OfflineCorrespondenceGame)>>
      fetchOngoingGames() async {
    final list = await _db.query(
      _tableName,
      where: "json_extract(data, '\$.status') LIKE ?",
      whereArgs: ['started%'],
    );

    return _decodeGames(list);
  }

  Future<IList<(DateTime, OfflineCorrespondenceGame)>>
      fetchGamesWithRegisteredMove() async {
    final list = await _db.query(
      _tableName,
      where: "json_extract(data, '\$.registeredMoveAtPgn') IS NOT NULL",
    );

    return _decodeGames(list);
  }

  Future<OfflineCorrespondenceGame?> fetch({
    required GameId gameId,
  }) async {
    final list = await _db.query(
      _tableName,
      where: 'gameId = ?',
      whereArgs: [gameId.toString()],
    );

    final raw = list.firstOrNull?['data'] as String?;

    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          '[CorrespondenceGameStorage] cannot fetch game: expected an object',
        );
      }
      return OfflineCorrespondenceGame.fromJson(json);
    }
    return null;
  }

  Future<void> save(OfflineCorrespondenceGame game) async {
    await _db.insert(
      _tableName,
      {
        'gameId': game.id.toString(),
        'lastModified': DateTime.now().toIso8601String(),
        'data': jsonEncode(game.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    ref.invalidate(offlineOngoingCorrespondenceGamesProvider);
  }

  IList<(DateTime, OfflineCorrespondenceGame)> _decodeGames(
    List<Map<String, Object?>> list,
  ) {
    return list.map((e) {
      final lmString = e['lastModified'] as String?;
      final raw = e['data'] as String?;
      if (raw != null && lmString != null) {
        final lastModified = DateTime.parse(lmString);
        final json = jsonDecode(raw);
        if (json is! Map<String, dynamic>) {
          throw const FormatException(
            '[CorrespondenceGameStorage] cannot fetch game: expected an object',
          );
        }
        return (lastModified, OfflineCorrespondenceGame.fromJson(json));
      }
      throw const FormatException(
        '[CorrespondenceGameStorage] cannot fetch game: expected an object',
      );
    }).toIList();
  }
}
