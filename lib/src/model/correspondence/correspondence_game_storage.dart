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
Future<IList<OfflineCorrespondenceGame>> offlineOngoingCorrespondenceGames(
  OfflineOngoingCorrespondenceGamesRef ref,
) async {
  final storage = ref.watch(correspondenceGameStorageProvider);
  return storage.fetchOngoingGames();
}

const _tableName = 'correspondence_game';

class CorrespondenceGameStorage {
  const CorrespondenceGameStorage(this._db, this.ref);
  final Database _db;
  final CorrespondenceGameStorageRef ref;

  Future<IList<OfflineCorrespondenceGame>> fetchOngoingGames() async {
    final list = await _db.query(
      _tableName,
      where: 'data LIKE ?',
      whereArgs: ['%"status":"started"%'],
    );

    return list.map((e) {
      final raw = e['data'] as String?;
      if (raw != null) {
        final json = jsonDecode(raw);
        if (json is! Map<String, dynamic>) {
          throw const FormatException(
            '[CorrespondenceGameStorage] cannot fetch game: expected an object',
          );
        }
        return OfflineCorrespondenceGame.fromJson(json);
      }
      throw const FormatException(
        '[CorrespondenceGameStorage] cannot fetch game: expected an object',
      );
    }).toIList();
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
}
