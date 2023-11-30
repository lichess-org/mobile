import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

import 'engine.dart';
import 'work.dart';

part 'engine_evaluation.freezed.dart';
part 'engine_evaluation.g.dart';

const kMaxEngineDepth = 22;

@freezed
class EvaluationContext with _$EvaluationContext {
  const factory EvaluationContext({
    /// Unique ID to ensure engine is properly disposed when no more needed
    /// and a new engine instance is created per context (puzzle, game, etc).
    required ID contextId,
    required Variant variant,
    required Position initialPosition,
    required int multiPv,
    required int cores,
  }) = _EvaluationContext;
}

const engineSupportedVariants = {
  Variant.standard,
  Variant.chess960,
};

typedef EngineEvaluationState = ({EngineState state, ClientEval? eval});

/// A provider holds the state of the engine and the current evaluation.
///
/// TODO: refactor this to decouple engine from the provider.
/// Right now this is working but it's not ideal.
@riverpod
class EngineEvaluation extends _$EngineEvaluation {
  StockfishEngine? _engine;
  StreamSubscription<EngineState>? _engineStateSub;

  @override
  EngineEvaluationState build(EvaluationContext context) {
    ref.onDispose(() {
      _engineStateSub?.cancel();
      _engine?.dispose();
    });

    return (state: EngineState.initial, eval: null);
  }

  Stream<EvalResult>? start(
    UciPath path,
    Iterable<Step> steps, {
    ClientEval? initialPositionEval,
    required bool Function(Work work) shouldEmit,
  }) {
    if (!engineSupportedVariants.contains(context.variant)) {
      return null;
    }

    _engine ??= StockfishEngine();
    _engineStateSub ??= _engine!.stateStream.listen((engineState) {
      state = (state: engineState, eval: state.eval);
    });

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
      initialPosition: context.initialPosition,
      steps: IList(steps),
    );

    // cancel evaluation if we already have a cached eval at max depth
    final cachedEval =
        work.steps.isEmpty ? initialPositionEval : work.evalCache;
    if (cachedEval != null && cachedEval.depth >= kMaxEngineDepth) {
      state = (state: state.state, eval: cachedEval);
      return null;
    }

    final evalStream = _engine!.start(work).throttle(
          const Duration(milliseconds: 200),
          trailing: true,
        );

    evalStream.forEach((t) {
      final (work, eval) = t;
      if (shouldEmit(work)) {
        state = (state: state.state, eval: eval);
      }
    });

    return evalStream;
  }

  void stop() {
    _engine?.stop();
  }
}
