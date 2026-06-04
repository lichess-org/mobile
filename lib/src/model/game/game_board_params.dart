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
    Move? lastMove,
  }) = ReadonlyBoardParams;

  const factory GameBoardParams.interactive({
    required Variant variant,
    required Position position,
    required PlayerSide playerSide,
    required void Function(Move, {bool? viaDragAndDrop}) onMove,
    Move? lastMove,
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

  PlayerSide get playerSide => switch (this) {
    ReadonlyBoardParams() => PlayerSide.none,
    InteractiveBoardParams(:final playerSide) => playerSide,
  };
}

/// Board parameters for the high-performance path, where the caller owns a
/// [ChessboardController] and drives it directly.
///
/// Mutually exclusive with [GameBoardParams]: the [controller] carries the live
/// position and game state (including `playerSide` and `sideToMove`), so this
/// only needs to provide what isn't part of the controller — the [variant] (for
/// board settings), the [onMove] callback, and the crazyhouse [pockets] (which
/// the owner must refresh on each move).
class ControllerBoardParams {
  const ControllerBoardParams({
    required this.controller,
    required this.variant,
    this.onMove,
    this.pockets,
  });

  /// The externally owned controller. [GameLayout] renders the board with it but
  /// never creates, disposes, or drives it.
  final ChessboardController controller;

  final Variant variant;

  /// Called when the user completes a move on the board.
  final void Function(Move, {bool? viaDragAndDrop})? onMove;

  /// Crazyhouse pockets, or null for variants without pockets.
  final Pockets? pockets;
}
