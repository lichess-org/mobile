import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

/// A stateless widget that displays an interactive chess board.
class InteractiveBoardWidget extends StatelessWidget {
  InteractiveBoardWidget({
    required this.size,
    required this.boardPrefs,
    required this.fen,
    required this.orientation,
    required this.gameData,
    this.lastMove,
    this.shapes,
    required this.settings,
    this.boardOverlay,
    this.error,
    this.annotations,
    this.boardKey,
  }) : setup = Setup.parseFen(fen);

  final double size;
  final BoardPrefs boardPrefs;
  final String fen;
  final Side orientation;
  final GameData? gameData;
  final Move? lastMove;
  final ISet<Shape>? shapes;
  final ChessboardSettings settings;
  final String? error;
  final Widget? boardOverlay;
  final IMap<Square, Annotation>? annotations;
  final GlobalKey? boardKey;
  final Setup setup;

  @override
  Widget build(BuildContext context) {
    const Map<Square, Square> castlingMap = {
      Square.a1: Square.c1,
      Square.a8: Square.c8,
      Square.h1: Square.g1,
      Square.h8: Square.g8,
    };

    GameData? modifiedGameData;

    MapEntry<Square, ISet<Square>> mapper(Square sq, ISet<Square> moves) {
      return MapEntry(
        sq,
        setup.board.kings.squares.contains(sq) && //king move
                setup.castlingRights.squares.intersectsWith(
                  moves, //king can castle
                )
            ? (switch (boardPrefs.castlingMethod) {
              CastlingMethod.kingOverRook => moves.removeAll(castlingMap.values),
              CastlingMethod.kingTwoSquares => moves.removeAll(castlingMap.keys),
              _ => moves,
            })
            : moves,
      );
    }

    if (gameData != null) {
      modifiedGameData = GameData(
        playerSide: gameData!.playerSide,
        sideToMove: gameData!.sideToMove,
        validMoves: gameData!.validMoves.map(mapper),
        promotionMove: gameData!.promotionMove,
        onMove: gameData!.onMove,
        onPromotionSelection: gameData!.onPromotionSelection,
        premovable: gameData?.premovable,
        isCheck: gameData?.isCheck,
      );
    }

    final board = Chessboard(
      key: boardKey,
      size: size,
      fen: fen,
      orientation: orientation,
      game: modifiedGameData ?? gameData,
      lastMove: lastMove,
      shapes: shapes,
      settings: settings,
      annotations: annotations,
    );

    if (boardOverlay != null) {
      return SizedBox.square(
        dimension: size,
        child: Stack(
          children: [
            board,
            SizedBox.square(
              dimension: size,
              child: Center(
                child: SizedBox(
                  width: (size / 8) * 6.6,
                  height: (size / 8) * 4.6,
                  child: boardOverlay,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (error != null) {
      return SizedBox.square(
        dimension: size,
        child: Stack(children: [board, _ErrorWidget(errorMessage: error!, boardSize: size)]),
      );
    }

    return board;
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.errorMessage, required this.boardSize});
  final double boardSize;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: boardSize,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(padding: const EdgeInsets.all(10.0), child: Text(errorMessage)),
          ),
        ),
      ),
    );
  }
}
