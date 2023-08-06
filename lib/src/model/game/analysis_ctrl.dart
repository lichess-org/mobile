import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/tree.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'game.dart';

part 'analysis_ctrl.g.dart';
part 'analysis_ctrl.freezed.dart';

@riverpod
class AnalysisCtrl extends _$AnalysisCtrl {
  late Node _gameTree;

  @override
  AnalysisCtrlState build(
    IList<GameStep> steps,
    Side orientation,
  ) {
    final root = Root(
      ply: steps[0].ply,
      fen: steps[0].position.fen,
      position: steps[0].position,
    );

    RootOrNode current = root;
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

    _gameTree = root.nodeAt(root.mainlinePath.penultimate) as Node;
    return AnalysisCtrlState(
      currentNode: ViewNode.fromNode(_gameTree),
      pov: orientation,
    );
  }
}

@freezed
class AnalysisCtrlState with _$AnalysisCtrlState {
  const AnalysisCtrlState._();

  const factory AnalysisCtrlState({
    required ViewNode currentNode,
    Move? lastMove,
    required Side pov,
  }) = _AnalysisCtrlState;

  IMap<String, ISet<String>> get validMoves =>
      algebraicLegalMoves(currentNode.position);
}
