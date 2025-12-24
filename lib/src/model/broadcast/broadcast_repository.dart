import 'package:clock/clock.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/json.dart';

/// A provider for the [BroadcastRepository].
final broadcastRepositoryProvider = Provider<BroadcastRepository>((ref) {
  final client = ref.watch(lichessClientProvider);
  final aggregator = ref.watch(aggregatorProvider);
  return BroadcastRepository(client, aggregator);
}, name: 'BroadcastRepositoryProvider');

class BroadcastRepository {
  BroadcastRepository(this.client, this.aggregator);

  final LichessClient client;
  final Aggregator aggregator;

  Future<BroadcastList> getBroadcasts({int page = 1}) {
    return aggregator.readJson(
      Uri(path: '/api/broadcast/top', queryParameters: {'page': page.toString()}),
      atomicMapper: broadcastListFromServerJson,
    );
  }

  Future<BroadcastSearchList> searchBroadcasts({required String searchTerm, int page = 1}) {
    return client.readJson(
      Uri(
        path: '/api/broadcast/search',
        queryParameters: {'q': searchTerm, 'page': page.toString()},
      ),
      mapper: _makeBroadcastSearchResponseFromJson,
    );
  }

  Future<BroadcastTournament> getTournament(BroadcastTournamentId broadcastTournamentId) {
    return client.readJson(
      Uri(path: 'api/broadcast/$broadcastTournamentId'),
      mapper: _makeTournamentFromJson,
    );
  }

  Future<BroadcastRoundResponse> getRound(BroadcastRoundId broadcastRoundId) {
    return client.readJson(
      Uri(path: 'api/broadcast/-/-/$broadcastRoundId'),
      // The path parameters with - are the broadcast tournament and round slugs
      // They are only used for SEO, so we can safely use - for these parameters
      mapper: _makeRoundWithGamesFromJson,
    );
  }

  Future<String> getGamePgn(BroadcastRoundId roundId, BroadcastGameId gameId) {
    return client.read(Uri(path: 'api/study/$roundId/$gameId.pgn'));
  }

  Future<IList<BroadcastPlayerWithOverallResult>> getPlayers(BroadcastTournamentId tournamentId) {
    return client.readJsonList(
      Uri(path: '/broadcast/$tournamentId/players'),
      mapper: _makePlayerWithOverallResultFromJson,
    );
  }

  Future<BroadcastPlayerWithGameResults> getPlayerResults(
    BroadcastTournamentId tournamentId,
    String playerId,
  ) {
    return client.readJson(
      Uri(path: 'broadcast/$tournamentId/players/$playerId'),
      mapper: _makePlayerWithGameResultsFromJson,
    );
  }

  Future<IList<BroadcastTeamMatch>> getTeamMatches(BroadcastRoundId roundId) {
    return client.readJson(
      Uri(path: 'broadcast/$roundId/teams'),
      mapper: (json) =>
          pick(json, 'table').asListOrThrow<BroadcastTeamMatch>(_teamMatchFromPick).toIList(),
    );
  }
}

BroadcastList broadcastListFromServerJson(Map<String, dynamic> json) {
  return (
    active: pick(json, 'active').asListOrThrow(_broadcastFromPick).toIList(),
    past: pick(json, 'past', 'currentPageResults').asListOrThrow(_broadcastFromPick).toIList(),
    nextPage: pick(json, 'past', 'nextPage').asIntOrNull(),
  );
}

BroadcastSearchList _makeBroadcastSearchResponseFromJson(Map<String, dynamic> json) {
  return (
    broadcasts: pick(json, 'currentPageResults').asListOrThrow(_broadcastFromPick).toIList(),
    nextPage: pick(json, 'nextPage').asIntOrNull(),
  );
}

