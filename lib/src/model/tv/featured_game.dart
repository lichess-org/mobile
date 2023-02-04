import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'featured_player.dart';

part 'featured_game.freezed.dart';

@freezed
class FeaturedGame with _$FeaturedGame {
  const factory FeaturedGame({
    required GameId id,
    required Side orientation,
    required String initialFen,
    required FeaturedPlayer white,
    required FeaturedPlayer black,
  }) = _FeaturedGame;
}
