import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dartchess/dartchess.dart' hide File;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:multistockfish/multistockfish.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'evaluation_service.freezed.dart';
part 'evaluation_service.g.dart';

const kEngineEvalEmissionThrottleDelay = Duration(milliseconds: 200);

final maxEngineCores = max(Platform.numberOfProcessors - 1, 1);
final defaultEngineCores = min((Platform.numberOfProcessors / 2).ceil(), maxEngineCores);

const engineSupportedVariants = {Variant.standard, Variant.chess960, Variant.fromPosition};

/// A function that returns true if the evaluation should be emitted by the [EngineEvaluation]
/// provider.
typedef ShouldEmitEvalFilter = bool Function(Work work);

@Riverpod(keepAlive: true)
EvaluationService evaluationService(Ref ref) {
  final maxMemory = ref.read(preloadedDataProvider).requireValue.engineMaxMemoryInMb;
  final service = EvaluationService(maxMemory: maxMemory);

  ref.onDispose(() {
    service._dispose();
  });

  return service;
}

/// A service to evaluate chess positions using an engine.
class EvaluationService {
  EvaluationService({required this.maxMemory});

  final int maxMemory;

  Engine? _engine;

  EvaluationContext? _context;

  final StreamController<EvalResult> _evalStreamController =
      StreamController<EvalResult>.broadcast();

  Stream<EvalResult> get evalStream => _evalStreamController.stream;

  EvaluationOptions options = EvaluationOptions(
    multiPv: 1,
    cores: defaultEngineCores,
    searchTime: const Duration(seconds: 10),
  );

  static const _defaultState = (
    engineName: 'Stockfish',
    state: EngineState.initial,
    eval: null,
    currentWork: null,
  );

  final ValueNotifier<EngineEvaluationState> _state = ValueNotifier(_defaultState);
  ValueListenable<EngineEvaluationState> get state => _state;

  Engine _engineFactory() {
    // TODO: choose the flavor based on variant
    return StockfishEngine(StockfishFlavor.chess);
  }

  /// Initialize the engine with the given context and options.
  ///
  /// If the engine is already initialized, it is disposed first.
  ///
  /// If [options] is not provided, the default options are used.
  /// This method must be called before calling [start]. It is the caller's
  /// responsibility to close the engine.
  Future<void> _initEngine(EvaluationContext context, {EvaluationOptions? initOptions}) async {
    await disposeEngine();
    _context = context;
    if (initOptions != null) options = initOptions;
    _engine = _engineFactory();
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
          eval: _state.value.eval,
          currentWork: _state.value.currentWork,
        );
      }
    });
  }

  /// Ensure the engine is initialized with the given context and options.
  Future<void> ensureEngineInitialized(
    EvaluationContext context, {
    EvaluationOptions? initOptions,
  }) async {
    if (_engine == null ||
        _engine?.isDisposed == true ||
        _context != context ||
        options != initOptions) {
      await _initEngine(context, initOptions: initOptions);
    }
  }

  /// Dispose the engine.
  ///
  /// Returns a future that completes once the engine is disposed.
  /// It is safe to call this method multiple times.
  Future<void> disposeEngine() {
    return (_engine?.dispose() ?? Future.value()).then((_) {
      _engine = null;
      _state.value = _defaultState;
    });
  }

  /// Dispose the service.
  void _dispose() {
    disposeEngine();
    _evalStreamController.close();
    _state.dispose();
  }

  /// Start the engine evaluation with the given [path] and [steps].
  ///
  /// Returns a stream of [EvalResult]s. The stream is throttled to emit at most
  /// one value every 200 milliseconds.
  /// For each evaluation in the stream, if [shouldEmit] returns true, the eval
  /// is emitted by the [EngineEvaluation] provider.
  ///
  /// [initEngine] must be called before calling this method.
  void start(
    UciPath path,
    Iterable<Step> steps, {
    ClientEval? initialPositionEval,
    required ShouldEmitEvalFilter shouldEmit,
    bool goDeeper = false,
  }) {
    final context = _context;
    final engine = _engine;
    if (context == null || engine == null) {
      assert(false, 'Engine not initialized');
      return;
    }

    if (!engineSupportedVariants.contains(context.variant)) {
      return;
    }

    // reset eval
    _state.value = (
      engineName: _state.value.engineName,
      state: _state.value.state,
      eval: null,
      currentWork: null,
    );

    final work = Work(
      variant: context.variant,
      threads: options.cores,
      hashSize: maxMemory,
      searchTime: goDeeper ? kMaxEngineSearchTime : options.searchTime,
      isDeeper: goDeeper,
      multiPv: options.multiPv,
      path: path,
      initialPosition: context.initialPosition,
      steps: IList(steps),
    );

    switch (work.evalCache) {
      // if the search time is greater than the current search time, don't evaluate again
      case final LocalEval localEval when localEval.searchTime >= work.searchTime:
      case CloudEval _:
        return;
      case _:
        break;
    }

    engine.start(work).throttle(kEngineEvalEmissionThrottleDelay, trailing: true).forEach((t) {
      _evalStreamController.add(t);
      final (work, eval) = t;
      if (shouldEmit(work)) {
        _state.value = (
          engineName: _state.value.engineName,
          state: _state.value.state,
          eval: eval,
          currentWork: work,
        );
      }
    });
  }

  void stop() {
    _engine?.stop();
  }
}

typedef EngineEvaluationState =
    ({String engineName, EngineState state, Work? currentWork, LocalEval? eval});

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
  const factory EvaluationContext({required Variant variant, required Position initialPosition}) =
      _EvaluationContext;
}

@freezed
class EvaluationOptions with _$EvaluationOptions {
  const factory EvaluationOptions({
    required int multiPv,
    required int cores,
    required Duration searchTime,
  }) = _EvaluationOptions;
}

/// A function to choose the eval that should be displayed.
Eval? pickBestEval({
  /// The eval from the local engine
  required LocalEval? localEval,

  /// The cached eval which is either a saved eval from the local evaluation or a cloud eval
  required ClientEval? savedEval,

  /// The eval from the server analysis
  required ExternalEval? serverEval,
}) {
  return switch (savedEval) {
    CloudEval() => savedEval,
    final LocalEval eval => localEval != null && localEval.isBetter(eval) ? localEval : eval,
    null => localEval ?? serverEval,
  };
}

/// A function to choose the client eval that should be displayed.
ClientEval? pickBestClientEval({
  /// The eval from the local engine
  required LocalEval? localEval,

  /// The cached eval which is either a saved eval from the local evaluation or a cloud eval
  required ClientEval? savedEval,
}) {
  final eval =
      pickBestEval(localEval: localEval, savedEval: savedEval, serverEval: null) as ClientEval?;

  return eval;
}
