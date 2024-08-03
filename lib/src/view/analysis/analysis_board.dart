import 'dart:math' as math;
import 'dart:ui';

import 'package:chessground/chessground.dart' as cg;
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
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/view/analysis/annotations.dart';

class AnalysisBoard extends ConsumerStatefulWidget {
  const AnalysisBoard(
    this.pgn,
    this.options,
    this.boardSize, {
    required this.isTablet,
  });

  final String pgn;
  final AnalysisOptions options;
  final double boardSize;
  final bool isTablet;

  @override
  ConsumerState<AnalysisBoard> createState() => AnalysisBoardState();
}

class AnalysisBoardState extends ConsumerState<AnalysisBoard> {
  ISet<cg.Shape> userShapes = ISet();

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

    final ISet<cg.Shape> bestMoveShapes = showBestMoveArrow &&
            analysisState.isEngineAvailable &&
            bestMoves != null
        ? _computeBestMoveShapes(bestMoves)
        : ISet();

    return cg.Board(
      size: widget.boardSize,
      onMove: (move, {isDrop, isPremove}) =>
          ref.read(ctrlProvider.notifier).onUserMove(Move.fromUci(move.uci)!),
      data: cg.BoardData(
        orientation: analysisState.pov.cg,
        interactableSide: analysisState.position.isGameOver
            ? cg.InteractableSide.none
            : analysisState.position.turn == Side.white
                ? cg.InteractableSide.white
                : cg.InteractableSide.black,
        fen: analysisState.position.fen,
        isCheck: boardPrefs.boardHighlights && analysisState.position.isCheck,
        lastMove: analysisState.lastMove?.cg,
        sideToMove: analysisState.position.turn.cg,
        validMoves: analysisState.validMoves,
        shapes: userShapes.union(bestMoveShapes),
        annotations:
            showAnnotationsOnBoard && sanMove != null && annotation != null
                ? altCastles.containsKey(sanMove.move.uci)
                    ? IMap({
                        Move.fromUci(altCastles[sanMove.move.uci]!)!.cg.to:
                            annotation,
                      })
                    : IMap({sanMove.move.cg.to: annotation})
                : null,
      ),
      settings: boardPrefs.toBoardSettings().copyWith(
            borderRadius: widget.isTablet
                ? const BorderRadius.all(Radius.circular(4.0))
                : BorderRadius.zero,
            boxShadow: widget.isTablet ? boardShadows : const <BoxShadow>[],
            drawShape: cg.DrawShapeOptions(
              enable: true,
              onCompleteShape: _onCompleteShape,
              onClearShapes: _onClearShapes,
            ),
          ),
    );
  }

  ISet<cg.Shape> _computeBestMoveShapes(IList<MoveWithWinningChances> moves) {
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
                cg.Arrow(
                  color: color,
                  orig: move.cg.from,
                  dest: move.cg.to,
                  scale: scaleArrowAgainstBestMove(i),
                ),
                if (promRole != null)
                  cg.PieceShape(
                    color: color,
                    orig: move.cg.to,
                    role: promRole.cg,
                  ),
              ];
            case DropMove(role: final role, to: _):
              return [
                cg.PieceShape(
                  color: color,
                  orig: move.cg.to,
                  role: role.cg,
                ),
              ];
          }
        },
      ).expand((e) => e),
    );
  }

  void _onClearShapes() {
    setState(() {
      userShapes = ISet();
    });
  }

  void _onCompleteShape(cg.Shape shape) {
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
}
