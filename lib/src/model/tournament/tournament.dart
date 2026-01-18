import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'tournament.freezed.dart';

enum TournamentFreq implements Comparable<TournamentFreq> {
  hourly,
  daily,
  eastern,
  weekly,
  weekend,
  monthly,
  shield,
  marathon,
  yearly,
  unique;

  static final IMap<String, TournamentFreq> nameMap = IMap(TournamentFreq.values.asNameMap());

  @override
  int compareTo(TournamentFreq other) {
    return values.indexOf(other).compareTo(values.indexOf(this));
  }
}

typedef TournamentLists = ({
  IList<LightTournament> started,
  IList<LightTournament> created,
  IList<LightTournament> finished,
});

typedef TournamentMe = ({int rank, GameFullId? gameId, bool? withdraw, Duration? pauseDelay});

typedef TeamInfo = ({String name, String? flair});

typedef TeamBattleData = ({IMap<TeamId, TeamInfo> teams, int nbLeaders, IList<TeamId>? joinWith});

const int kStandingsPageSize = 10;
typedef StandingPage = ({int page, IList<StandingPlayer> players});

@freezed
sealed class TournamentMeta with _$TournamentMeta {
  const TournamentMeta._();

  const factory TournamentMeta({
    required String createdBy,
    required String fullName,
    required TimeIncrement timeIncrement,
    required bool rated,
    required int? maxRating,
    required Duration duration,
    required Perf perf,
    required TournamentFreq? freq,
    required Variant variant,
    TeamBattleData? teamBattle,
  }) = _TournamentMeta;

  factory TournamentMeta.fromServerJson(Map<String, Object?> json) =>
      _tournamentMetaFromPick(pick(json).required());
}

TournamentMeta _tournamentMetaFromPick(RequiredPick pick) {
  return TournamentMeta(
    fullName: pick('fullName').asStringOrThrow(),
    timeIncrement: pick('clock').asTimeIncrementOrThrow(),
    rated: pick('rated').asBoolOrThrow(),
    createdBy: pick('createdBy').asStringOrThrow(),
    maxRating: pick('maxRating', 'rating').asIntOrNull(),
    duration: pick('minutes').asDurationFromMinutesOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    freq: pick('schedule').letOrNull((p) => p('freq').asTournamentFreqOrThrow()),
    variant: pick('variant').asVariantOrThrow(),
    teamBattle: pick('teamBattle').asTeamBattleDataOrNull(),
  );
}

@freezed
sealed class LightTournament with _$LightTournament {
  const LightTournament._();

  const factory LightTournament({
    required TournamentId id,
    required TournamentMeta meta,
    required int position,
    required int nbPlayers,
    required DateTime startsAt,
    required DateTime finishesAt,
    required LightUser? winner,
  }) = _LightTournament;

  factory LightTournament.fromServerJson(Map<String, Object?> json) =>
      _lightTournamentFromPick(pick(json).required());

  factory LightTournament.fromPick(RequiredPick pick) => _lightTournamentFromPick(pick);

  bool get isSystemTournament => meta.freq != null;

  bool get isSupportedInApp => playSupportedVariants.contains(meta.variant);
}

LightTournament _lightTournamentFromPick(RequiredPick pick) {
  return LightTournament(
    id: pick('id').asTournamentIdOrThrow(),
    meta: _tournamentMetaFromPick(pick),
    startsAt: pick('startsAt').asDateTimeFromMillisecondsOrThrow(),
    finishesAt: pick('finishesAt').asDateTimeFromMillisecondsOrThrow(),
    position: pick('perf', 'position').asIntOrThrow(),
    nbPlayers: pick('nbPlayers').asIntOrThrow(),
    winner: pick('winner').asLightUserOrNull(),
  );
}

typedef Verdicts = ({IList<Verdict> list, bool accepted});

typedef Verdict = ({String condition, bool ok});

@freezed
sealed class Tournament with _$Tournament {
  const Tournament._();

  const factory Tournament({
    required TournamentId id,
    required TournamentMeta meta,
    required bool berserkable,
    required FeaturedGame? featuredGame,
    required String? description,
    required bool? isFinished,
    required bool? isStarted,
    required bool private,
    required (Duration, DateTime)? timeToStart,
    required (Duration, DateTime)? timeToFinish,
    required bool pairingsClosed,
    required TournamentMe? me,
    required int nbPlayers,
    required StandingPage? standing,
    required Verdicts verdicts,
    required String? reloadEndpoint,
    required int socketVersion,
    ({String text, String author})? quote,
    DateTime? startsAt,
    TournamentStats? stats,
    ChatData? chat,
    IList<TeamStanding>? teamStanding,
  }) = _Tournament;