Broadcast _broadcastFromPick(RequiredPick pick) {
  final roundId = pick('round', 'id').asBroadcastRoundIdOrThrow();

  return Broadcast(
    tour: _tournamentDataFromPick(pick('tour').required()),
    round: _roundFromPick(pick('round').required()),
    group: pick('group').asStringOrNull(),
    roundToLinkId: pick('roundToLink', 'id').asBroadcastRoundIdOrNull() ?? roundId,
  );
}

BroadcastTournamentData _tournamentDataFromPick(RequiredPick pick) => BroadcastTournamentData(
  id: pick('id').asBroadcastTournamentIdOrThrow(),
  name: pick('name').asStringOrThrow(),
  slug: pick('slug').asStringOrThrow(),
  tier: pick('tier').asIntOrNull(),
  imageUrl: pick('image').asStringOrNull(),
  description: pick('description').asStringOrNull(),
  teamTable: pick('teamTable').asBoolOrFalse(),
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
    website: pick('info', 'website').letOrNull((p) => Uri.tryParse(p.asStringOrThrow())),
    standings: pick('info', 'standings').letOrNull((p) => Uri.tryParse(p.asStringOrThrow())),
  ),
);

BroadcastTournament _makeTournamentFromJson(Map<String, dynamic> json) {
  return BroadcastTournament(
    data: _tournamentDataFromPick(pick(json, 'tour').required()),
    rounds: pick(json, 'rounds').asListOrThrow(_roundFromPick).toIList(),
    defaultRoundId: pick(json, 'defaultRoundId').asBroadcastRoundIdOrThrow(),
    group: pick(json, 'group', 'tours').asListOrNull(_tournamentGroupFromPick)?.toIList(),
  );
}

