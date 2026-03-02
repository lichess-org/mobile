import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

part 'game_board_params.freezed.dart';

@freezed
sealed class GameBoardParams with _$GameBoardParams {
  const GameBoardParams._();

  const factory GameBoardParams.readonly({
    required String fen,
    required Variant variant,
    required Pockets? pockets,
  }) = ReadonlyBoardParams;

  const factory GameBoardParams.interactive({
    required Variant variant,
    required Position position,
    required PlayerSide playerSide,
    required NormalMove? promotionMove,
    required void Function(Move, {bool? viaDragAndDrop}) onMove,
    required void Function(Role? role) onPromotionSelection,
    required Premovable? premovable,
  }) = InteractiveBoardParams;

  static const emptyBoard = ReadonlyBoardParams(
    fen: kEmptyFEN,
    variant: Variant.standard,
    pockets: null,
  );

  String get fen => switch (this) {
    ReadonlyBoardParams(:final fen) => fen,
    InteractiveBoardParams(:final position) => position.fen,
  };

  Pockets? get pockets => switch (this) {
    ReadonlyBoardParams(:final pockets) => pockets,
    InteractiveBoardParams(:final position) => position.pockets,
  };
}
