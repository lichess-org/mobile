import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/practice_comment.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_analysis_session.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

class const GameAnalysisBoard({
  required final AnalysisOptions options,
  required super.boardSize,
  super.boardRadius,
  final bool shouldReplaceChildOnUserMove = false,
}) extends AnalysisBoard {
  @override
  ConsumerState<GameAnalysisBoard> createState() => _GameAnalysisBoardState();
}

class _GameAnalysisBoardState()
    extends AnalysisBoardState<GameAnalysisBoard, AnalysisState, AnalysisPrefs> {
  @override
  AnalysisState? readCurrentState() => ref.read(analysisControllerProvider(widget.options)).value;

  @override
  void listenToStateChanges(void Function(AnalysisState? prev, AnalysisState? next) listener) =>
      ref.listenManual<AnalysisState?>(
        analysisControllerProvider(widget.options).select((v) => v.value),
        listener,
      );

  @override
  AnalysisState get analysisState =>
      ref.watch(analysisControllerProvider(widget.options)).requireValue;

  @override
  EngineEvaluationFilters get engineEvaluationFilters =>
      (context: analysisState.evaluationContext, path: analysisState.currentPath);

  @override
  String computeFen(AnalysisState state) => state.currentPosition.fen;

  @override
  AnalysisPrefs get analysisPrefs => ref.watch(analysisPreferencesProvider);

  @override
  bool get showAnnotations =>
      analysisState.isComputerAnalysisAllowed &&
      analysisState.isServerAnalysisEnabled &&
      analysisPrefs.showAnnotations;

  @override
  Annotation? get localMoveAnnotation {
    final prefs = ref.watch(analysisPreferencesProvider);
    if (!prefs.showLocalMoveVerdicts || !analysisState.isOnMainline) return null;

    final path = analysisState.currentPath;
    if (path.isEmpty) return null;
    final currentPly = path.size - 1;
    final evaluations = ref.watch(
      localGameAnalysisSessionProvider(
        localGameAnalysisSessionKey(widget.options.contextId, analysisState.root),
      ),
    );
    if (evaluations == null || currentPly + 1 >= evaluations.length) return null;

    final branch = analysisState.root.branchesOn(path).lastOrNull;
    if (branch == null) return null;
    final verdict = localMoveVerdictFor(
      before: evaluations[currentPly],
      after: evaluations[currentPly + 1],
      branch: branch,
    );
    return verdict == null ? null : makeAnnotation([_nagForVerdict(verdict)]);
  }

  @override
  void onUserMove(Move move) => ref
      .read(analysisControllerProvider(widget.options).notifier)
      .onUserMove(move, shouldReplace: widget.shouldReplaceChildOnUserMove);

  @override
  ISet<Shape> get extraShapes {
    final analysisState = ref.watch(analysisControllerProvider(widget.options)).requireValue;
    final pgnShapes = ISet(analysisState.pgnShapes.map((shape) => shape.chessground));
    return pgnShapes;
  }
}

int _nagForVerdict(MoveVerdict verdict) => switch (verdict) {
  .goodMove => 1,
  .notBest => 5,
  .inaccuracy => 6,
  .mistake => 2,
  .blunder => 4,
};

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
