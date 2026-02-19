import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
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
  EngineEvaluationFilters get engineEvaluationFilters =>
      (id: analysisState.evaluationContext.id, path: analysisState.currentPath);

  @override
  AnalysisPrefs get analysisPrefs => ref.watch(analysisPreferencesProvider);

  @override
  bool get showAnnotations =>
      analysisState.isComputerAnalysisAllowed &&
      analysisState.isServerAnalysisEnabled &&
      analysisPrefs.showAnnotations;

  @override
  void onUserMove(Move move) => ref
      .read(analysisControllerProvider(widget.options).notifier)
      .onUserMove(move, shouldReplace: widget.shouldReplaceChildOnUserMove);

  @override
  void onPromotionSelection(Role? role) =>
      ref.read(analysisControllerProvider(widget.options).notifier).onPromotionSelection(role);
}
