import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'featured_player.freezed.dart';

@freezed
sealed class FeaturedPlayer with _$FeaturedPlayer {
  const FeaturedPlayer._();

  const factory FeaturedPlayer({
    required Side side,
    required String name,
    String? title,
    int? rating,
    int? seconds,
  }) = _FeaturedPlayer;

  FeaturedPlayer withSeconds(int newSeconds) {
    return FeaturedPlayer(
      side: side,
      name: name,
      title: title,
      rating: rating,
      seconds: newSeconds,
    );
  }

  Player get asPlayer => Player(
    user: LightUser(id: UserId(name.toLowerCase()), name: name, title: title),
    rating: rating,
  );
}
