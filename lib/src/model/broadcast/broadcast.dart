import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'broadcast.freezed.dart';

typedef BroadcastsList = ({
  IList<Broadcast> active,
  IList<Broadcast> upcoming,
  IList<Broadcast> past,
  int nextPage,
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

  String get title => group ?? tour.name;
}

typedef BroadcastTournament = ({
  String name,
  String? imageUrl,
});

typedef BroadcastRound = ({
  BroadcastRoundId id,
  RoundStatus status,
  DateTime startsAt,
});

typedef BroadcastGameSnapshot = ({
  IList<BroadcastPlayer> players,
  String fen,
  Move? lastMove,
  String status,
});

typedef BroadcastPlayer = ({
  String name,
  String? title,
  int? rating,
  Duration? clock,
  String? federation,
});

enum RoundStatus {
  live,
  finished,
  upcoming,
}
