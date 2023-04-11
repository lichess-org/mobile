import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/eval.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/common/tree.dart';

import 'engine.dart';
import 'work.dart';

part 'engine_evaluation_controller.freezed.dart';

// TODO: make this configurable
const kMaxDepth = 22;

class EngineEvaluationController {
  StockfishEngine? _engine;

  EngineEvaluationController();

  Stream<EvalResult>? start(
    String initialFen,
    UciPath path,
    Iterable<Step> steps,
  ) {
    _engine ??= StockfishEngine();

    final step = steps.last;

    if (step.eval != null && step.eval!.depth >= kMaxDepth) {
      return null;
    }

    return _engine!
        .start(
          Work(
            threads: 3,
            maxDepth: kMaxDepth,
            multiPv: 1,
            ply: step.ply,
            path: path,
            initialFen: initialFen,
            currentFen: step.fen,
            moves: IList(steps.map((e) => e.sanMove.move.uci)),
          ),
        )
        .throttle(
          const Duration(milliseconds: 200),
          trailing: true,
        );
  }

  void stop() {
    _engine?.stop();
  }

  void dispose() {
    _engine?.dispose();
  }
}

@freezed
class Step with _$Step {
  const Step._();

  const factory Step({
    required int ply,
    required String fen,
    required SanMove sanMove,
    ClientEval? eval,
  }) = _Step;

  factory Step.fromNode(ViewNode node) {
    return Step(
      ply: node.ply,
      fen: node.fen,
      sanMove: node.sanMove,
      eval: node.eval,
    );
  }
}
