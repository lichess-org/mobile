import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/http.dart';

class BroadcastRepository {
  BroadcastRepository(this.client);

  final http.Client client;

  Future<IList<Broadcast>> getBroadcasts() {
    return client.readNdJsonList(
      Uri(path: '/api/broadcast'),
      headers: {'Accept': 'application/x-ndjson'},
      mapper: _makeBroadcastFromJson,
    );
  }

  Future<IList<BroadcastGameSnapshot>> getRound(String broadcastRoundId) {
    return Future.delayed(const Duration(seconds: 5), () {
      return client.readJson(
        Uri(path: 'api/broadcast/-/-/$broadcastRoundId'),
        headers: {'Accept': 'application/x-ndjson'},
        mapper: _makeGamesFromJson,
      );
    });
  }
}

Broadcast _makeBroadcastFromJson(Map<String, dynamic> json) =>
    _broadcastFromPick(pick(json).required());

Broadcast _broadcastFromPick(RequiredPick pick) {
  return Broadcast(
    tour: Tour(
      name: pick('tour', 'name').asStringOrThrow(),
      description: pick('tour', 'description').asStringOrThrow(),
      imageUrl: pick('tour', 'image').asStringOrNull(),
    ),
    rounds: pick('rounds').asListOrEmpty(_roundFromPick).toIList(),
  );
}

Round _roundFromPick(RequiredPick pick) {
  final ongoing = pick('ongoing').asBoolOrFalse();
  final finished = pick('finished').asBoolOrFalse();
  final status = ongoing
      ? BroadcastStatus.ongoing
      : finished
          ? BroadcastStatus.finished
          : BroadcastStatus.upcoming;

  return Round(
    id: pick('id').asStringOrThrow(),
    status: status,
  );
}

IList<BroadcastGameSnapshot> _makeGamesFromJson(Map<String, dynamic> json) =>
    _gamesFromPick(pick(json).required());

IList<BroadcastGameSnapshot> _gamesFromPick(RequiredPick pick) =>
    pick('games').asListOrEmpty(_gameFromPick).toIList();

BroadcastGameSnapshot _gameFromPick(RequiredPick pick) {
  return BroadcastGameSnapshot(
    players: pick('players').asListOrThrow(_playerFromPick).toIList(),
    fen: pick('fen').asStringOrThrow(),
    lastMove: pick('lastMove').asUciMoveOrThrow(),
  );
}

BroadcastPlayer _playerFromPick(RequiredPick pick) {
  return BroadcastPlayer(
    name: pick('name').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrThrow(),
  );
}