  factory Tournament.fromServerJson(Map<String, Object?> json) {
    return _tournamentFromPick(pick(json).required());
  }

  Tournament updateFromPartialServerJson(Map<String, Object?> json) =>
      _updateTournamentFromPartialPick(this, pick(json).required());

  Tournament updateStandingsFromServerJson(Map<String, Object?> json) {
    return copyWith(standing: pick(json).asStandingPageOrThrow());
  }
}

Tournament _tournamentFromPick(RequiredPick pick) {
  return Tournament(
    id: pick('id').asTournamentIdOrThrow(),
    socketVersion: pick('socketVersion').asIntOrThrow(),
    meta: _tournamentMetaFromPick(pick),
    featuredGame: pick('featured').asFeaturedGameOrNull(),
    description: pick('description').asStringOrNull(),
    startsAt: pick('startsAt').letOrNull((p) => DateTime.parse(p.asStringOrThrow())),
    isFinished: pick('isFinished').asBoolOrNull(),
    isStarted: pick('isStarted').asBoolOrNull(),
    private: pick('private').asBoolOrFalse(),
    timeToStart: pick(
      'secondsToStart',
    ).letOrNull((p) => (p.asDurationFromSecondsOrThrow(), DateTime.now())),
    timeToFinish: pick(
      'secondsToFinish',
    ).letOrNull((p) => (p.asDurationFromSecondsOrThrow(), DateTime.now())),
    pairingsClosed: pick('pairingsClosed').asBoolOrFalse(),
    me: pick('me').asTournamentMeOrNull(),
    nbPlayers: pick('nbPlayers').asIntOrThrow(),
    standing: pick('standing').asStandingPageOrNull(),
    berserkable: pick('berserkable').asBoolOrFalse(),
    verdicts: pick('verdicts').asVerdictsOrThrow(),
    reloadEndpoint: pick('reloadEndpoint').asStringOrNull(),
    stats: pick('stats').letOrNull((p) => TournamentStats._fromPick(p)),
    chat: pick('chat').letOrNull((p) => chatDataFromPick(p)),
    quote: pick(
      'quote',
    ).letOrNull((p) => (text: p('text').asStringOrThrow(), author: p('author').asStringOrThrow())),
    teamStanding: pick('teamStanding').asTeamStandingListOrNull(),
  );
}

Tournament _updateTournamentFromPartialPick(Tournament tournament, RequiredPick pick) {
  final newFeaturedGameId = pick('featured', 'id').asGameIdOrNull();
  return tournament.copyWith(
    // Sometimes a new FEN comes in via the websocket, but the API reload response
    // still has the FEN of the previous move, leading to sync issues.
    // So only copy the whole game here if it's a new ID.
    featuredGame: tournament.featuredGame?.id != newFeaturedGameId
        ? pick('featured').asFeaturedGameOrNull()
        : tournament.featuredGame,
    isFinished: pick('isFinished').asBoolOrNull(),
    isStarted: pick('isStarted').asBoolOrNull(),
    pairingsClosed: pick('pairingsClosed').asBoolOrFalse(),
    timeToStart: pick(
      'secondsToStart',
    ).letOrNull((p) => (p.asDurationFromSecondsOrThrow(), DateTime.now())),
    timeToFinish: pick(
      'secondsToFinish',
    ).letOrNull((p) => (p.asDurationFromSecondsOrThrow(), DateTime.now())),
    me: pick('me').asTournamentMeOrNull(),
    nbPlayers: pick('nbPlayers').asIntOrThrow(),
    standing: pick('standing').asStandingPageOrNull(),
    teamStanding: pick('teamStanding').asTeamStandingListOrNull(),
  );
}

typedef StandingSheet = ({bool fire, IList<int> scores});

@freezed
sealed class StandingPlayer with _$StandingPlayer {
  const StandingPlayer._();

  const factory StandingPlayer({
    required LightUser user,
    required int rating,
    required bool provisional,
    required int score,
    required int rank,
    required StandingSheet sheet,
    required bool withdraw,
    TeamId? teamId,
  }) = _StandingPlayer;
}

