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

  @override
  Widget build(BuildContext context) {
    ISet<Shape> allShapes = shapes ?? ISet();

    // Add check highlight for spectator mode (no gameData)
    if (gameData == null && fen.isNotEmpty) {
      final position = Chess.fromSetup(Setup.parseFen(fen));
      if (position.isCheck) {
        final kingSquare = position.board.kingOf(position.turn);
        if (kingSquare != null) {
          final checkHighlight = Circle(
            color: const Color(0xAA882020), // semi-transparent red
            orig: kingSquare,
          );
          allShapes = allShapes.add(checkHighlight);
        }
      }
    }

    final board = Chessboard(
      key: boardKey,
      size: size,
      fen: fen,
      orientation: orientation,
      game: gameData,
      lastMove: lastMove,
      shapes: allShapes,
      settings: settings,
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
        child: Stack(
          children: [
            board,
            _ErrorWidget(errorMessage: error!, boardSize: size),
          ],
        ),
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
