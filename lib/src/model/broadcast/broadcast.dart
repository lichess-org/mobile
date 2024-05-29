import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'broadcast.freezed.dart';

@freezed
class Broadcast with _$Broadcast {
  const Broadcast._();

  const factory Broadcast({
    required Tour tour,
    required IList<Round> rounds,
  }) = _Broadcast;

  Round? get curentRound =>
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
class Tour with _$Tour {
  const factory Tour({
    required String name,
    required String description,
    required String? imageUrl,
    required int tier,
  }) = _Tour;
}

@freezed
class Round with _$Round {
  const factory Round({
    required String id,
    required RoundStatus status,
    required DateTime startsAt,
  }) = _Round;
}

@freezed
class BroadcastGameSnapshot with _$BroadcastGameSnapshot {
  const factory BroadcastGameSnapshot({
    required IList<BroadcastPlayer> players,
    required String fen,
    required Move? lastMove,
  }) = _BroadcastGameSnapshot;
}

@freezed
class BroadcastPlayer with _$BroadcastPlayer {
  const BroadcastPlayer._();

  const factory BroadcastPlayer({
    required String name,
    required String? title,
    required int? rating,
  }) = _BroadcastPlayer;

  LightUser get user => LightUser(
        id: UserId.fromUserName(name),
        name: name,
        title: title,
      );
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
