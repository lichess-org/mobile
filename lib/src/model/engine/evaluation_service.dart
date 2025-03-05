import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'evaluation_service.freezed.dart';
part 'evaluation_service.g.dart';

const kEngineEvalEmissionThrottleDelay = Duration(milliseconds: 300);

final maxEngineCores = max(Platform.numberOfProcessors - 1, 1);
final defaultEngineCores = min((Platform.numberOfProcessors / 2).ceil(), maxEngineCores);

const engineSupportedVariants = {Variant.standard, Variant.chess960, Variant.fromPosition};

/// A service to evaluate chess positions using an engine.
class EvaluationService {
  EvaluationService({required this.maxMemory});

  final int maxMemory;

  Engine? _engine;

  /// A future that completes once the engine is disposed.
  ///
  /// This is used to avoid disposing the engine twice.
  Future<void>? _engineDisposingFuture;

  EvaluationContext? _context;
  EvaluationOptions _options = EvaluationOptions(
    multiPv: 1,
    cores: defaultEngineCores,
    searchTime: const Duration(seconds: 10),
  );

  static const _defaultState = (engineName: 'Stockfish', state: EngineState.initial, eval: null);

  final ValueNotifier<EngineEvaluationState> _state = ValueNotifier(_defaultState);
  ValueListenable<EngineEvaluationState> get state => _state;

  /// Initialize the engine with the given context and options.
  ///
  /// If the engine is already initialized, it is disposed first.
  ///
  /// An optional [engineFactory] can be provided, it defaults to Stockfish.
  ///
  /// If [options] is not provided, the default options are used.
  /// This method must be called before calling [start]. It is the caller's
  /// responsibility to close the engine.
  Future<void> _initEngine(
    EvaluationContext context, {
    Engine Function() engineFactory = StockfishEngine.new,
    EvaluationOptions? options,
  }) async {
    await disposeEngine();
    _context = context;
    _engineDisposingFuture = null;
    if (options != null) _options = options;
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
          eval: _state.value.eval,
        );
      }
    });
  }

  /// Ensure the engine is initialized with the given context and options.
  Future<void> ensureEngineInitialized(
    EvaluationContext context, {
    Engine Function() engineFactory = StockfishEngine.new,
    EvaluationOptions? options,
  }) async {
    if (_engine == null || _context != context) {
      await _initEngine(context, engineFactory: engineFactory, options: options);
    }
  }

  void setOptions(EvaluationOptions options) {
    stop();
    _options = options;
  }

  /// Dispose the engine.
  ///
  /// Returns a future that completes once the engine is disposed.
  /// It is safe to call this method multiple times.
  Future<void> disposeEngine() {
    if (_engine == null) return Future.value();

    return _engineDisposingFuture ??= _engine!.dispose().then((_) {
      _engine = null;
      _context = null;
    });
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
      searchTime: _options.searchTime,
      multiPv: _options.multiPv,
      path: path,
      initialPosition: context.initialPosition,
      steps: IList(steps),
    );

    // cancel evaluation if we already have an interesting eval
    final cachedEval = work.steps.isEmpty ? initialPositionEval : work.evalCache;
    switch (cachedEval) {
      // we have a local eval
      case final LocalEval localEval:
        // if the search time is greater than the current search time, don't evaluate again but
        // update the engine state with the local eval
        if (localEval.searchTime >= _options.searchTime) {
          _state.value = (
            engineName: _state.value.engineName,
            state: _state.value.state,
            eval: localEval,
          );
          return null;
        }
      // we have a cloud eval, no need to evaluate
      case CloudEval _:
        _state.value = (engineName: _state.value.engineName, state: _state.value.state, eval: null);
        return null;
      // no eval, continue
      case null:
        break;
    }

    final evalStream = engine
        .start(work)
        .throttle(kEngineEvalEmissionThrottleDelay, trailing: true);

    evalStream.forEach((t) {
      final (work, eval) = t;
      if (shouldEmit(work)) {
        _state.value = (engineName: _state.value.engineName, state: _state.value.state, eval: eval);
      }
    });

    return evalStream;
  }

  void stop() {
    _engine?.stop();
  }
}

@Riverpod(keepAlive: true)
EvaluationService evaluationService(Ref ref) {
  final maxMemory = ref.read(preloadedDataProvider).requireValue.engineMaxMemoryInMb;

  final service = EvaluationService(maxMemory: maxMemory);
  ref.onDispose(() {
    service.disposeEngine();
  });
  return service;
}

typedef EngineEvaluationState = ({String engineName, EngineState state, LocalEval? eval});

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
    LocalEval() => localEval ?? savedEval,
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

/// A function to choose the best moves that should be displayed.
IList<MoveWithWinningChances>? pickBestMoves({
  /// The best moves from the local engine
  required IList<MoveWithWinningChances>? localBestMoves,

  /// The cached eval which is either a saved eval from the local evaluation or a cloud eval
  required ClientEval? savedEval,
}) {
  return switch (savedEval) {
    CloudEval() => savedEval.bestMoves,
    LocalEval() => localBestMoves ?? savedEval.bestMoves,
    null => localBestMoves,
  };
}
