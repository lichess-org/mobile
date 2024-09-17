import 'dart:math' as math;
import 'dart:ui';

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/view/analysis/annotations.dart';

class AnalysisBoard extends ConsumerStatefulWidget {
  const AnalysisBoard(
    this.pgn,
    this.options,
    this.boardSize, {
    this.borderRadius,
  });

  final String pgn;
  final AnalysisOptions options;
  final double boardSize;
  final BorderRadiusGeometry? borderRadius;

  @override
  ConsumerState<AnalysisBoard> createState() => AnalysisBoardState();
}

class AnalysisBoardState extends ConsumerState<AnalysisBoard> {
  ISet<Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisControllerProvider(widget.pgn, widget.options);
    final analysisState = ref.watch(ctrlProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final showBestMoveArrow = ref.watch(
      analysisPreferencesProvider.select(
        (value) => value.showBestMoveArrow,
      ),
    );
    final showAnnotationsOnBoard = ref.watch(
      analysisPreferencesProvider.select((value) => value.showAnnotations),
    );

    final evalBestMoves = ref.watch(
      engineEvaluationProvider.select((s) => s.eval?.bestMoves),
    );

    final currentNode = analysisState.currentNode;
    final annotation = makeAnnotation(currentNode.nags);

    final bestMoves = evalBestMoves ?? currentNode.eval?.bestMoves;

    final sanMove = currentNode.sanMove;

    final ISet<Shape> bestMoveShapes = showBestMoveArrow &&
            analysisState.isEngineAvailable &&
            bestMoves != null
        ? _computeBestMoveShapes(
            bestMoves,
            currentNode.position.turn,
            boardPrefs.pieceSet.assets,
          )
        : ISet();

    return Chessboard(
      size: widget.boardSize,
      fen: analysisState.position.fen,
      lastMove: analysisState.lastMove as NormalMove?,
      orientation: analysisState.pov,
      game: GameData(
        playerSide: analysisState.position.isGameOver
            ? PlayerSide.none
            : analysisState.position.turn == Side.white
                ? PlayerSide.white
                : PlayerSide.black,
        isCheck: boardPrefs.boardHighlights && analysisState.position.isCheck,
        sideToMove: analysisState.position.turn,
        validMoves: analysisState.validMoves,
        promotionMove: analysisState.promotionMove,
        onMove: (move, {isDrop, captured}) =>
            ref.read(ctrlProvider.notifier).onUserMove(move),
        onPromotionSelection: (role) =>
            ref.read(ctrlProvider.notifier).onPromotionSelection(role),
      ),
      shapes: userShapes.union(bestMoveShapes),
      annotations:
          showAnnotationsOnBoard && sanMove != null && annotation != null
              ? altCastles.containsKey(sanMove.move.uci)
                  ? IMap({
                      Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation,
                    })
                  : IMap({sanMove.move.to: annotation})
              : null,
      settings: boardPrefs.toBoardSettings().copyWith(
            borderRadius: widget.borderRadius,
            boxShadow: widget.borderRadius != null
                ? boardShadows
                : const <BoxShadow>[],
            drawShape: DrawShapeOptions(
              enable: true,
              onCompleteShape: _onCompleteShape,
              onClearShapes: _onClearShapes,
              newShapeColor: boardPrefs.shapeColor.color,
            ),
          ),
    );
  }

  ISet<Shape> _computeBestMoveShapes(
    IList<MoveWithWinningChances> moves,
    Side sideToMove,
    PieceAssets pieceAssets,
  ) {
    // Scale down all moves with index > 0 based on how much worse their winning chances are compared to the best move
    // (assume moves are ordered by their winning chances, so index==0 is the best move)
    double scaleArrowAgainstBestMove(int index) {
      const minScale = 0.15;
      const maxScale = 1.0;
      const winningDiffScaleFactor = 2.5;

      final bestMove = moves[0];
      final winningDiffComparedToBestMove =
          bestMove.winningChances - moves[index].winningChances;
      // Force minimum scale if the best move is significantly better than this move
      if (winningDiffComparedToBestMove > 0.3) {
        return minScale;
      }
      return clampDouble(
        math.max(
          minScale,
          maxScale - winningDiffScaleFactor * winningDiffComparedToBestMove,
        ),
        0,
        1,
      );
    }

    return ISet(
      moves.mapIndexed(
        (i, m) {
          final move = m.move;
          // Same colors as in the Web UI with a slightly different opacity
          // The best move has a different color than the other moves
          final color = Color((i == 0) ? 0x66003088 : 0x664A4A4A);
          switch (move) {
            case NormalMove(from: _, to: _, promotion: final promRole):
              return [
                Arrow(
                  color: color,
                  orig: move.from,
                  dest: move.to,
                  scale: scaleArrowAgainstBestMove(i),
                ),
                if (promRole != null)
                  PieceShape(
                    color: color,
                    orig: move.to,
                    pieceAssets: pieceAssets,
                    piece: Piece(color: sideToMove, role: promRole),
                  ),
              ];
            case DropMove(role: final role, to: _):
              return [
                PieceShape(
                  color: color,
                  orig: move.to,
                  pieceAssets: pieceAssets,
                  opacity: 0.5,
                  piece: Piece(color: sideToMove, role: role),
                ),
              ];
          }
        },
      ).expand((e) => e),
    );
  }

  void _onCompleteShape(Shape shape) {
    if (userShapes.any((element) => element == shape)) {
      setState(() {
        userShapes = userShapes.remove(shape);
      });
      return;
    } else {
      setState(() {
        userShapes = userShapes.add(shape);
      });
    }
  }

  void _onClearShapes() {
    setState(() {
      userShapes = ISet();
    });
  }
}
