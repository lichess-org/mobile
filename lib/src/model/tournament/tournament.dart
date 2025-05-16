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

typedef TournamentLists =
    ({
      IList<LightTournament> started,
      IList<LightTournament> created,
      IList<LightTournament> finished,
    });

typedef TournamentMe = ({int rank, GameFullId? gameId, bool? withdraw, Duration? pauseDelay});

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
    bool? isTeamBattle,
  }) = _LightTournament;

  factory LightTournament.fromServerJson(Map<String, Object?> json) =>
      _lightTournamentFromPick(pick(json).required());

  factory LightTournament.fromPick(RequiredPick pick) => _lightTournamentFromPick(pick);

  bool get isSystemTournament => meta.freq != null;

  // TODO: add support for team battle
  bool get isSupportedInApp => playSupportedVariants.contains(meta.variant) && isTeamBattle != true;
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
    // TODO add support for team battle; for now we just test if the field is not empty
    isTeamBattle: pick('teamBattle').asMapOrNull<String, dynamic>()?.isNotEmpty,
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
    required (Duration, DateTime)? timeToStart,
    required (Duration, DateTime)? timeToFinish,
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
  }) = _Tournament;

  factory Tournament.fromServerJson(Map<String, Object?> json) {
    return _tournamentFromPick(pick(json).required());
  }

  Tournament updateFromPartialServerJson(Map<String, Object?> json) =>
      _updateTournamentFromPartialPick(this, pick(json).required());
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
    timeToStart: pick(
      'secondsToStart',
    ).letOrNull((p) => (p.asDurationFromSecondsOrThrow(), DateTime.now())),
    timeToFinish: pick(
      'secondsToFinish',
    ).letOrNull((p) => (p.asDurationFromSecondsOrThrow(), DateTime.now())),
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
  );
}

Tournament _updateTournamentFromPartialPick(Tournament tournament, RequiredPick pick) {
  final newFeaturedGameId = pick('featured', 'id').asGameIdOrNull();
  return tournament.copyWith(
    // Sometimes a new FEN comes in via the websocket, but the API reload response
    // still has the FEN of the previous move, leading to sync issues.
    // So only copy the whole game here if it's a new ID.
    featuredGame:
        tournament.featuredGame?.id != newFeaturedGameId
            ? pick('featured').asFeaturedGameOrNull()
            : tournament.featuredGame,
    isFinished: pick('isFinished').asBoolOrNull(),
    isStarted: pick('isStarted').asBoolOrNull(),
    timeToStart: pick(
      'secondsToStart',
    ).letOrNull((p) => (p.asDurationFromSecondsOrThrow(), DateTime.now())),
    timeToFinish: pick(
      'secondsToFinish',
    ).letOrNull((p) => (p.asDurationFromSecondsOrThrow(), DateTime.now())),
    me: pick('me').asTournamentMeOrNull(),
    nbPlayers: pick('nbPlayers').asIntOrThrow(),
    standing: pick('standing').asStandingPageOrNull(),
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
  }) = _StandingPlayer;
}

StandingPlayer _standingPlayerFromPick(RequiredPick pick) {
  return StandingPlayer(
    user: LightUser(
      id: UserId.fromUserName(pick('name').asStringOrThrow()),
      name: pick('name').asStringOrThrow(),
      title: pick('title').asStringOrNull(),
      flair: pick('flair').asStringOrNull(),
      isPatron: pick('patron').asBoolOrNull(),
    ),
    rating: pick('rating').asIntOrThrow(),
    provisional: pick('provisional').asBoolOrFalse(),
    score: pick('score').asIntOrThrow(),
    rank: pick('rank').asIntOrThrow(),
    sheet: (
      fire: pick('sheet', 'fire').asBoolOrFalse(),
      scores:
          pick('sheet', 'scores').asStringOrThrow().characters.map((e) => int.parse(e)).toIList(),
    ),
    withdraw: pick('withdraw').asBoolOrFalse(),
  );
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
      list:
          requiredPick('list')
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

  StandingPage? asStandingPageOrNull() {
    if (value == null) return null;
    try {
      final requiredPick = this.required();
      return (
        page: requiredPick('page').asIntOrThrow(),
        players:
            requiredPick(
              'players',
            ).asListOrThrow((pick) => _standingPlayerFromPick(pick.required())).toIList(),
      );
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
}
