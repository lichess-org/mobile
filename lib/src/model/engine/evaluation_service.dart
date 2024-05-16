import 'dart:async';
import 'dart:io';
import 'dart:math';

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
final maxEngineCores = max(Platform.numberOfProcessors - 1, 1);
final defaultEngineCores =
    min((Platform.numberOfProcessors / 2).ceil(), maxEngineCores);

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
    cores: defaultEngineCores,
  );

  static const _defaultState =
      (engineName: 'Stockfish', state: EngineState.initial, eval: null);

  final ValueNotifier<EngineEvaluationState> _state =
      ValueNotifier(_defaultState);
  ValueListenable<EngineEvaluationState> get state => _state;

  /// Initialize the engine with the given context and options.
  ///
  /// An optional [engineFactory] can be provided, it defaults to Stockfish.
  ///
  /// If [options] is not provided, the default options are used.
  /// This method must be called before calling [start]. It is the caller's
  /// responsibility to close the engine.
  Future<void> initEngine(
    EvaluationContext context, {
    Engine Function() engineFactory = StockfishEngine.new,
    EvaluationOptions? options,
  }) async {
    _context = context;
    if (options != null) _options = options;
    await (_engine?.dispose() ?? Future<void>.value());
    _engine = engineFactory.call();
    _engine!.state.addListener(() {
      debugPrint('Engine state: ${_engine?.state.value}');
      if (_engine?.state.value == EngineState.initial ||
          _engine?.state.value == EngineState.disposed) {
        _state.value = _defaultState;
      }
      if (_engine?.state != null) {
        _state.value = (
          engineName: _engine!.name,
          state: _engine!.state.value,
          eval: _state.value.eval
        );
      }
    });
  }

  void setOptions(EvaluationOptions options) {
    stop();
    _options = options;
  }

  void disposeEngine() {
    _engine?.dispose().then((_) {
      _engine = null;
    });
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
      assert(false, 'Engine not initialized');
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
      _state.value = (
        engineName: _state.value.engineName,
        state: _state.value.state,
        eval: cachedEval,
      );
      return null;
    }

    final evalStream = engine.start(work).throttle(
          const Duration(milliseconds: 200),
          trailing: true,
        );

    evalStream.forEach((t) {
      final (work, eval) = t;
      if (shouldEmit(work)) {
        _state.value = (
          engineName: _state.value.engineName,
          state: _state.value.state,
          eval: eval,
        );
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

typedef EngineEvaluationState = ({
  String engineName,
  EngineState state,
  ClientEval? eval
});

/// A provider that holds the state of the engine and the current evaluation.
@riverpod
class EngineEvaluation extends _$EngineEvaluation {
  @override
  EngineEvaluationState build() {
    final listenable = ref.watch(evaluationServiceProvider).state;

    listenable.addListener(_listener);

    ref.onDispose(() {
      listenable.removeListener(_listener);
    });

    return listenable.value;
  }

  void _listener() {
    final newState = ref.read(evaluationServiceProvider).state.value;
    if (state != newState) {
      state = newState;
    }
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
