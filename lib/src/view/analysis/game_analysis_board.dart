import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/custom_pgn_analysis.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';

class GameAnalysisBoard extends AnalysisBoard {
  const GameAnalysisBoard({
    required this.options,
    required super.boardSize,
    super.boardRadius,
    this.shouldReplaceChildOnUserMove = false,
  });

  final AnalysisOptions options;

  final bool shouldReplaceChildOnUserMove;

  @override
  ConsumerState<GameAnalysisBoard> createState() => _GameAnalysisBoardState();
}

class _GameAnalysisBoardState
    extends AnalysisBoardState<GameAnalysisBoard, AnalysisState, AnalysisPrefs> {
  @override
  AnalysisState get analysisState =>
      ref.watch(analysisControllerProvider(widget.options)).requireValue;

  @override
  AnalysisPrefs get analysisPrefs => ref.watch(analysisPreferencesProvider);

  @override
  bool get showAnnotations =>
      analysisState.isComputerAnalysisAllowed &&
      analysisState.isServerAnalysisEnabled &&
      analysisPrefs.showAnnotations;

  @override
  ISet<Shape> get extraShapes {
    final customPgnState = ref.watch(customPgnAnalysisProvider);

    // If no PGN files are loaded, return empty set
    if (customPgnState.parsedGames.isEmpty) {
      return ISet();
    }

    // Build move history from current position
    final moves = <Move>[];
    if (analysisState.currentPath.size > 0) {
      for (final node in analysisState.root.mainline) {
        moves.add(node.sanMove.move);
        if (node.position.fen == analysisState.currentNode.position.fen) {
          break;
        }
      }
    }

    // Get shapes from custom PGN analysis (purple/magenta arrows to distinguish from engine)
    return ref
        .read(customPgnAnalysisProvider.notifier)
        .getMoveSuggestionsAsShapes(
          analysisState.currentPosition,
          moves,
          const Color(0x99CC00FF), // Purple with transparency
        );
  }

  @override
  void onUserMove(NormalMove move) => ref
      .read(analysisControllerProvider(widget.options).notifier)
      .onUserMove(move, shouldReplace: widget.shouldReplaceChildOnUserMove);

  @override
  void onPromotionSelection(Role? role) =>
      ref.read(analysisControllerProvider(widget.options).notifier).onPromotionSelection(role);
}
