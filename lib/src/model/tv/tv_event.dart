import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'featured_player.dart';

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
        return pick('d').letOrThrow(
          (dataPick) => TvEvent.featured(
            id: dataPick('id').asGameIdOrThrow(),
            orientation: dataPick('orientation').asSideOrThrow(),
            fen: dataPick('fen').asStringOrThrow(),
            white: dataPick('players').letOrThrow(
              (it) => it
                  .asListOrThrow(_featuredPlayerFromPick)
                  .firstWhere((p) => p.side == Side.white),
            ),
            black: dataPick('players').letOrThrow(
              (it) => it
                  .asListOrThrow(_featuredPlayerFromPick)
                  .firstWhere((p) => p.side == Side.black),
            ),
          ),
        );
      case 'fen':
        return pick('d').letOrThrow(
          (dataPick) => TvEvent.fen(
            fen: dataPick('fen').asStringOrThrow(),
            lastMove: dataPick('lm')
                .letOrThrow((it) => Move.fromUci(it.asStringOrThrow())!),
            whiteSeconds: dataPick('wc').asIntOrThrow(),
            blackSeconds: dataPick('bc').asIntOrThrow(),
          ),
        );
      default:
        throw UnsupportedError('Unsupported event type $type');
    }
  }

  factory TvEvent.gameFromJson(Map<String, dynamic> json) {
    print("**** $json");
    return TvEvent.gameFromPick(pick(json).required());
  }

  factory TvEvent.gameFromPick(RequiredPick pick) {
    final type = pick('id').asStringOrNull();
    if (type != null) {
      return TvEvent.featured(
        id: pick('id').asGameIdOrThrow(),
        orientation: Side.white, // FIX
        fen: pick('fen').asStringOrThrow(),
        white: _featuredGamePlayerFromPick(
          pick('players', 'white').required(),
          Side.white,
        ),
        black: _featuredGamePlayerFromPick(
          pick('players', 'black').required(),
          Side.black,
        ),
      );
    } else {
      final Move? lm =
          pick('lm').letOrNull((it) => Move.fromUci(it.asStringOrThrow())!) ??
              Move.fromUci("e2e2");
      return TvEvent.fen(
        fen: pick('fen').asStringOrThrow(),
        lastMove: lm!,
        whiteSeconds: pick('wc').asIntOrThrow(),
        blackSeconds: pick('bc').asIntOrThrow(),
      );
    }
    //default:
    //  throw UnsupportedError('Unsupported event type $type');
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

  static FeaturedPlayer _featuredGamePlayerFromPick(
    RequiredPick pick,
    Side side,
  ) {
    final int? ai = pick('aiLevel').asIntOrNull();
    String userName;
    if (ai != null) {
      userName = "AI level $ai";
    } else {
      userName = pick('user', 'name').asStringOrThrow();
    }
    return FeaturedPlayer(
      side: side,
      name: userName,
      title: pick('user', 'title').asStringOrNull(),
      rating: pick('rating').asIntOrNull(),
      seconds: pick('seconds').asIntOrNull(),
    );
  }
}
