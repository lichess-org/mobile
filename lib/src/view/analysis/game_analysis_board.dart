import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
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

  @override
  ISet<Shape> get extraShapes {
    final analysisState = ref.watch(analysisControllerProvider(widget.options)).requireValue;
    final pgnShapes = ISet(analysisState.pgnShapes.map((shape) => shape.chessground));
    return pgnShapes;
  }
}

extension on PgnCommentShape {
  Shape get chessground {
    final shapeColor = switch (color) {
      CommentShapeColor.green => ShapeColor.green,
      CommentShapeColor.red => ShapeColor.red,
      CommentShapeColor.blue => ShapeColor.blue,
      CommentShapeColor.yellow => ShapeColor.yellow,
    };
    return from != to
        ? Arrow(color: shapeColor.color, orig: from, dest: to)
        : Circle(color: shapeColor.color, orig: from);
  }
}
