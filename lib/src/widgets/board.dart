import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({
    required this.size,
    required this.fen,
    required this.orientation,
    required this.gameData,
    this.lastMove,
    this.shapes,
    required this.settings,
    this.boardOverlay,
    this.error,
    this.boardKey,
    this.explosionSquares,
  });

  final double size;
  final String fen;
  final Side orientation;
  final GameData? gameData;
  final Move? lastMove;
  final ISet<Shape>? shapes;
  final ChessboardSettings settings;
  final String? error;
  final Widget? boardOverlay;
  final GlobalKey? boardKey;
  final ISet<Square>? explosionSquares;

  @override
  Widget build(BuildContext context) {
    final board = Chessboard(
      key: boardKey,
      size: size,
      fen: fen,
      orientation: orientation,
      game: gameData,
      lastMove: lastMove,
      shapes: shapes,
      settings: settings,
      explosionSquares: explosionSquares,
    );

    final overlay = boardOverlay ?? (error != null ? _ErrorWidget(errorMessage: error!) : null);

    if (overlay != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          board,
          Positioned(
            left: 16.0,
            right: 16.0,
            top: 0,
            bottom: 0,
            child: Center(
              child: OverflowBox(maxHeight: double.infinity, child: overlay),
            ),
          ),
        ],
      );
    }

    return board;
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.errorMessage});
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Text(errorMessage),
    );
  }
}