StandingPlayer _standingPlayerFromPick(RequiredPick pick) {
  return StandingPlayer(
    user: LightUser(
      id: UserId.fromUserName(pick('name').asStringOrThrow()),
      name: pick('name').asStringOrThrow(),
      title: pick('title').asStringOrNull(),
      flair: pick('flair').asStringOrNull(),
      patronColor: pick('patronColor').asIntOrNull(),
    ),
    rating: pick('rating').asIntOrThrow(),
    provisional: pick('provisional').asBoolOrFalse(),
    score: pick('score').asIntOrThrow(),
    rank: pick('rank').asIntOrThrow(),
    sheet: (
      fire: pick('sheet', 'fire').asBoolOrFalse(),
      scores: pick(
        'sheet',
        'scores',
      ).asStringOrThrow().characters.map((e) => int.parse(e)).toIList(),
    ),
    withdraw: pick('withdraw').asBoolOrFalse(),
    teamId: pick('team').asTeamIdOrNull(),
  );
}

@freezed
sealed class TeamStanding with _$TeamStanding {
  const TeamStanding._();

  const factory TeamStanding({
    required int rank,
    required TeamId id,
    required int score,
    required IList<TeamPlayer> players,
  }) = _TeamStanding;
}

@freezed
sealed class TeamPlayer with _$TeamPlayer {
  const TeamPlayer._();

  const factory TeamPlayer({required LightUser user, required int score}) = _TeamPlayer;
}

@freezed
sealed class FeaturedPlayer with _$FeaturedPlayer {
  const FeaturedPlayer._();

  const factory FeaturedPlayer({
    required LightUser user,
    required int? rank,
    required bool? berserk,
    required int? rating,
    required bool provisional,
  }) = _FeaturedPlayer;

  factory FeaturedPlayer.fromServerJson(Map<String, Object?> json) =>
      _featuredPlayerFromPick(pick(json).required());
}

FeaturedPlayer _featuredPlayerFromPick(RequiredPick pick) {
  return FeaturedPlayer(
    user: pick.asLightUserOrThrow(),
    rank: pick('rank').asIntOrNull(),
    berserk: pick('berserk').asBoolOrNull(),
    rating: pick('rating').asIntOrNull(),
    provisional: pick('provisional').asBoolOrFalse(),
  );
}

typedef FeaturedGameClocks = ({Duration white, Duration black});

@freezed
sealed class FeaturedGame with _$FeaturedGame {
  const FeaturedGame._();

  const factory FeaturedGame({
    required GameId id,
    required FeaturedPlayer white,
    required FeaturedPlayer black,
    required Side orientation,
    required String fen,
    required Move? lastMove,
    required Side? winner,
    required FeaturedGameClocks? clocks,
  }) = _FeaturedGame;

  Duration? clockOf(Side side) => side == Side.white ? clocks?.white : clocks?.black;

  FeaturedPlayer playerOf(Side side) => side == Side.white ? white : black;

  bool get active => clocks != null;
}

FeaturedGame _featuredGameFromPick(RequiredPick pick) {
  return FeaturedGame(
    id: pick('id').asGameIdOrThrow(),
    white: FeaturedPlayer.fromServerJson(pick('white').asMapOrThrow()),
    black: FeaturedPlayer.fromServerJson(pick('black').asMapOrThrow()),
    orientation: pick('orientation').asSideOrThrow(),
    fen: pick('fen').asStringOrThrow(),
    lastMove: pick('lastMove').asUciMoveOrNull(),
    winner: pick('winner').asSideOrNull(),
    clocks: pick('c').letOrNull(
      (pick) => (
        white: pick('white').asDurationFromSecondsOrThrow(),
        black: pick('black').asDurationFromSecondsOrThrow(),
      ),
    ),
  );
}

@freezed
sealed class TournamentStats with _$TournamentStats {
  const TournamentStats._();

  const factory TournamentStats({
    required int nbMoves,
    required int nbGames,
    required int nbDraws,
    required int nbBerserks,
    required int nbBlackWins,
    required int nbWhiteWins,
    required int averageRating,
  }) = _TournamentStats;

  factory TournamentStats.fromServerJson(Map<String, Object?> json) =>
      TournamentStats._fromPick(pick(json).required());

  factory TournamentStats._fromPick(RequiredPick pick) {
    return TournamentStats(
      nbMoves: pick('moves').asIntOrThrow(),
      nbGames: pick('games').asIntOrThrow(),
      nbDraws: pick('draws').asIntOrThrow(),
      nbBerserks: pick('berserks').asIntOrThrow(),
      nbBlackWins: pick('blackWins').asIntOrThrow(),
      nbWhiteWins: pick('whiteWins').asIntOrThrow(),
      averageRating: pick('averageRating').asIntOrThrow(),
    );
  }

  int get drawRate => ((nbDraws / nbGames) * 100).round();
  int get berserkRate => ((nbBerserks / nbGames) * 100).round();
  int get blackWinRate => ((nbBlackWins / nbGames) * 100).round();
  int get whiteWinRate => ((nbWhiteWins / nbGames) * 100).round();
}

