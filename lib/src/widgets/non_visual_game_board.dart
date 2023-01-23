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
    this.isLoading = false,
    super.key,
  });

  final GameState? gameState;

  final void Function(Move) onMove;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final position = gameState?.position ?? Chess.initial;
    final lastSanMove = gameState?.sanMoves.isNotEmpty == true
        ? gameState!.sanMoves.last
        : null;
    return NonVisualBoard(
      position: position,
      lastSanMove: lastSanMove,
      isLoading: isLoading,
      loadCompleteMsg: 'Game loaded',
      handleCommand: (command) {
        final lowered = command.toLowerCase();
        if (lowered == 'c' || lowered == 'clock') {
          return 'todo: read clocks';
        } else if (lowered == 'l' || lowered == 'last') {
          return renderCurrentPos(lastSanMove, position);
        } else if (lowered == 'o' || lowered == 'opponent') {
          return 'todo: read player';
        }
        final move = Move.fromUci(command) ?? position.parseSan(command);
        if (move != null) {
          onMove(move);
          return null;
        }
        return handlePieceCommand(command, position.board) ??
            handleScanCommand(lowered, position.board) ??
            handlePossibleMovesCommand(lowered, position) ??
            'Invalid command: $command';
      },
    );
  }
}
