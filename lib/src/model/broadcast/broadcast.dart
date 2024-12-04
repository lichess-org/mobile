import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'broadcast.freezed.dart';

typedef BroadcastsList = ({
  IList<Broadcast> active,
  IList<Broadcast> upcoming,
  IList<Broadcast> past,
  int? nextPage,
});

enum BroadcastResult { whiteWins, blackWins, draw, ongoing, noResultPgnTag }

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
    required String? imageUrl,
    required String? description,
    required BroadcastTournamentInformation information,
  }) = _BroadcastTournamentData;
}

typedef BroadcastTournamentInformation = ({
  String? format,
  String? timeControl,
  String? players,
  String? location,
  BroadcastTournamentDates? dates,
  Uri? website,
});

typedef BroadcastTournamentDates = ({
  DateTime startsAt,
  DateTime? endsAt,
});

typedef BroadcastTournamentGroup = ({
  BroadcastTournamentId id,
  String name,
});

@freezed
class BroadcastRound with _$BroadcastRound {
  const BroadcastRound._();

  const factory BroadcastRound({
    required BroadcastRoundId id,
    required String name,
    required RoundStatus status,
    required DateTime? startsAt,
  }) = _BroadcastRound;
}

typedef BroadcastRoundWithGames = ({
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
  }) = _BroadcastGame;

  bool get isOngoing => status == BroadcastResult.ongoing;
  bool get isOver =>
      status == BroadcastResult.draw ||
      status == BroadcastResult.whiteWins ||
      status == BroadcastResult.blackWins;
  Side get sideToMove => Setup.parseFen(fen).turn;
}

@freezed
class BroadcastPlayer with _$BroadcastPlayer {
  const BroadcastPlayer._();

  const factory BroadcastPlayer({
    required String name,
    required String? title,
    required int? rating,
    required Duration? clock,
    required String? federation,
  }) = _BroadcastPlayer;
}

enum RoundStatus {
  live,
  finished,
  upcoming,
}
