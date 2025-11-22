import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:sqflite/sqflite.dart';

/// A provider for [CorrespondenceGameStorage].
final correspondenceGameStorageProvider = FutureProvider<CorrespondenceGameStorage>((
  Ref ref,
) async {
  final db = await ref.watch(databaseProvider.future);
  return CorrespondenceGameStorage(db, ref);
}, name: 'CorrespondenceGameStorageProvider');

/// Fetches all ongoing offline correspondence games, sorted by whose turn it is and last modified time.
final offlineOngoingCorrespondenceGamesProvider =
    FutureProvider.autoDispose<IList<(DateTime, OfflineCorrespondenceGame)>>((Ref ref) async {
      final session = ref.watch(authSessionProvider);
      // cannot use ref.watch because it would create a circular dependency
      // as we invalidate this provider in the storage save and delete methods
      final storage = await ref.read(correspondenceGameStorageProvider.future);
      final data = await storage.fetchOngoingGames(session?.user.id);
      return data.sort((a, b) {
        final aIsMyTurn = a.$2.isMyTurn;
        final bIsMyTurn = b.$2.isMyTurn;
        if (aIsMyTurn && !bIsMyTurn) return -1;
        if (!aIsMyTurn && bIsMyTurn) return 1;
        return b.$1.compareTo(a.$1);
      });
    }, name: 'OfflineOngoingCorrespondenceGamesProvider');

const kCorrespondenceStorageTable = 'correspondence_game';

const kCorrespondenceStorageAnonId = '**anonymous**';

class CorrespondenceGameStorage {
  const CorrespondenceGameStorage(this._db, this.ref);
  final Database _db;
  final Ref ref;

  /// Fetches all ongoing correspondence games, sorted by time left.
  Future<IList<(DateTime, OfflineCorrespondenceGame)>> fetchOngoingGames(UserId? userId) async {
    final list = await _db.query(
      kCorrespondenceStorageTable,
      where: 'userId = ? AND data LIKE ?',
      whereArgs: ['${userId ?? kCorrespondenceStorageAnonId}', '%"status":"started"%'],
    );

    return _decodeGames(list).sort((a, b) {
      final (aLastModified, aGame) = a;
      final (bLastModified, bGame) = b;
      final aTimeLeft = aGame.myTimeLeft(aLastModified);
      final bTimeLeft = bGame.myTimeLeft(bLastModified);
      if (aTimeLeft == null || bTimeLeft == null) {
        return 0;
      } else {
        return aTimeLeft.compareTo(bTimeLeft);
      }
    });
  }

  /// Fetches all correspondence games with a registered move.
  Future<IList<(DateTime, OfflineCorrespondenceGame)>> fetchGamesWithRegisteredMove(
    UserId? userId,
  ) async {
    try {
      final list = await _db.query(
        kCorrespondenceStorageTable,
        where: "json_extract(data, '\$.registeredMoveAtPgn') IS NOT NULL",
      );
      return _decodeGames(list);
    } catch (e) {
      final list = await _db.query(
        kCorrespondenceStorageTable,
        where: 'userId = ? AND data LIKE ?',
        whereArgs: ['${userId ?? kCorrespondenceStorageAnonId}', '%status":"started"%'],
      );

      return _decodeGames(list).where((e) {
        final (_, game) = e;
        return game.registeredMoveAtPgn != null;
      }).toIList();
    }
  }

  Future<OfflineCorrespondenceGame?> fetch({required GameId gameId}) async {
    final list = await _db.query(
      kCorrespondenceStorageTable,
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
    try {
      await _db.insert(kCorrespondenceStorageTable, {
        'userId': game.me?.user?.id.toString() ?? kCorrespondenceStorageAnonId,
        'gameId': game.id.toString(),
        'lastModified': DateTime.now().toIso8601String(),
        'data': jsonEncode(game.toJson()),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      ref.invalidate(offlineOngoingCorrespondenceGamesProvider);
    } catch (e) {
      debugPrint('[CorrespondenceGameStorage] failed to save game: $e');
    }
  }

  Future<void> delete(GameId gameId) async {
    await _db.delete(
      kCorrespondenceStorageTable,
      where: 'gameId = ?',
      whereArgs: [gameId.toString()],
    );
    ref.invalidate(offlineOngoingCorrespondenceGamesProvider);
  }

  IList<(DateTime, OfflineCorrespondenceGame)> _decodeGames(List<Map<String, Object?>> list) {
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
