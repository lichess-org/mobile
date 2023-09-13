import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

import 'engine.dart';
import 'work.dart';

part 'engine_evaluation.g.dart';
part 'engine_evaluation.freezed.dart';

const kMaxEngineDepth = 22;

@freezed
class EvaluationContext with _$EvaluationContext {
  const factory EvaluationContext({
    /// Unique ID to ensure engine is properly disposed when no more needed
    /// and a new engine instance is created per context (puzzle, game, etc).
    required ID contextId,
    required Variant variant,
    required String initialFen,
    required int multiPv,
    required int cores,
  }) = _EvaluationContext;
}

const engineSupportedVariants = {
  Variant.standard,
  Variant.chess960,
};

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
    Iterable<Step> steps,
    Position position, {
    required bool Function(Work work) shouldEmit,
  }) {
    if (!engineSupportedVariants.contains(context.variant)) {
      return null;
    }

    _engine ??= StockfishEngine();

    // requireValue is possible because appDependenciesProvider is loaded before
    // anything. See: lib/src/app.dart
    final maxMemory =
        ref.read(appDependenciesProvider).requireValue.engineMaxMemoryInMb;

    final work = Work(
      variant: context.variant,
      threads: context.cores,
      hashSize: maxMemory,
      maxDepth: kMaxEngineDepth,
      multiPv: context.multiPv,
      path: path,
      initialFen: context.initialFen,
      steps: IList(steps),
      currentPosition: position,
    );

    // cancel evaluation if we already have a cached eval at max depth
    final cachedEval = work.evalCache;
    if (cachedEval != null && cachedEval.depth >= kMaxEngineDepth) {
      state = null;
      return null;
    }

    final evalStream = _engine!.start(work).throttle(
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
