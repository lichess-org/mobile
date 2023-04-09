import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/eval.dart';
import 'package:lichess_mobile/src/common/uci.dart';

import 'engine.dart';
import 'work.dart';

part 'engine_evaluation.g.dart';

// TODO: make this configurable
const kMaxDepth = 22;

@riverpod
class EngineEvaluation extends _$EngineEvaluation {
  late StockfishEngine _engine;

  @override
  ClientEval? build(String initialFen) {
    _engine = StockfishEngine();

    ref.onDispose(() {
      _engine.dispose();
    });

    return null;
  }

  Future<void> start(
    UciPath path,
    Iterable<Step> steps, {
    void Function(Work work, ClientEval eval)? onEmit,
  }) {
    final step = steps.last;

    if (step.eval != null && step.eval!.depth >= kMaxDepth) {
      return Future.value();
    }

    return _engine.start(
      Work(
        threads: 3,
        maxDepth: kMaxDepth,
        multiPv: 1,
        ply: step.ply,
        path: path,
        initialFen: initialFen,
        currentFen: step.fen,
        moves: IList(steps.map((e) => e.sanMove.move.uci)),
        emit: (work, eval) {
          onEmit?.call(work, eval);
          state = eval;
        },
      ),
    );
  }

  void stop() {
    _engine.stop();
  }
}
