import 'dart:math' as math;
import 'dart:io';
import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/common/tree.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

import 'engine.dart';
import 'work.dart';

part 'engine_evaluation.g.dart';
part 'engine_evaluation.freezed.dart';

// TODO: make this configurable
const kMaxDepth = 22;

final maxCores = math.max(1, Platform.numberOfProcessors - 1);

@freezed
class EvaluationContext with _$EvaluationContext {
  const factory EvaluationContext({
    required String initialFen,

    /// Unique ID to ensure engine is properly disposed when no more needed
    /// and a new engine instance is created per context (puzzle, game, etc).
    required ID contextId,
  }) = _EvaluationContext;
}

@riverpod
class EngineEvaluation extends _$EngineEvaluation {
  StockfishEngine? _engine;

  @override
  ClientEval? build(EvaluationContext context) {
    ref.onDispose(() {
      _engine?.dispose();
    });

    return null;
  }

  Stream<EvalResult>? start(
    UciPath path,
    Iterable<Step> steps, {
    required bool Function(Work work) shouldEmit,
  }) {
    _engine ??= StockfishEngine();

    final step = steps.last;

    if (step.eval != null && step.eval!.depth >= kMaxDepth) {
      state = null;
      return null;
    }

    final evalStream = _engine!
        .start(
          Work(
            threads: maxCores,
            maxDepth: kMaxDepth,
            multiPv: 1,
            ply: step.ply,
            path: path,
            initialFen: context.initialFen,
            currentFen: step.fen,
            moves: IList(steps.map((e) => e.sanMove.move.uci)),
          ),
        )
        .throttle(
          const Duration(milliseconds: 200),
          trailing: true,
        );

    evalStream.forEach((t) {
      if (shouldEmit(t.item1)) {
        state = t.item2;
      }
    });

    return evalStream;
  }

  void stop() {
    state = null;
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
