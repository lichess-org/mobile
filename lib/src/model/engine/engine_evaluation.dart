import 'dart:math' as math;
import 'dart:io';
import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
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
    required Variant variant,
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
            variant: context.variant,
            threads: maxCores,
            maxDepth: kMaxDepth,
            multiPv: 1,
            ply: step.ply,
            path: path,
            initialFen: context.initialFen,
            currentFen: step.fen,
            steps: IList(steps),
          ),
        )
        .throttle(
          const Duration(milliseconds: 200),
          trailing: true,
        );

    evalStream.forEach((t) {
      final (work, eval) = t;
      if (shouldEmit(work)) {
        state = eval;
      }
    });

    return evalStream;
  }

  void stop() {
    state = null;
    _engine?.stop();
  }
}
