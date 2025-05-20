import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/featured_player.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'tv_game.freezed.dart';

@freezed
sealed class TvGame with _$TvGame {
  const factory TvGame({
    required GameId id,
    required LightUser user,
    required int? rating,
    Side? side,
  }) = _TvGame;
}

@freezed
sealed class TvGameSnapshot with _$TvGameSnapshot {
  const factory TvGameSnapshot({
    required TvChannel channel,
    required GameId id,
    required Side orientation,
    required FeaturedPlayer player,
    String? fen,
    Move? lastMove,
  }) = _TvGameSnapshot;
}
