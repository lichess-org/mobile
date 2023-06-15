import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';

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
    required MaterialDiff diff,
  }) = _FeaturedPosition;

  factory FeaturedPosition.fromTvEvent(TvEvent event) {
    final position = Chess.fromSetup(
      Setup.parseFen(event.fen),
      ignoreImpossibleCheck: true,
    );

    return FeaturedPosition(
      fen: event.fen,
      turn: event.fen.substring(event.fen.length - 1) == 'w'
          ? Side.white
          : Side.black,
      position: position,
      lastMove: event is TvFenEvent ? event.lastMove : null,
      diff: MaterialDiff.fromBoard(position.board),
    );
  }

  bool get isGameOver => position.isGameOver;
}
