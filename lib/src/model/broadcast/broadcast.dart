import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast.freezed.dart';

@freezed
class Broadcast with _$Broadcast {
  const Broadcast._();

  const factory Broadcast({
    required BroadcastTournament tour,
    required IList<BroadcastRound> rounds,
  }) = _Broadcast;

  BroadcastRound? get curentRound =>
      rounds.where((r) => r.status == RoundStatus.live).firstOrNull ??
      rounds.where((r) => r.status == RoundStatus.finished).lastOrNull;

  BroadcastStatus get status {
    if (curentRound == null) return BroadcastStatus.upcoming;
    if (curentRound!.status == RoundStatus.live) return BroadcastStatus.live;
    return (curentRound! != rounds.last)
        ? BroadcastStatus.ongoing
        : BroadcastStatus.finished;
  }

  int get priority {
    final statusPriority = switch (status) {
      BroadcastStatus.live => 2,
      BroadcastStatus.ongoing => 0,
      BroadcastStatus.finished => -1,
      BroadcastStatus.upcoming => -1,
    };

    return tour.tier + statusPriority;
  }
}

@freezed
class BroadcastTournament with _$BroadcastTournament {
  const factory BroadcastTournament({
    required String name,
    required String description,
    required String? imageUrl,
    required int tier,
  }) = _BroadcastTournament;
}

@freezed
class BroadcastRound with _$BroadcastRound {
  const factory BroadcastRound({
    required String id,
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

enum BroadcastStatus {
  ongoing,
  live,
  finished,
  upcoming,
}

enum RoundStatus {
  live,
  finished,
  upcoming,
}
