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
  newOrOngoing,
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
          '*' => BroadcastResult.newOrOngoing,
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

  bool get isOver => switch (this) {
    newOrOngoing => false,
    noResultPgnTag => false,
    _ => true,
  };
}

@freezed
sealed class Broadcast with _$Broadcast {
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
sealed class BroadcastTournament with _$BroadcastTournament {
  const factory BroadcastTournament({
    required BroadcastTournamentData data,
    required IList<BroadcastRound> rounds,
    required BroadcastRoundId defaultRoundId,
    required IList<BroadcastTournamentGroup>? group,
  }) = _BroadcastTournament;
}

@freezed
sealed class BroadcastTournamentData with _$BroadcastTournamentData {
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
sealed class BroadcastRound with _$BroadcastRound {
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
sealed class BroadcastGame with _$BroadcastGame {
  const BroadcastGame._();

  const factory BroadcastGame({
    required BroadcastGameId id,
    required IMap<Side, BroadcastPlayerWithClock> players,
    required String fen,
    required Move? lastMove,
    required Duration? thinkTime,
    required BroadcastResult status,
    required DateTime updatedClockAt,
    int? cp,
    int? mate,
  }) = _BroadcastGame;

  // see lila commit 09822641e1cce954a6c39078c5ef0fc6eebe10b5
  bool get isOngoing =>
      status == BroadcastResult.newOrOngoing && thinkTime != null && lastMove != null;
  bool get isOver => status.isOver;
  Side get sideToMove => Setup.parseFen(fen).turn;
}

@freezed
// ignore: freezed_missing_private_empty_constructor
sealed class BroadcastPlayer with _$BroadcastPlayer {
  const BroadcastPlayer({
    required this.name,
    required this.title,
    required this.rating,
    required this.federation,
    required this.fideId,
  });

  // ignore: annotate_overrides
  final String name;
  // ignore: annotate_overrides
  final String? title;
  // ignore: annotate_overrides
  final int? rating;
  // ignore: annotate_overrides
  final String? federation;
  // ignore: annotate_overrides
  final FideId? fideId;

  String get id => (fideId != null) ? fideId!.toString() : name;
}

@freezed
// ignore: freezed_missing_private_empty_constructor
class BroadcastPlayerWithClock extends BroadcastPlayer with _$BroadcastPlayerWithClock {
  const BroadcastPlayerWithClock({
    required super.name,
    required super.title,
    required super.rating,
    required this.clock,
    required super.federation,
    required super.fideId,
  });

  // ignore: annotate_overrides
  final Duration? clock;
}

@freezed
// ignore: freezed_missing_private_empty_constructor
class BroadcastPlayerWithResult extends BroadcastPlayer with _$BroadcastPlayerWithResult {
  const BroadcastPlayerWithResult({
    required super.name,
    required super.title,
    required super.rating,
    required super.federation,
    required super.fideId,
    required this.played,
    required this.score,
    required this.ratingDiff,
    required this.performance,
  });

  // ignore: annotate_overrides
  final int played;
  // ignore: annotate_overrides
  final double? score;
  // ignore: annotate_overrides
  final int? ratingDiff;
  // ignore: annotate_overrides
  final int? performance;
}

typedef BroadcastFideData = ({({int? standard, int? rapid, int? blitz}) ratings, int? birthYear});

typedef BroadcastPlayerWithGames =
    ({
      BroadcastPlayerWithResult player,
      BroadcastFideData fideData,
      IList<BroadcastPlayerResultData> games,
    });

enum BroadcastPoints { one, half, zero }

@freezed
sealed class BroadcastPlayerResultData with _$BroadcastPlayerResultData {
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