extension TournamentExtension on Pick {
  TimeIncrement asTimeIncrementOrThrow() {
    final requiredPick = this.required();
    return TimeIncrement(
      requiredPick('limit').asIntOrThrow(),
      requiredPick('increment').asIntOrThrow(),
    );
  }

  TournamentFreq asTournamentFreqOrThrow() {
    final value = this.required().value;
    if (value is TournamentFreq) {
      return value;
    }
    if (value is String) {
      final freq = TournamentFreq.nameMap[value];
      if (freq != null) return freq;
    }
    throw PickException("value $value at $debugParsingExit can't be casted to TournamentFreq");
  }

  IList<LightTournament> asTournamentListOrThrow() =>
      asListOrThrow(LightTournament.fromPick).toIList();

  Verdict asVerdictOrThrow() {
    final requiredPick = this.required();
    return (
      condition: requiredPick('condition').asStringOrThrow(),
      ok: requiredPick('verdict').asStringOrThrow() == 'ok',
    );
  }

  Verdicts asVerdictsOrThrow() {
    final requiredPick = this.required();
    return (
      list: requiredPick('list')
          .asListOrThrow((pick) => pick.asVerdictOrThrow())
          .where(
            // we don't want to show the condition specific to the bot players
            // since it makes no sense a a bot player use the app
            (v) => v.condition != 'Bot players are not allowed',
          )
          .toIList(),
      accepted: requiredPick('accepted').asBoolOrThrow(),
    );
  }

  TournamentMe? asTournamentMeOrNull() {
    if (value == null) return null;
    try {
      final requiredPick = this.required();
      return (
        rank: requiredPick('rank').asIntOrThrow(),
        gameId: requiredPick('fullId').asGameFullIdOrNull(),
        withdraw: requiredPick('withdraw').asBoolOrNull(),
        pauseDelay: requiredPick('pauseDelay').asDurationFromSecondsOrNull(),
      );
    } catch (e) {
      return null;
    }
  }

  StandingPage asStandingPageOrThrow() {
    final requiredPick = this.required();
    return (
      page: requiredPick('page').asIntOrThrow(),
      players: requiredPick(
        'players',
      ).asListOrThrow((pick) => _standingPlayerFromPick(pick.required())).toIList(),
    );
  }

  StandingPage? asStandingPageOrNull() {
    if (value == null) return null;
    try {
      return asStandingPageOrThrow();
    } catch (_) {
      return null;
    }
  }

  FeaturedGame? asFeaturedGameOrNull() {
    if (value == null) return null;
    try {
      return _featuredGameFromPick(this.required());
    } catch (_) {
      return null;
    }
  }

  TeamBattleData? asTeamBattleDataOrNull() {
    if (value == null) return null;
    try {
      final requiredPick = this.required();
      final teamsMap = requiredPick('teams').asMapOrThrow<TeamId, dynamic>();
      return (
        teams: IMap.fromEntries(
          teamsMap.entries.map((entry) {
            final teamData = entry.value as List;
            return MapEntry(entry.key, (
              name: teamData[0] as String,
              flair: teamData[1] as String?,
            ));
          }),
        ),
        nbLeaders: requiredPick('nbLeaders').asIntOrThrow(),
        joinWith: requiredPick('joinWith').asListOrNull((p) => p.asTeamIdOrThrow())?.toIList(),
      );
    } catch (_) {
      return null;
    }
  }

  IList<TeamStanding>? asTeamStandingListOrNull() {
    if (value == null) return null;
    try {
      return asListOrThrow((pick) => _teamStandingFromPick(pick.required())).toIList();
    } catch (_) {
      return null;
    }
  }

  IList<TeamStanding> asTeamStandingListOrThrow() {
    final requiredPick = this.required();
    return requiredPick.asListOrThrow((pick) => _teamStandingFromPick(pick.required())).toIList();
  }
}

typedef PlayerStats = ({int game, int berserk, int win});

@freezed
sealed class TournamentPlayer with _$TournamentPlayer {
  const TournamentPlayer._();

  factory TournamentPlayer({
    required LightUser user,
    required int rating,
    required int score,
    required bool fire,
    required int? performance,
    required int rank,
    required PlayerStats stats,
    required IList<TournamentPairing> pairings,
    TeamId? teamId,
  }) = _TournamentPlayer;
  factory TournamentPlayer.fromServerJson(Map<String, Object?> json) =>
      _tournamentPlayerFromPick(pick(json).required());
}

@freezed
sealed class TournamentTeam with _$TournamentTeam {
  const TournamentTeam._();

