import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'broadcast.freezed.dart';

@freezed
class Broadcast with _$Broadcast {
  const factory Broadcast({
    required Tour tour,
    required IList<Round> rounds,
  }) = _Broadcast;
}

@freezed
class Tour with _$Tour {
  const factory Tour({
    required String name,
    required String description,
    required String? imageUrl,
  }) = _Tour;

  Widget image(double width) => (imageUrl != null)
      ? Image.network(imageUrl!, width: width)
      : SizedBox(
          height: width / 2,
          width: width,
        ); // we should use the same default image as on the website
}

@freezed
class Round with _$Round {
  const factory Round({
    required String id,
    required BroadcastStatus status,
  }) = _Round;
}

@freezed
class BroadcastGameSnapshot with _$BroadcastGameSnapshot {
  const factory BroadcastGameSnapshot({
    required IList<BroadcastPlayer> players,
    required String fen,
    required Move lastMove,
  }) = _BroadcastGameSnapshot;
}

@freezed
class BroadcastPlayer with _$BroadcastPlayer {
  const BroadcastPlayer._();

  const factory BroadcastPlayer({
    required String name,
    required String? title,
    required int rating,
  }) = _BroadcastPlayer;

  LightUser get user => LightUser(
        id: UserId.fromUserName(name),
        name: name,
        title: title,
      );
}

enum BroadcastStatus {
  ongoing,
  finished,
  upcoming,
}
