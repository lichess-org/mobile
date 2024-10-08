import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
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

  Future<BroadcastRoundGames> getRound(
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
  final roundId = pick('round', 'id').asBroadcastRoundIdOrThrow();

  return Broadcast(
    tour: (
      name: pick('tour', 'name').asStringOrThrow(),
      imageUrl: pick('tour', 'image').asStringOrNull(),
    ),
    round: BroadcastRound(
      id: roundId,
      name: pick('round', 'name').asStringOrThrow(),
      status: status,
      startsAt: pick('round', 'startsAt')
          .asDateTimeFromMillisecondsOrThrow()
          .toLocal(),
    ),
    group: pick('group').asStringOrNull(),
    roundToLinkId:
        pick('roundToLink', 'id').asBroadcastRoundIddOrNull() ?? roundId,
  );
}

BroadcastRoundGames _makeGamesFromJson(Map<String, dynamic> json) =>
    _gamesFromPick(pick(json).required());

BroadcastRoundGames _gamesFromPick(
  RequiredPick pick,
) =>
    IMap.fromEntries(pick('games').asListOrThrow(gameFromPick));

MapEntry<BroadcastGameId, BroadcastGameSnapshot> gameFromPick(
  RequiredPick pick,
) =>
    MapEntry(
      pick('id').asBroadcastGameIdOrThrow(),
      BroadcastGameSnapshot(
        players: IMap({
          Side.white: _playerFromPick(pick('players', 0).required()),
          Side.black: _playerFromPick(pick('players', 1).required()),
        }),
        fen: pick('fen').asStringOrNull() ??
            Variant.standard.initialPosition.fen,
        lastMove: pick('lastMove').asUciMoveOrNull(),
        status: pick('status').asStringOrThrow(),
        thinkTime: pick('thinkTime').asDurationFromSecondsOrNull(),
      ),
    );

BroadcastPlayer _playerFromPick(RequiredPick pick) {
  return BroadcastPlayer(
    name: pick('name').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    clock: pick('clock').asDurationFromCentiSecondsOrNull(),
    federation: pick('fed').asStringOrNull(),
  );
}
