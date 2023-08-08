import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/tree.dart';
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

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 100));

  @override
  AnalysisCtrlState build(
    IList<GameStep> steps,
    Side orientation,
    GameId id,
  ) {
    _root = Root(
      ply: 0,
      fen: steps[0].position.fen,
      position: steps[0].position,
    );

    RootOrNode current = _root;
    steps.skip(1).forEach((step) {
      final nextNode = Node(
        // skipping root node makes sure that sanMove is available
        id: UciCharPair.fromMove(step.sanMove!.move),
        ply: step.ply,
        sanMove: step.sanMove!,
        fen: step.position.fen,
        position: step.position,
      );
      current.addChild(nextNode);
      current = nextNode;
    });

    Timer(const Duration(seconds: 1), () => _startEngineEval());
    return AnalysisCtrlState(
      gameId: id,
      initialFen: _root.fen,
      initialPath: UciPath.empty,
      currentPath: _root.mainlinePath,
      nodeList: IList(_root.mainline),
      root: IList(_root.children.map((e) => ViewNode.fromNode(e))),
      pov: orientation,
      isEngineEnabled: true,
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

  void onUserMove(Move move) {
    final (newPath, _) = _root.addMoveAt(state.currentPath, move);
    if (newPath != null) {
      _setPath(newPath, moveAdded: true);
    }
  }

  void userNext() {
    if (state.node.children.isEmpty) return;
    _setPath(
      state.currentPath + state.node.children.first.id,
      replaying: true,
    );
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
    final newNodeList = IList(_root.nodesOn(path));
    if (newNodeList.isEmpty) return;
    final sanMove = newNodeList.last.sanMove;
    final isCheck = sanMove.san.contains('+');
    if (!replaying) {
      if (isCheck) {
        ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
      } else {
        ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
      }
    } else {
      // when replaying moves fast we don't want haptic feedback
      if (isCheck) {
        ref.read(soundServiceProvider).play(Sound.capture);
      } else {
        ref.read(soundServiceProvider).play(Sound.move);
      }
    }
    state = state.copyWith(
      currentPath: path,
      nodeList: newNodeList,
      lastMove: sanMove.move,
      root: moveAdded
          ? IList(_root.children.map((e) => ViewNode.fromNode(e)))
          : state.root,
    );
    if (pathChange) {
      _startEngineEval();
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
            state.nodeList.map(Step.fromNode),
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
    required IList<ViewNode> root,
    required IList<ViewNode> nodeList,
    required String initialFen,
    required UciPath initialPath,
    required UciPath currentPath,
    required bool isEngineEnabled,
    required GameId gameId,
    Move? lastMove,
    required Side pov,
  }) = _AnalysisCtrlState;

  EvaluationContext get evaluationContext => EvaluationContext(
        variant: Variant.standard,
        initialFen: initialFen,
        contextId: gameId,
      );

  IMap<String, ISet<String>> get validMoves =>
      algebraicLegalMoves(nodeList.last.position);

  ViewNode get node => nodeList.last;
  Position get position => nodeList.last.position;
  String get fen => nodeList.last.position.fen;
  bool get canGoNext => node.children.isNotEmpty;
  bool get canGoBack => currentPath.size > initialPath.size;
}
