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

  /// Reads the current analysis state without subscribing.
  ///
  /// Called once in [initState] to eagerly create the board controller.
  /// Implement as: `ref.read(yourControllerProvider(...)).value`
  AnalysisState? readCurrentState();

  /// Sets up a subscription to analysis state changes.
  ///
  /// Called in [initState] to drive controller position updates.
  /// Implement as: `ref.listenManual(yourControllerProvider(...).select((v) => v.value), listener)`
  /// The subscription is managed by Riverpod and cancelled automatically on dispose.
  void listenToStateChanges(void Function(AnalysisState? prev, AnalysisState? next) listener);

  /// Computes the board FEN string from [state].
  ///
  /// Each board defines its own FEN semantics and is responsible for handling
  /// (or asserting the absence of) a null [CommonAnalysisState.currentPosition].
  String computeFen(AnalysisState state);

  String get fen => computeFen(analysisState);

  /// Whether the board should be interactive for [state].
  ///
  /// Override to conditionally disable user interaction.
  bool computeInteractive(AnalysisState state) => true;

  /// Whether the board should be interactive for the current [analysisState].
  bool get interactive => computeInteractive(analysisState);

  /// E.g. for the study board to add pgn shapes and variations arrows.
  ISet<Shape> get extraShapes => ISet();

  /// Filters to identify the correct engine evaluation provider instance.
  EngineEvaluationFilters get engineEvaluationFilters;

  ChessboardController? _controller;

  /// Clears all user-drawn shapes from the board.
  void clearDrawnShapes() => _controller?.clearDrawnShapes();

  @override
  void initState() {
    super.initState();
    final initialState = readCurrentState();
    if (initialState != null) {
      _controller = _createController(initialState, ref.read(boardPreferencesProvider));
    }
    listenToStateChanges(_onAnalysisStateChanged);
    ref.listenManual<BoardPrefs>(boardPreferencesProvider, _onBoardPrefsChanged);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  GameData? _buildGameData(AnalysisState state, BoardPrefs boardPrefs) {
    final position = state.currentPosition;
    if (position == null) return null;
    final playerSide = !computeInteractive(state) || position.isGameOver
        ? PlayerSide.none
        : position.turn == Side.white
        ? PlayerSide.white
        : PlayerSide.black;
    return buildGameData(
      fen: computeFen(state),
      variant: state.variant,
      position: position,
      playerSide: playerSide,
      lastMove: state.lastMove,
      castlingMethod: boardPrefs.castlingMethod,
      boardHighlights: boardPrefs.boardHighlights,
    );
  }

  ChessboardController? _createController(AnalysisState state, BoardPrefs boardPrefs) {
    final gameData = _buildGameData(state, boardPrefs);
    if (gameData == null) return null;
    return ChessboardController(game: gameData);
  }

  void _onAnalysisStateChanged(AnalysisState? prev, AnalysisState? next) {
    if (!mounted || next == null) return;
    final boardPrefs = ref.read(boardPreferencesProvider);
    final controller = _controller;
    if (controller == null) {
      final ctrl = _createController(next, boardPrefs);
      if (ctrl != null) setState(() => _controller = ctrl);
      return;
    }
    final newFen = computeFen(next);
    final gameData = _buildGameData(next, boardPrefs);
    final prevFen = prev != null ? computeFen(prev) : null;
    if (prevFen != newFen) {
      if (gameData != null) controller.updatePosition(gameData, resetPremove: true);
      final explosionSquares = next.explosionSquares;
      if (explosionSquares != null) {
        controller.triggerExplosion(explosionSquares.toSet());
      }
    } else if (gameData != null) {
      controller.updatePosition(gameData);
    }
  }

  void _onBoardPrefsChanged(BoardPrefs? prev, BoardPrefs next) {
    final controller = _controller;
    if (controller == null) return;
    final state = readCurrentState();
    if (state == null) return;
    final gameData = _buildGameData(state, next);
    if (gameData != null) controller.updatePosition(gameData);
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
    final annotation = showAnnotations ? makeAnnotation(currentNode.nags) : null;
    final sanMove = currentNode.sanMove;

    final externalShapes = {..._bestMoveShapes(boardPrefs.pieceSet.assets), ...extraShapes.unlock};
    final boardAnnotations = sanMove != null && annotation != null
        ? (sanMove.isCastles && altCastles.containsKey(sanMove.move.uci)
              ? {Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation}
              : {sanMove.move.to: annotation})
        : const <Square, Annotation>{};

    // The controller is normally created in initState. If it is somehow absent,
    // fall back to a non-interactive board rather than crashing.
    final ctrl = _controller;
    if (ctrl == null) {
      return StaticChessboard(
        size: widget.boardSize,
        orientation: analysisState.pov,
        fen: fen,
        lastMove: analysisState.lastMove,
        shapes: externalShapes,
        settings: StaticChessboardSettings.fromBoardSettings(
          boardPrefs
              .toBoardSettings(analysisState.variant)
              .copyWith(
                borderRadius: widget.boardRadius,
                boxShadow: widget.boardRadius != null ? boardShadows : const <BoxShadow>[],
              ),
        ),
      );
    }

    return BoardWidget(
      size: widget.boardSize,
      orientation: analysisState.pov,
      controller: ctrl,
      onMove: (move, {viaDragAndDrop}) => onUserMove(move),
      shapes: externalShapes,
      settings: boardPrefs
          .toBoardSettings(analysisState.variant)
          .copyWith(
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
