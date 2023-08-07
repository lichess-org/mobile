import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/tree.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'game.dart';

part 'analysis_ctrl.g.dart';
part 'analysis_ctrl.freezed.dart';

@riverpod
class AnalysisCtrl extends _$AnalysisCtrl {
  late Root _root;

  @override
  AnalysisCtrlState build(
    IList<GameStep> steps,
    Side orientation,
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

    return AnalysisCtrlState(
      initialPath: UciPath.empty,
      currentPath: _root.mainlinePath,
      nodeList: IList(_root.nodesOn(_root.mainlinePath)),
      pov: orientation,
    );
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

  void _setPath(UciPath path, {bool replaying = false}) {
    final newNodeList = IList(_root.nodesOn(path));
    if (newNodeList.isEmpty) return;
    final sanMove = newNodeList.last.sanMove;
    if (!replaying) {
      final isForward = path.size > state.currentPath.size;
      if (isForward) {
        final isCheck = sanMove.san.contains('+');
        if (sanMove.san.contains('x')) {
          ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
        } else {
          ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
        }
      }
    } else {
      // when replaying moves fast we don't want haptic feedback
      final soundService = ref.read(soundServiceProvider);
      if (sanMove.san.contains('x')) {
        soundService.play(Sound.capture);
      } else {
        soundService.play(Sound.move);
      }
    }
    state = state.copyWith(
      currentPath: path,
      nodeList: newNodeList,
      lastMove: sanMove.move,
    );
  }
}

@freezed
class AnalysisCtrlState with _$AnalysisCtrlState {
  const AnalysisCtrlState._();

  const factory AnalysisCtrlState({
    required IList<ViewNode> nodeList,
    required UciPath initialPath,
    required UciPath currentPath,
    Move? lastMove,
    required Side pov,
  }) = _AnalysisCtrlState;

  IMap<String, ISet<String>> get validMoves =>
      algebraicLegalMoves(nodeList.last.position);

  ViewNode get node => nodeList.last;
  Position get position => nodeList.last.position;
  String get fen => nodeList.last.position.fen;
  bool get canGoNext => node.children.isNotEmpty;
  bool get canGoBack => currentPath.size > initialPath.size;
}
