import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import '../model/featured_player.dart';

part 'tv_event.freezed.dart';

/// Represents a TV event from lichess API.
///
/// Different types of events are possible.
/// See: https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class TvEvent with _$TvEvent {
  const factory TvEvent.featured({
    required GameId id,
    required Side orientation,
    required String fen,
    required FeaturedPlayer white,
    required FeaturedPlayer black,
  }) = TvFeaturedEvent;

  const factory TvEvent.fen({
    required String fen,
    required Move lastMove,
    required int whiteSeconds,
    required int blackSeconds,
  }) = TvFenEvent;

  factory TvEvent.fromJson(Map<String, dynamic> json) {
    return TvEvent.fromPick(pick(json).required());
  }

  factory TvEvent.fromPick(RequiredPick pick) {
    final type = pick('t').asStringOrThrow();
    switch (type) {
      case 'featured':
        return pick('d').letOrThrow((data) => TvEvent.featured(
              id: data('id').asGameIdOrThrow(),
              orientation: data('orientation').asSideOrThrow(),
              fen: data('fen').asStringOrThrow(),
              white: data('players').letOrThrow((it) => it
                  .asListOrThrow(_featuredPlayerFromPick)
                  .firstWhere((p) => p.side == Side.white)),
              black: data('players').letOrThrow((it) => it
                  .asListOrThrow(_featuredPlayerFromPick)
                  .firstWhere((p) => p.side == Side.black)),
            ));
      case 'fen':
        return pick('d').letOrThrow((data) => TvEvent.fen(
              fen: data('fen').asStringOrThrow(),
              lastMove: data('lm')
                  .letOrThrow((it) => Move.fromUci(it.asStringOrThrow())),
              whiteSeconds: data('wc').asIntOrThrow(),
              blackSeconds: data('bc').asIntOrThrow(),
            ));
      default:
        throw UnsupportedError('Unsupported event type $type');
    }
  }

  static FeaturedPlayer _featuredPlayerFromPick(RequiredPick pick) {
    return FeaturedPlayer(
      side: pick('color').asSideOrThrow(),
      name: pick('user', 'name').asStringOrThrow(),
      title: pick('user', 'title').asStringOrNull(),
      rating: pick('rating').asIntOrNull(),
      seconds: pick('seconds').asIntOrNull(),
    );
  }
}
