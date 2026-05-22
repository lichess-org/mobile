import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

/// A widget that displays a chessboard, either interactive (with a [ChessboardController]) or fixed
/// (with a FEN string).
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
  }) : assert(
         (controller != null) != (fen != null),
         'Exactly one of controller or fen must be provided',
       );

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

/// Executes a pending premove on [ctrl] if it is legal in [position], calling [onMove] via
/// [scheduleMicrotask] to avoid modifying Riverpod providers inside widget lifecycle callbacks.
/// Clears the premove if it is illegal.
void tryExecutePremove(ChessboardController ctrl, Position position, void Function(Move) onMove) {
  final premove = ctrl.premove;
  if (premove == null) return;
  if (position.isLegal(premove)) {
    if (premove is NormalMove && isPromotionPawnMove(position, premove)) {
      ctrl.premove = null;
      ctrl.pendingPromotion = premove;
    } else {
      ctrl.premove = null;
      scheduleMicrotask(() => onMove(premove));
    }
  } else {
    // Premove became illegal (e.g. after a takeback) — clear it.
    ctrl.premove = null;
  }
}

/// Builds a [GameData] object for the given position and variant, including legal moves, check status, and crazyhouse drops.
GameData buildGameData({
  required Variant variant,
  required Position position,
  required PlayerSide playerSide,
  required CastlingMethod castlingMethod,
  required bool boardHighlights,
  Move? lastMove,
}) {
  return GameData(
    playerSide: playerSide,
    sideToMove: position.turn,
    validMoves: _makeLegalMoves(position, variant: variant, castlingMethod: castlingMethod),
    lastMove: lastMove,
    kingSquareInCheck: boardHighlights && position.isCheck
        ? position.board.kingOf(position.turn)
        : null,
    validDropSquares: variant == Variant.crazyhouse ? position.legalDrops.squares.toSet() : null,
  );
}

Map<Square, Set<Square>> _makeLegalMoves(
  Position pos, {
  required CastlingMethod castlingMethod,
  required Variant variant,
}) {
  final result = <Square, Set<Square>>{};
  for (final entry in pos.legalMoves.entries) {
    final dests = entry.value.squares;
    if (dests.isNotEmpty) {
      final from = entry.key;
      final destSet = dests.toSet();
      if (variant != Variant.chess960 &&
          from == pos.board.kingOf(pos.turn) &&
          entry.key.file == 4) {
        if (dests.contains(Square.a1)) {
          destSet.add(Square.c1);
        } else if (dests.contains(Square.a8)) {
          destSet.add(Square.c8);
        }
        if (dests.contains(Square.h1)) {
          destSet.add(Square.g1);
        } else if (dests.contains(Square.h8)) {
          destSet.add(Square.g8);
        }
        if (castlingMethod == CastlingMethod.kingTwoSquares) {
          destSet.removeAll([Square.a1, Square.h1, Square.a8, Square.h8]);
        }
      }
      result[from] = destSet;
    }
  }
  return result;
}
