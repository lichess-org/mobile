import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'tv_game.freezed.dart';

@freezed
class TvGames with _$TvGames {
  const factory TvGames({
    required IMap<Perf, TvGame> games,
    //IMap<Perf, UserActitityGameScore>? games,
  }) = _TvGames;

  factory TvGames.fromJson(Map<String, dynamic> json) {
    final receivedGamesMap =
        pick(json).asMapOrEmpty<String, Map<String, dynamic>>();
    return TvGames(
      games: IMap({
        for (final entry in receivedGamesMap.entries)
          perfNameMap.get(entry.key)!: TvGame.fromJson(entry.value)
      }),
    );
    /*
    final RequiredPick data = pick(json).required();
    final testdata =
        pick(json).required().asMapOrThrow<String, Map<String, dynamic>>();
    return TvGames.fromPick(data);
    */
  }
  /*
  factory TvGames.fromPick(RequiredPick pick) {
    return TvGames(
      
      id: pick('id').asUserIdOrThrow(),
      name: pick('username').asStringOrThrow(),
      rating: pick('rating').asIntOrThrow(),
      gameId: pick('gameId').asStringOrThrow(),
      
        );
  }*/
}

@freezed
class TvGame with _$TvGame {
  const factory TvGame({
    required UserId id,
    required String name,
    required int rating,
    required String gameId,
  }) = _TvGame;

  factory TvGame.fromJson(Map<String, dynamic> json) {
    final RequiredPick data = pick(json).required();
    return TvGame.fromPick(data);
  }

  factory TvGame.fromPick(RequiredPick pick) {
    return TvGame(
      id: pick('id').asUserIdOrThrow(),
      name: pick('username').asStringOrThrow(),
      rating: pick('rating').asIntOrThrow(),
      gameId: pick('gameId').asStringOrThrow(),
    );
  }
}
