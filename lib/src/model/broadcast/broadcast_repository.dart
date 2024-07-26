import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/utils/json.dart';

class BroadcastRepository {
  BroadcastRepository(this.client);

  final LichessClient client;

  Future<BroadcastsList> getBroadcasts({int page = 1}) {
    return client.readJson(
      Uri(
        path: '/api/broadcast/top',
        queryParameters: {'page': page.toString()},
      ),
      headers: {'Accept': 'application/json'},
      mapper: _makeBroadcastResponseFromJson,
    );
  }

  Future<IList<BroadcastGameSnapshot>> getRound(
    BroadcastRoundId broadcastRoundId,
  ) {
    return client.readJson(
      Uri(path: 'api/broadcast/-/-/$broadcastRoundId'),
      // The path parameters with - are the broadcast tournament and round slug
      // They are only used for SEO, so we can safely use - for these parameters
      headers: {'Accept': 'application/x-ndjson'},
      mapper: _makeGamesFromJson,
    );
  }
}

BroadcastsList _makeBroadcastResponseFromJson(
  Map<String, dynamic> json,
) {
  return (
    active: pick(json, 'active').asListOrThrow(_broadcastFromPick).toIList(),
    upcoming:
        pick(json, 'upcoming').asListOrThrow(_broadcastFromPick).toIList(),
    past: pick(json, 'past', 'currentPageResults')
        .asListOrThrow(_broadcastFromPick)
        .toIList(),
    nextPage: pick(json, 'past', 'nextPage').asIntOrNull(),
  );
}

Broadcast _broadcastFromPick(RequiredPick pick) {
  final live = pick('round', 'ongoing').asBoolOrFalse();
  final finished = pick('round', 'finished').asBoolOrFalse();
  final status = live
      ? RoundStatus.live
      : finished
          ? RoundStatus.finished
          : RoundStatus.upcoming;

  return Broadcast(
    tour: (
      name: pick('tour', 'name').asStringOrThrow(),
      imageUrl: pick('tour', 'image').asStringOrNull(),
    ),
    round: BroadcastRound(
      id: pick('round', 'id').asBroadcastRoundIdOrThrow(),
      name: pick('round', 'name').asStringOrThrow(),
      status: status,
      startsAt: pick('round', 'startsAt')
          .asDateTimeFromMillisecondsOrThrow()
          .toLocal(),
    ),
    group: pick('group').asStringOrNull(),
  );
}

IList<BroadcastGameSnapshot> _makeGamesFromJson(Map<String, dynamic> json) =>
    _gamesFromPick(pick(json).required());

IList<BroadcastGameSnapshot> _gamesFromPick(RequiredPick pick) =>
    pick('games').asListOrEmpty(_gameFromPick).toIList();

BroadcastGameSnapshot _gameFromPick(RequiredPick pick) {
  return BroadcastGameSnapshot(
    players: pick('players').asListOrThrow(_playerFromPick).toIList(),
    fen: pick('fen').asStringOrNull() ?? Variant.standard.initialPosition.fen,
    lastMove: pick('lastMove').asUciMoveOrNull(),
    status: pick('status').asStringOrThrow(),
  );
}

BroadcastPlayer _playerFromPick(RequiredPick pick) {
  return BroadcastPlayer(
    name: pick('name').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    clock: pick('clock').asDurationFromCentiSecondsOrNull(),
    federation: pick('fed').asStringOrNull(),
  );
}
