import 'dart:math' as math;

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
import 'package:lichess_mobile/src/widgets/board.dart';
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

  void onUserMove(Move move);

  /// For the study board to set a different fen if the position is `null`.
  String get fen => analysisState.currentPosition!.fen;

  /// E.g. for the study board to add pgn shapes and variations arrows.
  ISet<Shape> get extraShapes => ISet();

  /// Can be used to disable interaction with the board in certain states
  bool get interactive => true;

  /// Filters to identify the correct engine evaluation provider instance.
  EngineEvaluationFilters get engineEvaluationFilters;

  ChessboardController? _controller;

  /// FEN from the last build, used to detect position changes.
  String? _lastBuiltFen;

  /// Clears all user-drawn shapes from the board.
  void clearDrawnShapes() => _controller?.clearDrawnShapes();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Set<Shape> _bestMoveShapes(PieceAssets pieceAssets) {
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final currentPosition = analysisState.currentPosition;

    final showBestMoveArrow =
        !hideBestMoveArrow &&
        analysisState.isEngineAvailable(enginePrefs) &&
        analysisPrefs.showBestMoveArrow;

    if (!showBestMoveArrow || currentPosition == null) {
      return {};
    }

    final localEval = ref.watch(
      engineEvaluationProvider(engineEvaluationFilters).select((value) => value.eval),
    );

    final eval = localEval?.threatMode == true
        ? analysisState.currentNode.eval
        : pickBestClientEval(localEval: localEval, savedEval: analysisState.currentNode.eval);

    if (eval == null) {
      return {};
    }

    if (eval.position.fen != currentPosition.fen) {
      // Eval is out of sync, this usually happens after making a move on the board.
      // While waiting for the updated eval we don't want to show the best moves from the previous position.
      return {};
    }

    final bestMoveShapes = computeBestMoveShapes(
      // cloud eval might have more lines than local eval so make sure to only show as many as allowed
      eval.bestMoves.take(math.max(1, enginePrefs.numEvalLines)).toIList(),
      currentPosition.turn,
      pieceAssets,
      // Same colors as in the Web UI with a slightly different opacity
      // The best move has a different color than the other moves
      bestMoveColor: const Color(0x66003088),
      nextBestMovesColor: const Color(0x664A4A4A),
    );

    if (localEval?.threatMode == true) {
      final threatMoveShapes = computeBestMoveShapes(
        localEval!.bestMoves,
        currentPosition.turn.opposite,
        pieceAssets,
        bestMoveColor: LichessColors.red.withValues(alpha: 0.6),
        nextBestMovesColor: LichessColors.red.withValues(alpha: 0.4),
      );
      return {...threatMoveShapes, if (bestMoveShapes.isNotEmpty) bestMoveShapes.first};
    }

    return bestMoveShapes.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final currentNode = analysisState.currentNode;
    final currentPosition = analysisState.currentPosition;

    final annotation = showAnnotations ? makeAnnotation(currentNode.nags) : null;
    final sanMove = currentNode.sanMove;

    final playerSide = (interactive && currentPosition != null)
        ? currentPosition.isGameOver
              ? PlayerSide.none
              : currentPosition.turn == Side.white
              ? PlayerSide.white
              : PlayerSide.black
        : PlayerSide.none;

    final newFen = fen;

    if (_controller == null) {
      if (interactive && currentPosition != null) {
        _controller = ChessboardController(
          fen: newFen,
          game: boardPrefs.buildGameData(
            variant: analysisState.variant,
            position: currentPosition,
            playerSide: playerSide,
            lastMove: analysisState.lastMove,
          ),
        );
      }
    } else if (newFen != _lastBuiltFen) {
      final ctrl = _controller!;
      final gameData = (interactive && currentPosition != null)
          ? boardPrefs.buildGameData(
              variant: analysisState.variant,
              position: currentPosition,
              playerSide: playerSide,
              lastMove: analysisState.lastMove,
            )
          : null;
      final explosionSquares = analysisState.explosionSquares;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.jumpToPosition(newFen, game: gameData, lastMove: analysisState.lastMove);
        if (explosionSquares != null) {
          ctrl.triggerExplosion(explosionSquares.toSet());
        }
      });
    } else if (_controller != null && currentPosition != null) {
      // Same FEN but game data may have changed (e.g. playerSide changed)
      final ctrl = _controller!;
      final gameData = interactive
          ? boardPrefs.buildGameData(
              variant: analysisState.variant,
              position: currentPosition,
              playerSide: playerSide,
              lastMove: analysisState.lastMove,
            )
          : null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.updatePosition(newFen, game: gameData);
      });
    }

    _lastBuiltFen = newFen;

    final externalShapes = {..._bestMoveShapes(boardPrefs.pieceSet.assets), ...extraShapes.unlock};

    final boardAnnotations = sanMove != null && annotation != null
        ? (sanMove.isCastles && altCastles.containsKey(sanMove.move.uci)
              ? {Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation}
              : {sanMove.move.to: annotation})
        : const <Square, Annotation>{};

    final ctrl = _controller;

    if (ctrl == null) {
      return BoardWidget(
        size: widget.boardSize,
        orientation: analysisState.pov,
        fen: newFen,
        lastMove: analysisState.lastMove,
        shapes: externalShapes,
        settings: boardPrefs.toBoardSettings().copyWith(
          borderRadius: widget.boardRadius,
          boxShadow: widget.boardRadius != null ? boardShadows : const <BoxShadow>[],
        ),
        annotations: boardAnnotations,
      );
    }

    return BoardWidget(
      size: widget.boardSize,
      orientation: analysisState.pov,
      controller: ctrl,
      onMove: (move, {viaDragAndDrop}) => onUserMove(move),
      shapes: externalShapes,
      settings: boardPrefs.toBoardSettings().copyWith(
        borderRadius: widget.boardRadius,
        boxShadow: widget.boardRadius != null ? boardShadows : const <BoxShadow>[],
        drawShape: DrawShapeOptions(
          enable: boardPrefs.enableShapeDrawings,
          newShapeColor: boardPrefs.shapeColor.color,
        ),
      ),
      annotations: boardAnnotations,
    );
  }
}
