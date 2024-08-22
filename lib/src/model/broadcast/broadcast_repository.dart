import 'package:dartchess/dartchess.dart';
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

  Future<BroadcastTournament> getTournament(
    BroadcastTournamentId broadcastTournamentId,
  ) {
    return client.readJson(
      Uri(path: 'api/broadcast/$broadcastTournamentId'),
      headers: {'Accept': 'application/json'},
      mapper: _makeTournamentFromJson,
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
  final roundId = pick('round', 'id').asBroadcastRoundIdOrThrow();

  return Broadcast(
    tour: _tournamentDataFromPick(pick('tour').required()),
    round: _roundFromPick(pick('round').required()),
    group: pick('group').asStringOrNull(),
    roundToLinkId:
        pick('roundToLink', 'id').asBroadcastRoundIddOrNull() ?? roundId,
  );
}

BroadcastTournamentData _tournamentDataFromPick(
  RequiredPick pick,
) =>
    BroadcastTournamentData(
      id: pick('id').asBroadcastTournamentIdOrThrow(),
      name: pick('name').asStringOrThrow(),
      imageUrl: pick('image').asStringOrNull(),
      description: pick('description').asStringOrThrow(),
      information: (
        format: pick('info', 'format').asStringOrNull(),
        timeControl: pick('info', 'tc').asStringOrNull(),
        players: pick('info', 'players').asStringOrNull(),
        dates: pick('dates').letOrNull(
          (pick) => (
            startsAt: pick(0).asDateTimeFromMillisecondsOrThrow().toLocal(),
            endsAt: pick(1).asDateTimeFromMillisecondsOrNull()?.toLocal(),
          ),
        ),
      ),
    );

BroadcastTournament _makeTournamentFromJson(
  Map<String, dynamic> json,
) {
  return BroadcastTournament(
    data: _tournamentDataFromPick(pick(json, 'tour').required()),
    rounds: pick(json, 'rounds').asListOrThrow(_roundFromPick).toIList(),
    defaultRoundId: pick(json, 'defaultRoundId').asBroadcastRoundIdOrThrow(),
    group: pick(json, 'group', 'tours')
        .asListOrNull(_tournamentGroupFromPick)
        ?.toIList(),
  );
}

BroadcastTournamentGroup _tournamentGroupFromPick(RequiredPick pick) {
  final id = pick('id').asBroadcastTournamentIdOrThrow();
  final name = pick('name').asStringOrThrow();

  return (id: id, name: name);
}

BroadcastRound _roundFromPick(RequiredPick pick) {
  final live = pick('ongoing').asBoolOrFalse();
  final finished = pick('finished').asBoolOrFalse();
  final status = live
      ? RoundStatus.live
      : finished
          ? RoundStatus.finished
          : RoundStatus.upcoming;

  return BroadcastRound(
    id: pick('id').asBroadcastRoundIdOrThrow(),
    name: pick('name').asStringOrThrow(),
    status: status,
    startsAt: pick('startsAt').asDateTimeFromMillisecondsOrNull()?.toLocal(),
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