BroadcastTournamentGroup _tournamentGroupFromPick(RequiredPick pick) {
  final id = pick('id').asBroadcastTournamentIdOrThrow();
  final name = pick('name').asStringOrThrow();
  final active = pick('active').asBoolOrFalse();
  final live = pick('live').asBoolOrFalse();

  return (id: id, name: name, active: active, live: live);
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

BroadcastRoundResponse _makeRoundWithGamesFromJson(Map<String, dynamic> json) {
  final groupName = pick(json, 'group', 'name').asStringOrNull();
  final group = pick(json, 'group', 'tours').asListOrNull(_tournamentGroupFromPick)?.toIList();
  final tournament = pick(json, 'tour').required();
  final round = pick(json, 'round').required();
  final games = pick(json, 'games').required();

  return (
    groupName: groupName,
    group: group,
    tournament: _tournamentDataFromPick(tournament),
    round: _roundFromPick(round),
    games: _gamesFromPick(games),
  );
}

BroadcastRoundGames _gamesFromPick(RequiredPick pick) =>
    IMap.fromEntries(pick.asListOrThrow(gameFromPick));

MapEntry<BroadcastGameId, BroadcastGame> gameFromPick(RequiredPick pick) {
  final stringStatus = pick('status').asStringOrNull();

  final status = BroadcastResult.resultFromString(stringStatus);

  /// The amount of time that the player whose turn it is has been thinking since his last move
  final thinkTime = pick('thinkTime').asDurationFromSecondsOrNull();
  final fen = pick('fen').asStringOrNull() ?? Variant.standard.initialPosition.fen;
  final playingSide = Setup.parseFen(fen).turn;

  return MapEntry(
    pick('id').asBroadcastGameIdOrThrow(),
    BroadcastGame(
      id: pick('id').asBroadcastGameIdOrThrow(),
      players: IMap({
        Side.white: _playerWithClockFromPick(
          pick('players', 0).required(),
          isPlaying: playingSide == Side.white,
          thinkTime: thinkTime,
        ),
        Side.black: _playerWithClockFromPick(
          pick('players', 1).required(),
          isPlaying: playingSide == Side.black,
          thinkTime: thinkTime,
        ),
      }),
      fen: pick('fen').asStringOrNull() ?? Variant.standard.initialPosition.fen,
      lastMove: pick('lastMove').asUciMoveOrNull(),
      thinkTime: thinkTime,
      status: status,
      updatedClockAt: clock.now(),
    ),
  );
}

BroadcastPlayer _playerFromPick(RequiredPick pick) {
  return BroadcastPlayer(
    name: pick('name').asStringOrNull(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    federation: pick('fed').asStringOrNull(),
    fideId: pick('fideId').asFideIdOrNull(),
  );
}

BroadcastPlayerWithClock _playerWithClockFromPick(
  RequiredPick pick, {
  required bool isPlaying,
  required Duration? thinkTime,
}) {
  final player = _playerFromPick(pick);
  final clock = pick('clock').asDurationFromCentiSecondsOrNull();
  final updatedClock = clock != null && isPlaying ? clock - (thinkTime ?? Duration.zero) : clock;

  return BroadcastPlayerWithClock(
    player: player,
    clock: (updatedClock?.isNegative ?? false) ? Duration.zero : updatedClock,
  );
}

BroadcastPlayerWithOverallResult _makePlayerWithOverallResultFromJson(Map<String, dynamic> json) {
  return _playerWithOverallResultFromPick(pick(json).required());
}

BroadcastPlayerWithOverallResult _playerWithOverallResultFromPick(RequiredPick pick) {
  final player = _playerFromPick(pick);

  return BroadcastPlayerWithOverallResult(
    player: player,
    played: pick('played').asIntOrThrow(),
    score: pick('score').asDoubleOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    performance: pick('performance').asIntOrNull(),
  );
}

BroadcastPlayerWithGameResults _makePlayerWithGameResultsFromJson(Map<String, dynamic> json) {
  return (
    playerWithOverallResult: _playerWithOverallResultFromPick(pick(json).required()),
    fideData: _fideDataFromPick(pick(json, 'fide')),
    games: pick(json, 'games').asListOrThrow(_playerGameResultFromPick).toIList(),
  );
}

BroadcastFideData _fideDataFromPick(Pick pick) {
  return (
    ratings: (
      standard: pick('ratings', 'standard').asIntOrNull(),
      rapid: pick('ratings', 'rapid').asIntOrNull(),
      blitz: pick('ratings', 'blitz').asIntOrNull(),
    ),
    birthYear: pick('year').asIntOrNull(),
  );
}

BroadcastPlayerGameResult _playerGameResultFromPick(RequiredPick pick) {
  final pointsString = pick('points').asStringOrNull();
  BroadcastPoints? points;
  if (pointsString == '1') {
    points = BroadcastPoints.one;
  } else if (pointsString == '1/2') {
    points = BroadcastPoints.half;
  } else if (pointsString == '0') {
    points = BroadcastPoints.zero;
  }

  return BroadcastPlayerGameResult(
    roundId: pick('round').asBroadcastRoundIdOrThrow(),
    gameId: pick('id').asBroadcastGameIdOrThrow(),
    color: pick('color').asSideOrThrow(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    points: points,
    opponent: _playerFromPick(pick('opponent').required()),
  );
}

BroadcastTeamMatch _teamMatchFromPick(RequiredPick pick) {
  final teams = pick('teams').asListOrThrow(_teamFromPick).toIList();
  if (teams.length != 2) {
    throw FormatException('Expected exactly 2 teams in a match, got ${teams.length}');
  }
  return BroadcastTeamMatch(
    team1: teams[0],
    team2: teams[1],
    games: pick('games').asListOrThrow(_teamGameFromPick).toIList(),
  );
}

BroadcastTeam _teamFromPick(RequiredPick pick) {
  return BroadcastTeam(
    name: pick('name').asStringOrThrow(),
    points: pick('points').asDoubleOrThrow(),
  );
}

BroadcastTeamGame _teamGameFromPick(RequiredPick pick) {
  return BroadcastTeamGame(
    id: pick('id').asBroadcastGameIdOrThrow(),
    pov: pick('pov').asSideOrThrow(),
  );
}
