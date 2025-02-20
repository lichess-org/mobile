import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'broadcast.freezed.dart';

typedef BroadcastList = ({IList<Broadcast> active, IList<Broadcast> past, int? nextPage});

enum BroadcastResult {
  whiteWins,
  blackWins,
  draw,
  canceled,
  whiteHalfWins,
  blackHalfWins,
  ongoing,
  noResultPgnTag;

  static BroadcastResult resultFromString(String? result) {
    return (result == null)
        ? BroadcastResult.noResultPgnTag
        : switch (result) {
          '½-½' => BroadcastResult.draw,
          '1-0' => BroadcastResult.whiteWins,
          '0-1' => BroadcastResult.blackWins,
          '0-0' => BroadcastResult.canceled,
          '½-0' => BroadcastResult.whiteHalfWins,
          '0-½' => BroadcastResult.blackHalfWins,
          '*' => BroadcastResult.ongoing,
          _ => throw FormatException("value $result can't be interpreted as a broadcast result"),
        };
  }

  String resultToString(Side side) {
    return switch (this) {
      whiteWins => side == Side.white ? '1' : '0',
      blackWins => side == Side.white ? '0' : '1',
      draw => '½',
      canceled => '0',
      whiteHalfWins => side == Side.white ? '½' : '0',
      blackHalfWins => side == Side.white ? '0' : '½',
      _ => throw ArgumentError.value(this, 'result', 'Not a completed game'),
    };
  }

  bool get isOngoing => switch (this) {
    ongoing => true,
    _ => false,
  };

  bool get isOver => switch (this) {
    ongoing => false,
    noResultPgnTag => false,
    _ => true,
  };
}

@freezed
class Broadcast with _$Broadcast {
  const Broadcast._();

  const factory Broadcast({
    required BroadcastTournamentData tour,
    required BroadcastRound round,
    required String? group,

    /// The round to which the user should be brought when cliking on the tournament
    required BroadcastRoundId roundToLinkId,
  }) = _Broadcast;

  bool get isLive => round.status == RoundStatus.live;

  bool get isFinished => round.status == RoundStatus.finished;

  String get title => group ?? tour.name;
}

@freezed
class BroadcastTournament with _$BroadcastTournament {
  const factory BroadcastTournament({
    required BroadcastTournamentData data,
    required IList<BroadcastRound> rounds,
    required BroadcastRoundId defaultRoundId,
    required IList<BroadcastTournamentGroup>? group,
  }) = _BroadcastTournament;
}

@freezed
class BroadcastTournamentData with _$BroadcastTournamentData {
  const factory BroadcastTournamentData({
    required BroadcastTournamentId id,
    required String name,
    required String slug,
    required String? imageUrl,
    required String? description,
    // PRIVATE=-1, NORMAL=3, HIGH=4, BEST=5
    int? tier,
    required BroadcastTournamentInformation information,
  }) = _BroadcastTournamentData;
}

typedef BroadcastTournamentInformation =
    ({
      String? format,
      String? timeControl,
      String? players,
      String? location,
      BroadcastTournamentDates? dates,
      Uri? website,
      Uri? standings,
    });

typedef BroadcastTournamentDates = ({DateTime startsAt, DateTime? endsAt});

typedef BroadcastTournamentGroup = ({BroadcastTournamentId id, String name});

@freezed
class BroadcastRound with _$BroadcastRound {
  const factory BroadcastRound({
    required BroadcastRoundId id,
    required String name,
    required String slug,
    required RoundStatus status,
    required DateTime? startsAt,
    required DateTime? finishedAt,
    required bool startsAfterPrevious,
  }) = _BroadcastRound;
}

typedef BroadcastRoundResponse =
    ({
      String? groupName,
      IList<BroadcastTournamentGroup>? group,
      BroadcastTournamentData tournament,
      BroadcastRound round,
      BroadcastRoundGames games,
    });

typedef BroadcastRoundGames = IMap<BroadcastGameId, BroadcastGame>;

@freezed
class BroadcastGame with _$BroadcastGame {
  const BroadcastGame._();

  const factory BroadcastGame({
    required BroadcastGameId id,
    required IMap<Side, BroadcastPlayer> players,
    required String fen,
    required Move? lastMove,
    required BroadcastResult status,
    required DateTime updatedClockAt,
    int? cp,
    int? mate,
  }) = _BroadcastGame;

  bool get isOngoing => status.isOngoing;
  bool get isOver => status.isOver;
  Side get sideToMove => Setup.parseFen(fen).turn;
}

@freezed
class BroadcastPlayer with _$BroadcastPlayer {
  const factory BroadcastPlayer({
    required String name,
    required String? title,
    required int? rating,
    required Duration? clock,
    required String? federation,
    required FideId? fideId,
  }) = _BroadcastPlayer;
}

@freezed
class BroadcastPlayerExtended with _$BroadcastPlayerExtended {
  const factory BroadcastPlayerExtended({
    required String name,
    required String? title,
    required int? rating,
    required String? federation,
    required FideId? fideId,
    required int played,
    required double? score,
    required int? ratingDiff,
    required int? performance,
  }) = _BroadcastPlayerExtended;
}

typedef BroadcastFideData = ({({int? standard, int? rapid, int? blitz}) ratings, int? birthYear});

typedef BroadcastPlayerResults =
    ({
      BroadcastPlayerExtended player,
      BroadcastFideData fideData,
      IList<BroadcastPlayerResultData> games,
    });

enum BroadcastPoints { one, half, zero }

@freezed
class BroadcastPlayerResultData with _$BroadcastPlayerResultData {
  const factory BroadcastPlayerResultData({
    required BroadcastRoundId roundId,
    required BroadcastGameId gameId,
    required Side color,
    required BroadcastPoints? points,
    required int? ratingDiff,
    required BroadcastPlayer opponent,
  }) = _BroadcastPlayerResult;
}

enum RoundStatus { live, finished, upcoming }
