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

@freezed
class Broadcast with _$Broadcast {
  const Broadcast._();

  const factory Broadcast({
    required BroadcastTournament tour,
    required BroadcastRound round,
    required String? group,
  }) = _Broadcast;

  bool get isLive => round.status == RoundStatus.live;

  bool get isFinished => round.status == RoundStatus.finished;

  String get title => group ?? tour.name;
}

typedef BroadcastTournament = ({
  String name,
  String? imageUrl,
});

@freezed
class BroadcastRound with _$BroadcastRound {
  const BroadcastRound._();

  const factory BroadcastRound({
    required BroadcastRoundId id,
    required String name,
    required RoundStatus status,
    required DateTime startsAt,
  }) = _BroadcastRound;
}

typedef BroadcastMapGames = IMap<BroadcastGameId, BroadcastGameSnapshot>;

@freezed
class BroadcastGameSnapshot with _$BroadcastGameSnapshot {
  const BroadcastGameSnapshot._();

  const factory BroadcastGameSnapshot({
    required IMap<Side, BroadcastPlayer> players,
    required String fen,
    required Move? lastMove,
    required String status,
    required Duration? thinkTime,
  }) = _BroadcastGameSnapshot;
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
