import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'broadcast.freezed.dart';

@freezed
class BroadcastResponse with _$BroadcastResponse {
  const factory BroadcastResponse({
    required IList<Broadcast> active,
    required IList<Broadcast> upcoming,
    required IList<Broadcast> past,
  }) = _BroadcastResponse;
}

@freezed
class Broadcast with _$Broadcast {
  const Broadcast._();

  const factory Broadcast({
    required BroadcastTournament tour,
    required BroadcastRound round,
    required String? group,
  }) = _Broadcast;

  factory Broadcast.loading() => Broadcast(
        tour: const BroadcastTournament(name: '', imageUrl: null),
        round: BroadcastRound(
          id: const BroadcastRoundId(''),
          status: RoundStatus.finished,
          startsAt: DateTime.now(),
        ),
        group: null,
      );

  bool get isLive => round.status == RoundStatus.live;

  String get title => group ?? tour.name;
}

@freezed
class BroadcastTournament with _$BroadcastTournament {
  const factory BroadcastTournament({
    required String name,
    required String? imageUrl,
  }) = _BroadcastTournament;
}

@freezed
class BroadcastRound with _$BroadcastRound {
  const factory BroadcastRound({
    required BroadcastRoundId id,
    required RoundStatus status,
    required DateTime startsAt,
  }) = _BroadcastRound;
}

@freezed
class BroadcastGameSnapshot with _$BroadcastGameSnapshot {
  const factory BroadcastGameSnapshot({
    required IList<BroadcastPlayer> players,
    required String fen,
    required Move? lastMove,
    required String status,
  }) = _BroadcastGameSnapshot;
}

@freezed
class BroadcastPlayer with _$BroadcastPlayer {
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
