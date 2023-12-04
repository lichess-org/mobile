import 'dart:async';
import 'dart:io';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

import 'engine.dart';
import 'work.dart';

part 'evaluation_service.g.dart';
part 'evaluation_service.freezed.dart';

const kMaxEngineDepth = 22;
final maxEngineCores = Platform.numberOfProcessors - 1;

const engineSupportedVariants = {
  Variant.standard,
  Variant.chess960,
};

class EvaluationService {
  EvaluationService(this.ref, {required this.maxMemory});

  final EvaluationServiceRef ref;

  final int maxMemory;

  Engine? _engine;

  EvaluationContext? _context;
  EvaluationOptions _options = EvaluationOptions(
    multiPv: 1,
    cores: maxEngineCores,
  );

  /// Initialize the engine with the given context and options.
  ///
  /// An optional [engineFactory] can be provided, it defaults to Stockfish.
  ///
  /// If [options] is not provided, the default options are used.
  /// This method must be called before calling [start]. It is the caller's
  /// responsibility to close the engine.
  ///
  /// If the engine is already initialized, this method does nothing.
  void initEngine(
    EvaluationContext context, {
    Engine Function() engineFactory = StockfishEngine.new,
    EvaluationOptions? options,
  }) {
    if (_engine != null) return;
    _context = context;
    if (options != null) _options = options;
    _engine = engineFactory.call();
    _engine!.state.addListener(() {
      if (_engine!.state.value == EngineState.initial) {
        ref.read(engineEvaluationProvider.notifier).reset();
      }
      ref
          .read(engineEvaluationProvider.notifier)
          .setEngineState(_engine!.state.value);
    });
  }

  void setOptions(EvaluationOptions options) {
    stop();
    _options = options;
  }

  void disposeEngine() {
    _engine?.dispose();
    _engine = null;
    _context = null;
  }

  /// Start the engine evaluation with the given [path] and [steps].
  ///
  /// Returns a stream of [EvalResult]s. The stream is throttled to emit at most
  /// one value every 200 milliseconds.
  /// For each evaluation in the stream, if [shouldEmit] returns true, the eval
  /// is emitted by the [EngineEvaluation] provider.
  ///
  /// [initEngine] must be called before calling this method.
  Stream<EvalResult>? start(
    UciPath path,
    Iterable<Step> steps, {
    ClientEval? initialPositionEval,

    /// A function that returns true if the evaluation should be emitted by the
    /// [EngineEvaluation] provider.
    required bool Function(Work work) shouldEmit,
  }) {
    final context = _context;
    final engine = _engine;
    if (context == null || engine == null) {
      assert(false, 'EvaluationService not initialized');
      return null;
    }

    if (!engineSupportedVariants.contains(context.variant)) {
      return null;
    }

    final work = Work(
      variant: context.variant,
      threads: _options.cores,
      hashSize: maxMemory,
      maxDepth: kMaxEngineDepth,
      multiPv: _options.multiPv,
      path: path,
      initialPosition: context.initialPosition,
      steps: IList(steps),
    );

    // cancel evaluation if we already have a cached eval at max depth
    final cachedEval =
        work.steps.isEmpty ? initialPositionEval : work.evalCache;
    if (cachedEval != null && cachedEval.depth >= kMaxEngineDepth) {
      ref.read(engineEvaluationProvider.notifier).setEval(cachedEval);
      return null;
    }

    final evalStream = engine.start(work).throttle(
          const Duration(milliseconds: 200),
          trailing: true,
        );

    evalStream.forEach((t) {
      final (work, eval) = t;
      if (shouldEmit(work)) {
        ref.read(engineEvaluationProvider.notifier).setEval(eval);
      }
    });

    return evalStream;
  }

  void stop() {
    _engine?.stop();
  }
}

@Riverpod(keepAlive: true)
EvaluationService evaluationService(EvaluationServiceRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  final maxMemory =
      ref.read(appDependenciesProvider).requireValue.engineMaxMemoryInMb;

  final service = EvaluationService(ref, maxMemory: maxMemory);
  ref.onDispose(() {
    service.disposeEngine();
  });
  return service;
}

typedef EngineEvaluationState = ({EngineState state, ClientEval? eval});

/// A provider that holds the state of the engine and the current evaluation.
@riverpod
class EngineEvaluation extends _$EngineEvaluation {
  @override
  EngineEvaluationState build() {
    return (state: EngineState.initial, eval: null);
  }

  void setEngineState(EngineState engineState) {
    state = (state: engineState, eval: state.eval);
  }

  void setEval(ClientEval eval) {
    state = (state: state.state, eval: eval);
  }

  void reset() {
    state = (state: EngineState.initial, eval: null);
  }
}

@freezed
class EvaluationContext with _$EvaluationContext {
  const factory EvaluationContext({
    required Variant variant,
    required Position initialPosition,
  }) = _EvaluationContext;
}

@freezed
class EvaluationOptions with _$EvaluationOptions {
  const factory EvaluationOptions({
    required int multiPv,
    required int cores,
  }) = _EvaluationOptions;
}
