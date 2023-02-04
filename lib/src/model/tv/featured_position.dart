import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'tv_event.dart';

part 'featured_position.freezed.dart';

@freezed
class FeaturedPosition with _$FeaturedPosition {
  const FeaturedPosition._();

  const factory FeaturedPosition({
    required String fen,
    Move? lastMove,
    required Side turn,
    required Chess position,
  }) = _FeaturedPosition;

  factory FeaturedPosition.fromTvEvent(TvEvent event) {
    return FeaturedPosition(
      fen: event.fen,
      turn: event.fen.substring(event.fen.length - 1) == 'w'
          ? Side.white
          : Side.black,
      position: Chess.fromSetup(
        Setup.parseFen(event.fen),
        ignoreImpossibleCheck: true,
      ),
      lastMove: event is TvFenEvent ? event.lastMove : null,
    );
  }

  bool get isGameOver => position.isGameOver;
}
