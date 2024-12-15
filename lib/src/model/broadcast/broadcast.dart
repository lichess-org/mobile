import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'broadcast.freezed.dart';

typedef BroadcastList = ({IList<Broadcast> active, IList<Broadcast> past, int? nextPage});

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
    });

typedef BroadcastTournamentDates = ({DateTime startsAt, DateTime? endsAt});

typedef BroadcastTournamentGroup = ({BroadcastTournamentId id, String name});

@freezed
class BroadcastRound with _$BroadcastRound {
  const factory BroadcastRound({
    required BroadcastRoundId id,
    required String name,
    required RoundStatus status,
    required DateTime? startsAt,
    required DateTime? finishedAt,
    required bool startsAfterPrevious,
  }) = _BroadcastRound;
}

typedef BroadcastRoundWithGames = ({BroadcastRound round, BroadcastRoundGames games});

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
  }) = _BroadcastPlayerExtended;
}

enum RoundStatus { live, finished, upcoming }
