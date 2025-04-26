import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
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
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);

    final showBestMoveArrow =
        analysisState.isEngineAvailable(enginePrefs) && analysisPrefs.showBestMoveArrow;
    final showAnnotations =
        analysisState.isComputerAnalysisAllowedAndEnabled && analysisPrefs.showAnnotations;
    final currentNode = analysisState.currentNode;

    final bestMoves =
        showBestMoveArrow
            ? pickBestClientEval(
              localEval: ref.watch(engineEvaluationProvider.select((value) => value.eval)),
              savedEval: currentNode.eval,
            )?.bestMoves
            : null;
    final ISet<Shape> bestMoveShapes =
        bestMoves != null
            ? computeBestMoveShapes(
              bestMoves,
              currentNode.position.turn,
              boardPrefs.pieceSet.assets,
            )
            : ISet();

    final annotation = showAnnotations ? makeAnnotation(currentNode.nags) : null;
    final sanMove = currentNode.sanMove;

    return Chessboard(
      size: widget.boardSize,
      fen: analysisState.currentPosition.fen,
      lastMove: analysisState.lastMove as NormalMove?,
      orientation: analysisState.pov,
      game: boardPrefs.toGameData(
        variant: analysisState.variant,
        position: analysisState.currentPosition,
        playerSide:
            analysisState.currentPosition.isGameOver
                ? PlayerSide.none
                : analysisState.currentPosition.turn == Side.white
                ? PlayerSide.white
                : PlayerSide.black,
        promotionMove: analysisState.promotionMove,
        onMove:
            (move, {isDrop, captured}) => ref
                .read(ctrlProvider.notifier)
                .onUserMove(move, shouldReplace: widget.shouldReplaceChildOnUserMove),
        onPromotionSelection: (role) => ref.read(ctrlProvider.notifier).onPromotionSelection(role),
      ),
      shapes: userShapes.union(bestMoveShapes),
      annotations:
          sanMove != null && annotation != null
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