  factory TournamentTeam({
    required TeamId id,
    required int nbPlayers,
    required int rating,
    required int? performance,
    required int score,
    required IList<TeamPlayerDetailed> topPlayers,
  }) = _TournamentTeam;

  factory TournamentTeam.fromServerJson(Map<String, Object?> json) =>
      _tournamentTeamFromPick(pick(json).required());
}

@freezed
sealed class TeamPlayerDetailed with _$TeamPlayerDetailed {
  const TeamPlayerDetailed._();

  const factory TeamPlayerDetailed({
    required LightUser user,
    required int rating,
    required int score,
    required bool fire,
  }) = _TeamPlayerDetailed;
}

@freezed
sealed class TournamentPairing with _$TournamentPairing {
  const TournamentPairing._();

  const factory TournamentPairing({
    required GameId gameId,
    required Side color,
    required LightUser opponent,
    required int opponentRating,
    required bool? win,
    required GameStatus? status,
    required int? score,
    required bool berserk,
  }) = _TournamentPairing;
}

TournamentPlayer _tournamentPlayerFromPick(RequiredPick pick) {
  final player = pick('player').required();
  return TournamentPlayer(
    user: LightUser(
      id: UserId.fromUserName(player('id').asStringOrThrow()),
      name: player('name').asStringOrThrow(),
      title: player('title').asStringOrNull(),
      flair: player('flair').asStringOrNull(),
      patronColor: player('patronColor').asIntOrNull(),
    ),
    rating: player('rating').asIntOrThrow(),
    score: player('score').asIntOrThrow(),
    fire: player('fire').asBoolOrFalse(),
    stats: (
      game: player('nb', 'game').asIntOrThrow(),
      berserk: player('nb', 'berserk').asIntOrThrow(),
      win: player('nb', 'win').asIntOrThrow(),
    ),
    performance: player('performance').asIntOrNull(),
    rank: player('rank').asIntOrThrow(),
    pairings: pick('pairings').asListOrThrow(_pairingFromPick).toIList(),
    teamId: player('team').asTeamIdOrNull(),
  );
}

TournamentTeam _tournamentTeamFromPick(RequiredPick pick) {
  return TournamentTeam(
    id: pick('id').asTeamIdOrThrow(),
    nbPlayers: pick('nbPlayers').asIntOrThrow(),
    rating: pick('rating').asIntOrThrow(),
    performance: pick('perf').asIntOrNull(),
    score: pick('score').asIntOrThrow(),
    topPlayers: pick(
      'topPlayers',
    ).asListOrThrow((p) => _teamPlayerDetailedFromPick(p.required())).toIList(),
  );
}

TeamPlayerDetailed _teamPlayerDetailedFromPick(RequiredPick pick) {
  return TeamPlayerDetailed(
    user: LightUser(
      id: UserId.fromUserName(pick('name').asStringOrThrow()),
      name: pick('name').asStringOrThrow(),
      title: pick('title').asStringOrNull(),
      flair: pick('flair').asStringOrNull(),
      patronColor: pick('patronColor').asIntOrNull(),
    ),
    rating: pick('rating').asIntOrThrow(),
    score: pick('score').asIntOrThrow(),
    fire: pick('fire').asBoolOrFalse(),
  );
}

TournamentPairing _pairingFromPick(RequiredPick pick) {
  return TournamentPairing(
    gameId: pick('id').asGameIdOrThrow(),
    color: pick('color').asSideOrThrow(),
    opponent: LightUser(
      id: UserId.fromUserName(pick('op', 'name').asStringOrThrow()),
      name: pick('op', 'name').asStringOrThrow(),
      title: pick('op', 'title').asStringOrNull(),
      flair: pick('op', 'flair').asStringOrNull(),
      patronColor: pick('op', 'patronColor').asIntOrNull(),
    ),
    opponentRating: pick('op', 'rating').asIntOrThrow(),
    win: pick('win').asBoolOrNull(),
    status: pick('status').asGameStatusOrThrow(),
    score: pick('score').asIntOrNull(),
    berserk: pick('berserk').asBoolOrFalse(),
  );
}

TeamStanding _teamStandingFromPick(RequiredPick pick) {
  return TeamStanding(
    rank: pick('rank').asIntOrThrow(),
    id: pick('id').asTeamIdOrThrow(),
    score: pick('score').asIntOrThrow(),
    players: pick('players').asListOrThrow((p) => _teamPlayerFromPick(p.required())).toIList(),
  );
}

TeamPlayer _teamPlayerFromPick(RequiredPick pick) {
  return TeamPlayer(user: pick('user').asLightUserOrThrow(), score: pick('score').asIntOrThrow());
}
