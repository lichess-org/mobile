import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/view/analysis/abstract_analysis_board.dart';

class AnalysisBoard extends AbstractAnalysisBoard {
  const AnalysisBoard({
    required this.options,
    required super.boardSize,
    super.boardRadius,
    this.shouldReplaceChildOnUserMove = false,
  });

  final AnalysisOptions options;

  final bool shouldReplaceChildOnUserMove;

  @override
  ConsumerState<AnalysisBoard> createState() => AnalysisBoardState();
}

class AnalysisBoardState
    extends AbstractAnalysisBoardState<AnalysisBoard, AnalysisState, AnalysisPrefs> {
  @override
  AnalysisState get analysisState =>
      ref.watch(analysisControllerProvider(widget.options)).requireValue;

  @override
  AnalysisPrefs get analysisPrefs => ref.watch(analysisPreferencesProvider);

  @override
  void onUserMove(NormalMove move) => ref
      .read(analysisControllerProvider(widget.options).notifier)
      .onUserMove(move, shouldReplace: widget.shouldReplaceChildOnUserMove);

  @override
  void onPromotionSelection(Role? role) =>
      ref.read(analysisControllerProvider(widget.options).notifier).onPromotionSelection(role);
}
