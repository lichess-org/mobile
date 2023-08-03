import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

import 'featured_player.dart';

part 'tv_game.freezed.dart';

@freezed
class TvGame with _$TvGame {
  const factory TvGame({
    required GameId gameId,
    required LightUser user,
    required int? rating,
  }) = _TvGame;

  factory TvGame.fromJson(Map<String, dynamic> json) =>
      TvGame.fromPick(pick(json).required());

  factory TvGame.fromPick(RequiredPick pick) => TvGame(
        gameId: pick('gameId').asGameIdOrThrow(),
        user: pick('user').letOrThrow((it) {
          return LightUser(
            id: it('id').asUserIdOrThrow(),
            name: it('name').asStringOrThrow(),
            title: it('title').asStringOrNull(),
            isPatron: it('patron').asBoolOrNull(),
          );
        }),
        rating: pick('rating').asIntOrNull(),
      );
}

@freezed
class TvGameSnapshot with _$TvGameSnapshot {
  const factory TvGameSnapshot({
    required GameId id,
    required Side orientation,
    required String fen,
    required FeaturedPlayer white,
    required FeaturedPlayer black,
  }) = _TvGameSnapshot;
}
