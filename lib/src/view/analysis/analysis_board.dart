import 'package:chessground/chessground.dart';
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
import 'package:lichess_mobile/src/widgets/pgn.dart';

class AnalysisBoard extends ConsumerStatefulWidget {
  const AnalysisBoard(
    this.options,
    this.boardSize, {
    this.borderRadius,
    this.enableDrawingShapes = true,
    this.shouldReplaceChildOnUserMove = false,
  });

  final AnalysisOptions options;
  final double boardSize;
  final BorderRadiusGeometry? borderRadius;

  final bool enableDrawingShapes;
  final bool shouldReplaceChildOnUserMove;

  @override
  ConsumerState<AnalysisBoard> createState() => AnalysisBoardState();
}

class AnalysisBoardState extends ConsumerState<AnalysisBoard> {
  ISet<Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisControllerProvider(widget.options);
    final analysisState = ref.watch(ctrlProvider).requireValue;
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final enableComputerAnalysis = analysisPrefs.enableComputerAnalysis;
    final showBestMoveArrow = enableComputerAnalysis && analysisPrefs.showBestMoveArrow;
    final showAnnotationsOnBoard = enableComputerAnalysis && analysisPrefs.showAnnotations;
    final evalBestMoves =
        enableComputerAnalysis
            ? ref.watch(engineEvaluationProvider.select((s) => s.eval?.bestMoves))
            : null;

    final currentNode = analysisState.currentNode;
    final annotation = showAnnotationsOnBoard ? makeAnnotation(currentNode.nags) : null;

    final bestMoves = enableComputerAnalysis ? evalBestMoves ?? currentNode.eval?.bestMoves : null;

    final sanMove = currentNode.sanMove;

    final ISet<Shape> bestMoveShapes =
        showBestMoveArrow && analysisState.isEngineAvailable && bestMoves != null
            ? computeBestMoveShapes(
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
        playerSide:
            analysisState.position.isGameOver
                ? PlayerSide.none
                : analysisState.position.turn == Side.white
                ? PlayerSide.white
                : PlayerSide.black,
        isCheck: boardPrefs.boardHighlights && analysisState.position.isCheck,
        sideToMove: analysisState.position.turn,
        validMoves: analysisState.validMoves,
        promotionMove: analysisState.promotionMove,
        onMove:
            (move, {isDrop, captured}) => ref
                .read(ctrlProvider.notifier)
                .onUserMove(move, shouldReplace: widget.shouldReplaceChildOnUserMove),
        onPromotionSelection: (role) => ref.read(ctrlProvider.notifier).onPromotionSelection(role),
      ),
      shapes: userShapes.union(bestMoveShapes),
      annotations:
          showAnnotationsOnBoard && sanMove != null && annotation != null
              ? altCastles.containsKey(sanMove.move.uci)
                  ? IMap({Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation})
                  : IMap({sanMove.move.to: annotation})
              : null,
      settings: boardPrefs.toBoardSettings().copyWith(
        borderRadius: widget.borderRadius,
        boxShadow: widget.borderRadius != null ? boardShadows : const <BoxShadow>[],
        drawShape: DrawShapeOptions(
          enable: widget.enableDrawingShapes,
          onCompleteShape: _onCompleteShape,
          onClearShapes: _onClearShapes,
          newShapeColor: boardPrefs.shapeColor.color,
        ),
      ),
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
