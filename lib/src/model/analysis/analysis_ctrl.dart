import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/settings/analysis_preferences.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

part 'analysis_ctrl.g.dart';
part 'analysis_ctrl.freezed.dart';

@riverpod
class AnalysisCtrl extends _$AnalysisCtrl {
  late Root _root;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 150));

  @override
  AnalysisCtrlState build(
    Variant variant,
    IList<GameStep> steps,
    Side orientation,
    ID id,
  ) {
    ref.onDispose(() {
      _engineEvalDebounce.dispose();
    });
    _root = Root(
      ply: steps[0].ply,
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

    // don't use ref.watch here: we don't want to clear all state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);

    final evalContext = EvaluationContext(
      variant: variant,
      initialFen: _root.fen,
      contextId: id,
      multiPv: prefs.numEvalLines,
      cores: prefs.numEngineCores,
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
      id: id,
      initialFen: _root.fen,
      initialPath: UciPath.empty,
      currentPath: currentPath,
      root: _root.view,
      currentNode: current.view,
      pov: orientation,
      evaluationContext: evalContext,
    );
  }

  void onUserMove(Move move) {
    if (!state.position.isLegal(move)) return;
    final (newPath, newNode) = _root.addMoveAt(state.currentPath, move);
    if (newPath != null) {
      _setPath(newPath, newNode: newNode);
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

  void setNumEvalLines(int numEvalLines) {
    ref
        .read(analysisPreferencesProvider.notifier)
        .setNumEvalLines(numEvalLines);

    _stopEngineEval();

    _root.updateAll((node) => node.eval = null);

    state = state.copyWith(
      evaluationContext: state.evaluationContext.copyWith(
        multiPv: numEvalLines,
      ),
      currentNode: _root.nodeAt(state.currentPath).view,
    );

    _startEngineEval();
  }

  void setEngineCores(int numEngineCores) {
    ref
        .read(analysisPreferencesProvider.notifier)
        .setEngineCores(numEngineCores);

    _stopEngineEval();

    state = state.copyWith(
      evaluationContext: state.evaluationContext.copyWith(
        cores: numEngineCores,
      ),
    );

    _startEngineEval();
  }

  void _setPath(
    UciPath path, {
    Node? newNode,
    bool replaying = false,
  }) {
    final pathChange = state.currentPath != path;
    final currentNode = newNode ?? _root.nodeAt(path);

    if (currentNode is Branch) {
      if (!replaying) {
        final isForward = path.size > state.currentPath.size;
        if (isForward) {
          final isCheck = currentNode.sanMove.isCheck;
          if (currentNode.sanMove.isCapture) {
            ref
                .read(moveFeedbackServiceProvider)
                .captureFeedback(check: isCheck);
          } else {
            ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
          }
        }
      } else {
        final soundService = ref.read(soundServiceProvider);
        if (currentNode.sanMove.isCapture) {
          soundService.play(Sound.capture);
        } else {
          soundService.play(Sound.move);
        }
      }
      state = state.copyWith(
        currentPath: path,
        currentNode: currentNode.view,
        lastMove: currentNode.sanMove.move,
        root: newNode != null ? _root.view : state.root,
      );
    } else {
      state = state.copyWith(
        currentPath: path,
        currentNode: state.root,
        lastMove: null,
      );
    }

    if (pathChange) {
      _startEngineEval();
    }
  }

  void _startEngineEval() {
    if (!state.isEngineAvailable) return;
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

  void _stopEngineEval() {
    ref.read(engineEvaluationProvider(state.evaluationContext).notifier).stop();
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
    required ID id,
    required Side pov,
    required EvaluationContext evaluationContext,
    Move? lastMove,
  }) = _AnalysisCtrlState;

  IMap<String, ISet<String>> get validMoves =>
      algebraicLegalMoves(currentNode.position);

  bool get isEngineAvailable => engineSupportedVariants.contains(
        evaluationContext.variant,
      );

  Position get position => currentNode.position;
  String get fen => currentNode.position.fen;
  bool get canGoNext => currentNode.children.isNotEmpty;
  bool get canGoBack => currentPath.size > initialPath.size;
}
