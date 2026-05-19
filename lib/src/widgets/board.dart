import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({
    required this.size,
    required this.orientation,
    required this.settings,
    this.controller,
    this.onMove,
    this.fen,
    this.lastMove,
    this.shapes = const {},
    this.annotations = const {},
    this.boardOverlay,
    this.error,
    this.boardKey,
  }) : assert(controller != null || fen != null);

  final double size;
  final Side orientation;
  final ChessboardSettings settings;

  /// Controller for the interactive board. Mutually exclusive with [fen].
  final ChessboardController? controller;

  /// Called when the user completes a move on the interactive board.
  final void Function(Move, {bool? viaDragAndDrop})? onMove;

  /// FEN string for the fixed (non-interactive) board. Mutually exclusive with [controller].
  final String? fen;

  /// Last move highlight for the fixed board. Ignored when [controller] is set.
  final Move? lastMove;

  /// External shapes to draw on the board (engine arrows, analysis annotations, etc.).
  final Set<Shape> shapes;

  /// Move annotations to display on the board.
  final Map<Square, Annotation> annotations;

  final String? error;
  final Widget? boardOverlay;
  final GlobalKey? boardKey;

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    final board = ctrl != null
        ? Chessboard(
            key: boardKey,
            controller: ctrl,
            size: size,
            orientation: orientation,
            onMove: onMove,
            shapes: shapes,
            annotations: annotations,
            settings: settings,
          )
        : Chessboard.fixed(
            key: boardKey,
            size: size,
            orientation: orientation,
            fen: fen!,
            lastMove: lastMove,
            shapes: shapes,
            annotations: annotations,
            settings: settings,
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
