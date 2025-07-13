import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/abstract_analysis_prefs.dart';
import 'package:lichess_mobile/src/model/analysis/abstract_analysis_state.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

abstract class AbstractAnalysisBoard extends ConsumerStatefulWidget {
  const AbstractAnalysisBoard({super.key, required this.boardSize, this.boardRadius});

  final double boardSize;
  final BorderRadiusGeometry? boardRadius;
}

abstract class AbstractAnalysisBoardState<
  AnalysisBoard extends AbstractAnalysisBoard,
  AnalysisState extends AbstractAnalysisState,
  AnalysisPrefs extends AbstractAnalysisPrefs
>
    extends ConsumerState<AnalysisBoard> {
  AnalysisState get analysisState;

  AnalysisPrefs get analysisPrefs;

  void onUserMove(NormalMove move);

  void onPromotionSelection(Role? role);

  ISet<Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);

    final showBestMoveArrow =
        analysisState.isEngineAvailable(enginePrefs) && analysisPrefs.showBestMoveArrow;
    final showAnnotations =
        analysisState.isComputerAnalysisAllowed &&
        analysisState.isServerAnalysisEnabled &&
        analysisPrefs.showAnnotations;
    final currentNode = analysisState.currentNode;

    final bestMoves = showBestMoveArrow
        ? pickBestClientEval(
            localEval: ref.watch(engineEvaluationProvider.select((value) => value.eval)),
            savedEval: currentNode.eval,
          )?.bestMoves
        : null;
    final ISet<Shape> bestMoveShapes = bestMoves != null
        ? computeBestMoveShapes(bestMoves, currentNode.position.turn, boardPrefs.pieceSet.assets)
        : ISet();

    final annotation = showAnnotations ? makeAnnotation(currentNode.nags) : null;
    final sanMove = currentNode.sanMove;

    return Chessboard(
      size: widget.boardSize,
      orientation: analysisState.pov,
      fen: analysisState.currentPosition.fen,
      lastMove: analysisState.lastMove as NormalMove?,
      game: boardPrefs.toGameData(
        variant: analysisState.variant,
        position: analysisState.currentPosition,
        playerSide: analysisState.currentPosition.isGameOver
            ? PlayerSide.none
            : analysisState.currentPosition.turn == Side.white
            ? PlayerSide.white
            : PlayerSide.black,
        promotionMove: analysisState.promotionMove,
        onMove: (move, {isDrop}) => onUserMove(move),
        onPromotionSelection: onPromotionSelection,
      ),
      shapes: userShapes.union(bestMoveShapes),
      annotations: sanMove != null && annotation != null
          ? altCastles.containsKey(sanMove.move.uci)
                ? IMap({Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation})
                : IMap({sanMove.move.to: annotation})
          : null,
      settings: boardPrefs.toBoardSettings().copyWith(
        borderRadius: widget.boardRadius,
        boxShadow: widget.boardRadius != null ? boardShadows : const <BoxShadow>[],
        drawShape: DrawShapeOptions(
          enable: boardPrefs.enableShapeDrawings,
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
