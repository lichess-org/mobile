import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/eval.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/common/tree.dart';

import 'engine.dart';
import 'work.dart';

part 'engine_evaluation.g.dart';
part 'engine_evaluation.freezed.dart';

// TODO: make this configurable
const kMaxDepth = 22;

@riverpod
class EngineEvaluation extends _$EngineEvaluation {
  StockfishEngine? _engine;

  @override
  ClientEval? build(String id) {
    ref.onDispose(() {
      _engine?.dispose();
    });

    return null;
  }

  Stream<EvalResult>? start(
    String initialFen,
    UciPath path,
    Iterable<Step> steps,
  ) {
    _engine ??= StockfishEngine();

    final step = steps.last;

    if (step.eval != null && step.eval!.depth >= kMaxDepth) {
      state = null;
      return null;
    }

    final evalStream = _engine!
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

    evalStream.forEach((t) {
      state = t.item2;
    });

    return evalStream;
  }

  void stop() {
    _engine?.stop();
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
