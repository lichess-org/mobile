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

  Future<BroadcastList> getBroadcasts({int page = 1}) {
    return client.readJson(
      Uri(
        path: '/api/broadcast/top',
        queryParameters: {'page': page.toString()},
      ),
      mapper: _makeBroadcastResponseFromJson,
    );
  }

  Future<BroadcastTournament> getTournament(
    BroadcastTournamentId broadcastTournamentId,
  ) {
    return client.readJson(
      Uri(path: 'api/broadcast/$broadcastTournamentId'),
      mapper: _makeTournamentFromJson,
    );
  }

  Future<BroadcastRoundWithGames> getRound(
    BroadcastRoundId broadcastRoundId,
  ) {
    return client.readJson(
      Uri(path: 'api/broadcast/-/-/$broadcastRoundId'),
      // The path parameters with - are the broadcast tournament and round slugs
      // They are only used for SEO, so we can safely use - for these parameters
      mapper: _makeRoundWithGamesFromJson,
    );
  }

  Future<String> getGamePgn(
    BroadcastRoundId roundId,
    BroadcastGameId gameId,
  ) {
    return client.read(Uri(path: 'api/study/$roundId/$gameId.pgn'));
  }

  Future<IList<BroadcastPlayerExtended>> getPlayers(
    BroadcastTournamentId tournamentId,
  ) {
    return client.readJsonList(
      Uri(path: '/broadcast/$tournamentId/players'),
      mapper: _makePlayerFromJson,
    );
  }

  Future<BroadcastPlayerResults> getPlayerResults(
    BroadcastTournamentId tournamentId,
    String playerId,
  ) {
    return client.readJson(
      Uri(path: 'broadcast/$tournamentId/players/$playerId'),
      mapper: _makePlayerResultsFromJson,
    );
  }
}

BroadcastList _makeBroadcastResponseFromJson(
  Map<String, dynamic> json,
) {
  return (
    active: pick(json, 'active').asListOrThrow(_broadcastFromPick).toIList(),
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
        pick('roundToLink', 'id').asBroadcastRoundIdOrNull() ?? roundId,
  );
}

BroadcastTournamentData _tournamentDataFromPick(
  RequiredPick pick,
) =>
    BroadcastTournamentData(
      id: pick('id').asBroadcastTournamentIdOrThrow(),
      name: pick('name').asStringOrThrow(),
      slug: pick('slug').asStringOrThrow(),
      imageUrl: pick('image').asStringOrNull(),
      description: pick('description').asStringOrNull(),
      information: (
        format: pick('info', 'format').asStringOrNull(),
        timeControl: pick('info', 'tc').asStringOrNull(),
        players: pick('info', 'players').asStringOrNull(),
        location: pick('info', 'location').asStringOrNull(),
        dates: pick('dates').letOrNull(
          (pick) => (
            startsAt: pick(0).asDateTimeFromMillisecondsOrThrow(),
            endsAt: pick(1).asDateTimeFromMillisecondsOrNull(),
          ),
        ),
        website: pick('info', 'website')
            .letOrNull((p) => Uri.tryParse(p.asStringOrThrow())),
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
    slug: pick('slug').asStringOrThrow(),
    status: status,
    startsAt: pick('startsAt').asDateTimeFromMillisecondsOrNull(),
    finishedAt: pick('finishedAt').asDateTimeFromMillisecondsOrNull(),
    startsAfterPrevious: pick('startsAfterPrevious').asBoolOrFalse(),
  );
}

BroadcastRoundWithGames _makeRoundWithGamesFromJson(Map<String, dynamic> json) {
  final round = pick(json, 'round').required();
  final games = pick(json, 'games').required();
  return (round: _roundFromPick(round), games: _gamesFromPick(games));
}

BroadcastRoundGames _gamesFromPick(
  RequiredPick pick,
) =>
    IMap.fromEntries(pick.asListOrThrow(gameFromPick));

MapEntry<BroadcastGameId, BroadcastGame> gameFromPick(
  RequiredPick pick,
) {
  final stringStatus = pick('status').asStringOrNull();

  final status = (stringStatus == null)
      ? BroadcastResult.noResultPgnTag
      : switch (stringStatus) {
          '½-½' => BroadcastResult.draw,
          '1-0' => BroadcastResult.whiteWins,
          '0-1' => BroadcastResult.blackWins,
          '*' => BroadcastResult.ongoing,
          _ => throw FormatException(
              "value $stringStatus can't be interpreted as a broadcast result",
            )
        };

  /// The amount of time that the player whose turn it is has been thinking since his last move
  final thinkTime =
      pick('thinkTime').asDurationFromSecondsOrNull() ?? Duration.zero;

  return MapEntry(
    pick('id').asBroadcastGameIdOrThrow(),
    BroadcastGame(
      id: pick('id').asBroadcastGameIdOrThrow(),
      players: IMap({
        Side.white: _playerFromPick(pick('players', 0).required()),
        Side.black: _playerFromPick(pick('players', 1).required()),
      }),
      fen: pick('fen').asStringOrNull() ?? Variant.standard.initialPosition.fen,
      lastMove: pick('lastMove').asUciMoveOrNull(),
      status: status,
      updatedClockAt: DateTime.now().subtract(thinkTime),
    ),
  );
}

BroadcastPlayer _playerFromPick(RequiredPick pick) {
  return BroadcastPlayer(
    name: pick('name').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    clock: pick('clock').asDurationFromCentiSecondsOrNull(),
    federation: pick('fed').asStringOrNull(),
    fideId: pick('fideId').asFideIdOrNull(),
  );
}

BroadcastPlayerExtended _makePlayerFromJson(Map<String, dynamic> json) {
  return _playerExtendedFromPick(pick(json).required());
}

BroadcastPlayerExtended _playerExtendedFromPick(RequiredPick pick) {
  return BroadcastPlayerExtended(
    name: pick('name').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    federation: pick('fed').asStringOrNull(),
    fideId: pick('fideId').asFideIdOrNull(),
    played: pick('played').asIntOrThrow(),
    score: pick('score').asDoubleOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    performance: pick('performance').asIntOrNull(),
  );
}

BroadcastPlayerResults _makePlayerResultsFromJson(
  Map<String, dynamic> json,
) {
  return (
    player: _playerExtendedFromPick(pick(json).required()),
    fideData: _fideDataFromPick(pick(json, 'fide')),
    games:
        pick(json, 'games').asListOrThrow(_makePlayerResultFromPick).toIList()
  );
}

BroadcastFideData _fideDataFromPick(Pick pick) {
  return (
    ratings: (
      standard: pick('ratings', 'standard').asIntOrNull(),
      rapid: pick('ratings', 'rapid').asIntOrNull(),
      blitz: pick('ratings', 'blitz').asIntOrNull()
    ),
    birthYear: pick('year').asIntOrNull(),
  );
}

BroadcastPlayerResultData _makePlayerResultFromPick(RequiredPick pick) {
  final pointsString = pick('points').asStringOrNull();
  BroadcastPoints? points;
  if (pointsString == '1') {
    points = BroadcastPoints.one;
  } else if (pointsString == '1/2') {
    points = BroadcastPoints.half;
  } else if (pointsString == '0') {
    points = BroadcastPoints.zero;
  }

  return BroadcastPlayerResultData(
    roundId: pick('round').asBroadcastRoundIdOrThrow(),
    gameId: pick('id').asBroadcastGameIdOrThrow(),
    color: pick('color').asSideOrThrow(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    points: points,
    opponent: _playerFromPick(pick('opponent').required()),
  );
}
