import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/non_visual_board.dart';

import '../features/game/model/game_state.dart';

/// Wrapper around NonVisualBoard that implements commands specific to
/// playing games
class NonVisualGameBoard extends StatelessWidget {
  const NonVisualGameBoard({
    required this.gameState,
    required this.onMove,
    super.key,
  });

  final GameState gameState;

  final void Function(Move) onMove;

  @override
  Widget build(BuildContext context) {
    final board = gameState.position.board;
    final lastSanMove =
        gameState.sanMoves.isEmpty ? null : gameState.sanMoves.last;
    return NonVisualBoard(
      position: gameState.position,
      lastSanMove: gameState.sanMoves.last,
      handleCommand: (command) {
        final lowered = command.toLowerCase();
        if (lowered == 'c' || lowered == 'clock') {
          return 'todo: read clocks';
        } else if (lowered == 'l' || lowered == 'last') {
          return renderCurrentPos(lastSanMove, gameState.position);
        } else if (lowered == 'o' || lowered == 'opponent') {
          return 'todo: read player';
        }
        final pieceResult = handlePieceCommand(command, board);
        if (pieceResult != null) {
          return pieceResult;
        }
        final scanResult = handleScanCommand(lowered, board);
        if (scanResult != null) {
          return scanResult;
        }
        return 'Invalid command: $command';
      },
    );
  }
}
