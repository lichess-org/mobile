import 'package:stream_transform/stream_transform.dart';
import 'package:tuple/tuple.dart';
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

  Future<Stream<Tuple2<Work, ClientEval>>?> start(
    UciPath path,
    Iterable<Step> steps,
  ) async {
    final step = steps.last;

    if (step.eval != null && step.eval!.depth >= kMaxDepth) {
      state = null;
      return Future.value();
    }

    final evalStream = await _engine.start(
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
    );

    final throttledEvals = evalStream.throttle(
      const Duration(milliseconds: 200),
      trailing: true,
    );

    throttledEvals.forEach((t) {
      state = t.item2;
      print('eval: ${state?.depth} ${state?.cp}');
    });

    return throttledEvals;
  }

  void stop() {
    _engine.stop();
  }
}
