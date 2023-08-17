import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'game.dart';

part 'analysis_ctrl.g.dart';
part 'analysis_ctrl.freezed.dart';

@riverpod
class AnalysisCtrl extends _$AnalysisCtrl {
  late Root _root;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 150));

  @override
  AnalysisCtrlState build(
    IList<GameStep> steps,
    Side orientation,
    GameId id,
  ) {
    ref.onDispose(() {
      _engineEvalDebounce.dispose();
    });
    _root = Root(
      ply: 0,
      fen: steps[0].position.fen,
      position: steps[0].position,
    );

    Node current = _root;
    steps.skip(1).forEach((step) {
      final nextNode = Branch(
        ply: step.ply,
        sanMove: step.sanMove!,
        fen: step.position.fen,
        position: step.position,
      );
      current.addChild(nextNode);
      current = nextNode;
    });

    final currentPath = _root.mainlinePath;
    final evalContext = EvaluationContext(
      variant: Variant.standard,
      initialFen: _root.fen,
      contextId: id,
      cores: maxCores,
    );

    _engineEvalDebounce(
      () => ref
          .read(
            engineEvaluationProvider(
              evalContext,
            ).notifier,
          )
          .start(
            currentPath,
            _root.mainline.map(Step.fromNode),
            current.position,
            shouldEmit: (work) => work.path == currentPath,
          )
          ?.forEach(
            (t) => _root.updateAt(t.$1.path, (node) => node.eval = t.$2),
          ),
    );
    return AnalysisCtrlState(
      gameId: id,
      initialFen: _root.fen,
      initialPath: UciPath.empty,
      currentPath: currentPath,
      root: _root.view,
      currentNode: current.view,
      pov: orientation,
      numCevalLines: kDefaultLines,
      numCores: maxCores,
      isEngineEnabled: true,
      showBestMoveArrow: true,
      evaluationContext: evalContext,
    );
  }

  void toggleLocalEvaluation() {
    state = state.copyWith(isEngineEnabled: !state.isEngineEnabled);
    if (state.isEngineEnabled) {
      _startEngineEval();
    } else {
      ref
          .read(engineEvaluationProvider(state.evaluationContext).notifier)
          .stop();
    }
  }

  void toggleBestMoveArrow() {
    state = state.copyWith(showBestMoveArrow: !state.showBestMoveArrow);
  }

  void setCevalLines(int lines) {
    if (lines > 3) return;
    ref
        .read(engineEvaluationProvider(state.evaluationContext).notifier)
        .multiPv = lines;
    _startEngineEval();
    state = state.copyWith(numCevalLines: lines);
  }

  void setCores(int num) {
    ref.read(engineEvaluationProvider(state.evaluationContext).notifier).cores =
        num;
    _startEngineEval();
    state = state.copyWith(
      numCores: num,
    );
  }

  void onUserMove(Move move) {
    // TODO: sometimes incorrent move might be sent from the engine line if UI dones't update quickly
    final (newPath, _) = _root.addMoveAt(state.currentPath, move);
    if (newPath != null) {
      _setPath(newPath, moveAdded: true);
    }
  }

  void userNext() {
    if (state.currentNode.children.isEmpty) return;
    _setPath(
      state.currentPath + state.currentNode.children.first.id,
      replaying: true,
    );
  }

  void toggleBoard() {
    state = state.copyWith(pov: state.pov.opposite);
  }

  void userPrevious() {
    _setPath(state.currentPath.penultimate, replaying: true);
  }

  void userJump(UciPath path) {
    _setPath(path);
  }

  void _setPath(
    UciPath path, {
    bool replaying = false,
    bool moveAdded = false,
  }) {
    final pathChange = state.currentPath != path;
    final rootOrBranch = _root.nodeAt(path);

    if (rootOrBranch.runtimeType == Branch) {
      final currentNode = rootOrBranch as Branch;
      if (!replaying) {
        final isForward = path.size > state.currentPath.size;
        if (isForward) {
          final isCheck = currentNode.sanMove.san.contains('+');
          if (currentNode.sanMove.san.contains('x')) {
            ref
                .read(moveFeedbackServiceProvider)
                .captureFeedback(check: isCheck);
          } else {
            ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
          }
        }
      } else {
        // when replaying moves fast we don't want haptic feedback
        final soundService = ref.read(soundServiceProvider);
        if (currentNode.sanMove.san.contains('x')) {
          soundService.play(Sound.capture);
        } else {
          soundService.play(Sound.move);
        }
      }
      state = state.copyWith(
        currentPath: path,
        currentNode: currentNode.view,
        lastMove: currentNode.sanMove.move,
        root: moveAdded ? _root.view : state.root,
      );
      if (pathChange) {
        _startEngineEval();
      }
    } else {
      state = state.copyWith(
        currentPath: path,
        currentNode: state.root,
        lastMove: null,
      );
    }
  }

  void _startEngineEval() {
    if (!state.isEngineEnabled) return;
    _engineEvalDebounce(
      () => ref
          .read(
            engineEvaluationProvider(state.evaluationContext).notifier,
          )
          .start(
            state.currentPath,
            _root.nodesOn(state.currentPath).map(Step.fromNode),
            state.currentNode.position,
            shouldEmit: (work) => work.path == state.currentPath,
          )
          ?.forEach(
            (t) => _root.updateAt(t.$1.path, (node) => node.eval = t.$2),
          ),
    );
  }
}

@freezed
class AnalysisCtrlState with _$AnalysisCtrlState {
  const AnalysisCtrlState._();

  const factory AnalysisCtrlState({
    required ViewRoot root,
    required ViewNode currentNode,
    required String initialFen,
    required UciPath initialPath,
    required UciPath currentPath,
    required GameId gameId,
    required Side pov,
    required bool isEngineEnabled,
    required bool showBestMoveArrow,
    required int numCevalLines,
    required int numCores,
    required EvaluationContext evaluationContext,
    Move? lastMove,
  }) = _AnalysisCtrlState;

  IMap<String, ISet<String>> get validMoves =>
      algebraicLegalMoves(currentNode.position);

  Position get position => currentNode.position;
  String get fen => currentNode.position.fen;
  bool get canGoNext => currentNode.children.isNotEmpty;
  bool get canGoBack => currentPath.size > initialPath.size;
}
