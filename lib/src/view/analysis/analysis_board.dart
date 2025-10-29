import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_prefs.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_state.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/view/analysis/game_analysis_board.dart';
import 'package:lichess_mobile/src/view/analysis/retro_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

/// An abstract widget that provides the common interface for three types of analysis boards:
/// - [GameAnalysisBoard]
/// - [BroadcastAnalysisBoard]
/// - [StudyAnalysisBoard]
/// - [RetroAnalysisBoard]
abstract class AnalysisBoard extends ConsumerStatefulWidget {
  const AnalysisBoard({super.key, required this.boardSize, this.boardRadius});

  final double boardSize;
  final BorderRadiusGeometry? boardRadius;
}

/// Abstract state class for analysis board widgets.
abstract class AnalysisBoardState<
  T extends AnalysisBoard,
  AnalysisState extends CommonAnalysisState,
  AnalysisPrefs extends CommonAnalysisPrefs
>
    extends ConsumerState<T> {
  AnalysisState get analysisState;

  AnalysisPrefs get analysisPrefs;

  /// Whether the annotations should be shown on the board.
  bool get showAnnotations;

  /// Override this to hide the best move arrow in certain states, even if enabled in [analysisPrefs].
  bool get hideBestMoveArrow => false;

  void onUserMove(NormalMove move);

  void onPromotionSelection(Role? role);

  /// For the study board to set a different fen if the position is `null`.
  String get fen => analysisState.currentPosition!.fen;

  /// E.g. for the study board to add pgn shapes and variations arrows.
  ISet<Shape> get extraShapes => ISet();

  /// Can be used to disable interaction with the board in certain states
  bool get interactive => true;

  /// Set of shapes drawn by the user on the board (arrows, circle).
  ISet<Shape> userShapes = ISet();

  ISet<Shape> _bestMoveShapes(PieceAssets pieceAssets) {
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final currentPosition = analysisState.currentPosition;

    final showBestMoveArrow =
        !hideBestMoveArrow &&
        analysisState.isEngineAvailable(enginePrefs) &&
        analysisPrefs.showBestMoveArrow;

    if (!showBestMoveArrow || currentPosition == null) {
      return ISet();
    }

    final localEval = ref.watch(engineEvaluationProvider.select((value) => value.eval));

    final eval = localEval?.threatMode == true
        ? analysisState.currentNode.eval
        : pickBestClientEval(localEval: localEval, savedEval: analysisState.currentNode.eval);

    if (eval == null) {
      return ISet();
    }

    if (eval.position.fen != currentPosition.fen) {
      // Eval is out of sync, this usually happens after making a move on the board.
      // While waiting for the updated eval we don't want to show the best moves from the previous position.
      return ISet();
    }

    final bestMoveShapes = computeBestMoveShapes(
      eval.bestMoves,
      currentPosition.turn,
      pieceAssets,
      // Same colors as in the Web UI with a slightly different opacity
      // The best move has a different color than the other moves
      bestMoveColor: const Color(0x66003088),
      otherMovesColor: const Color(0x664A4A4A),
    );

    if (localEval?.threatMode == true) {
      final threatMoveShapes = computeBestMoveShapes(
        localEval!.bestMoves,
        currentPosition.turn.opposite,
        pieceAssets,
        bestMoveColor: LichessColors.red.withValues(alpha: 0.6),
        otherMovesColor: LichessColors.red.withValues(alpha: 0.4),
      );
      return {...threatMoveShapes, if (bestMoveShapes.isNotEmpty) bestMoveShapes.first}.toISet();
    }

    return bestMoveShapes;
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final currentNode = analysisState.currentNode;
    final currentPosition = analysisState.currentPosition;

    final annotation = showAnnotations ? makeAnnotation(currentNode.nags) : null;
    final sanMove = currentNode.sanMove;

    return Chessboard(
      size: widget.boardSize,
      orientation: analysisState.pov,
      fen: fen,
      lastMove: analysisState.lastMove as NormalMove?,
      game: (interactive && currentPosition != null)
          ? boardPrefs.toGameData(
              variant: analysisState.variant,
              position: currentPosition,
              playerSide: analysisState.currentPosition!.isGameOver
                  ? PlayerSide.none
                  : analysisState.currentPosition!.turn == Side.white
                  ? PlayerSide.white
                  : PlayerSide.black,
              promotionMove: analysisState.promotionMove,
              onMove: (move, {isDrop}) => onUserMove(move),
              onPromotionSelection: onPromotionSelection,
            )
          : null,
      shapes: userShapes.union(_bestMoveShapes(boardPrefs.pieceSet.assets)).union(extraShapes),
      annotations: sanMove != null && annotation != null
          ? (sanMove.san == 'O-O' || sanMove.san == 'O-O-O') &&
                    altCastles.containsKey(sanMove.move.uci)
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
