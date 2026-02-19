import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/nnue_service.dart';
import 'package:lichess_mobile/src/model/engine/uci_protocol.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

final _logger = Logger('EvaluationService');

const kEngineEvalEmissionThrottleDelay = Duration(milliseconds: 200);

/// Variants supported by the official Stockfish engine.
const officialStockfishVariants = {Variant.standard, Variant.chess960, Variant.fromPosition};

/// Exception thrown when the engine does not support the requested variant.
class EngineUnsupportedVariantException implements Exception {
  const EngineUnsupportedVariantException(this.variant);

  final Variant variant;

  @override
  String toString() =>
      'EngineUnsupportedVariantException: variant $variant is not supported by the engine';
}

/// Exception thrown when a [EvaluationService.findMove] request is cancelled.
///
/// This can happen when [EvaluationService.quit] is called, or when a new
/// [EvaluationService.findMove] request supersedes the current one.
class MoveRequestCancelledException implements Exception {
  const MoveRequestCancelledException();

  @override
  String toString() => 'MoveRequestCancelledException: the move request was cancelled';
}

/// A provider for [EvaluationService].
final evaluationServiceProvider = Provider<EvaluationService>((Ref ref) {
  final maxMemory = ref.read(preloadedDataProvider).requireValue.engineMaxMemoryInMb;
  final nnueService = ref.read(nnueServiceProvider);
  final service = EvaluationService(maxMemory: maxMemory, nnueService: nnueService);

  ref.onDispose(() {
    service._dispose();
  });

  return service;
}, name: 'EvaluationServiceProvider');

/// A service to evaluate chess positions using Stockfish.
///
/// This is a singleton service that wraps the Stockfish engine. Only one evaluation
/// can run at a time - when a new evaluation is requested, it takes over from any
/// previous one ("last caller wins").
class EvaluationService {
  EvaluationService({required this.maxMemory, required NnueService nnueService})
    : _nnueService = nnueService {
    _stdoutSubscription = _stockfish.stdout.listen(_protocol.received);
    _stockfish.state.addListener(_onStockfishStateChange);
    _protocol.isComputing.addListener(_onComputingChange);
    _protocol.engineName.addListener(_onEngineNameChange);
    _evalSubscription = _protocol.evalStream.listen(_onEvalResult);
    _moveSubscription = _protocol.moveStream.listen(_onMoveResult);
  }

  static const _defaultState = (
    engineName: null,
    eval: null,
    state: EngineState.initial,
    currentWork: null,
  );

  final int maxMemory;
  final NnueService _nnueService;

  Stockfish get _stockfish => LichessBinding.instance.stockfish;

  final UCIProtocol _protocol = UCIProtocol();

  late final StreamSubscription<String> _stdoutSubscription;
  late final StreamSubscription<EvalResult> _evalSubscription;
  late final StreamSubscription<MoveResult> _moveSubscription;

  StockfishFlavor? _currentFlavor;
  bool _initInProgress = false;
  bool _discardEvalResults = false;
  bool _discardMoveResults = false;

  // Throttling state for eval emissions
  Timer? _evalThrottleTimer;
  EvalResult? _pendingEvalResult;

  /// Pending move request state.
  (Completer<UCIMove>, StreamSubscription<MoveResult>)? _pendingMoveRequest;

  final _evalController = StreamController<EvalResult>.broadcast();
  final _moveController = StreamController<MoveResult>.broadcast();

  /// Stream of evaluation results tagged with their [EvalWork].
  ///
  /// Listeners should filter results by comparing the Work to their own request
  /// to determine if the result is relevant to them.
  ///
  /// This stream is throttled to avoid excessive UI updates.
  Stream<EvalResult> get evalStream => _evalController.stream;

  /// Stream of move results tagged with their [MoveWork].
  Stream<MoveResult> get moveStream => _moveController.stream;

  final ValueNotifier<EngineEvaluationState> _evaluationState = ValueNotifier(_defaultState);

  /// The current engine evaluation state, combining engine name, eval, state, and current work.
  ValueListenable<EngineEvaluationState> get evaluationState => _evaluationState;

  /// The current engine state.
  EngineState get _engineState => _evaluationState.value.state;

  MoveWork? _currentMoveWork;

  void _setEngineState(EngineState newState) {
    _logger.fine('Engine state: ${newState.name}');
    if (_engineState != newState) {
      _setState(state: newState);
    }
  }

  void _setEval(LocalEval? eval) {
    _setState(evalFn: () => eval);
  }

  void _setEvalWork(EvalWork? work) {
    _setState(workFn: () => work);
  }

  // ignore: use_setters_to_change_properties
  void _setMoveWork(MoveWork? work) {
    _currentMoveWork = work;
  }

  void _setState({
    EngineState? state,
    LocalEval? Function()? evalFn,
    EvalWork? Function()? workFn,
  }) {
    final current = _evaluationState.value;
    final newState = (
      engineName: _protocol.engineName.value,
      eval: evalFn != null ? evalFn() : current.eval,
      state: state ?? current.state,
      currentWork: workFn != null ? workFn() : current.currentWork,
    );
    if (current != newState) {
      _evaluationState.value = newState;
    }
  }

  /// Start evaluating the given [work].
  ///
  /// This will stop any current evaluation and start a new one. Last caller wins.
  ///
  /// Returns a [Stream] of [EvalResult]s for this work only. The stream completes
  /// when the evaluation finishes or is replaced by another request.
  ///
  /// If [goDeeper] is true, the engine will use the maximum search time.
  ///
  /// Returns `null` if a cached eval is sufficient.
  /// Throws [EngineUnsupportedVariantException] if the variant is not supported.
  Stream<EvalResult>? evaluate(EvalWork work, {bool goDeeper = false}) {
    // reset eval
    _setEval(null);

    // Check if cached eval is sufficient
    if (!work.threatMode) {
      switch (work.evalCache) {
        case final LocalEval localEval when localEval.searchTime >= work.searchTime:
        case CloudEval _ when goDeeper == false:
          stop();
          return null;
        case _:
          break;
      }
    }

    _logger.info(
      'Starting evaluation at ply ${work.position.ply} with options: '
      'flavor=${work.stockfishFlavor}, multiPv=${work.multiPv}, cores=${work.threads}, '
      'searchTime=${work.searchTime.inMilliseconds}ms, threatMode=${work.threatMode}',
    );

    _startWork(work);

    return evalStream.where((result) => result.$1 == work);
  }

  /// Find the evaluation for the given [work].
  ///
  /// This will stop any current work and start a new evaluation. Last caller wins.
  ///
  /// Returns a [Future] that completes with the evaluation, or `null` if no evaluation
  /// could be obtained (e.g. the engine fails).
  ///
  /// The [work] must have a [EvalWork.searchTime] set.
  ///
  /// If [minDepth] is provided, the evaluation will stop early once this depth is reached.
  /// Otherwise, it will run for the full [EvalWork.searchTime].
  ///
  /// Throws [EngineUnsupportedVariantException] if the variant is not supported.
  Future<LocalEval?> findEval(EvalWork work, {int? minDepth}) async {
    assert(work.searchTime != Duration.zero, 'searchTime must be set for findEval');

    final stream = evaluate(work);
    if (stream == null) {
      // do we have a cached eval?
      switch (work.evalCache) {
        case final LocalEval localEval:
          return localEval;
        case CloudEval _:
          return null;
        case _:
          return null;
      }
    }

    LocalEval? finalEval;
    try {
      await for (final (_, eval) in stream.timeout(
        work.searchTime + const Duration(milliseconds: 500),
      )) {
        finalEval = eval;
        if (minDepth != null && eval.depth >= minDepth) {
          stop();
          break;
        }
      }
    } on TimeoutException {
      stop();
    }

    _logger.info(
      'Final eval at ply ${work.position.ply}: '
      'depth=${finalEval?.depth}, cp=${finalEval?.cp}, mate=${finalEval?.mate}, '
      'nodes=${finalEval?.nodes}, time=${finalEval?.searchTime.inMilliseconds}ms',
    );

    return finalEval;
  }

  /// Find the best move for the given [work] at the specified engine strength level.
  ///
  /// This will stop any current work and start a new move search. Last caller wins.
  ///
  /// Returns a [Future] that completes with the best move found by the engine.
  ///
  /// Throws [EngineUnsupportedVariantException] if the variant is not supported.
  /// Throws [MoveRequestCancelledException] if the request is cancelled by [quit] or
  /// superseded by another [findMove] call.
  Future<UCIMove> findMove(MoveWork work) {
    _logger.info(
      'Finding move at ply ${work.position.ply} with options: '
      'flavor=${work.stockfishFlavor}, elo=${work.elo}, cores=${work.threads}, '
      'searchTime=${work.searchTime.inMilliseconds}ms',
    );

    // Cancel any previous pending move request
    _cancelPendingMoveRequest();

    final completer = Completer<UCIMove>();
    final subscription = moveStream.where((result) => result.$1 == work).listen((result) {
      if (!completer.isCompleted) {
        completer.complete(result.$2);
      }
      _pendingMoveRequest?.$2.cancel();
      _pendingMoveRequest = null;
    });

    _pendingMoveRequest = (completer, subscription);

    _startWork(work);

    return completer.future;
  }

  void _cancelPendingMoveRequest() {
    if (_pendingMoveRequest case (final completer, final subscription)) {
      subscription.cancel();
      if (!completer.isCompleted) {
        completer.completeError(const MoveRequestCancelledException());
      }
      _pendingMoveRequest = null;
    }
  }

  /// Start the given [work], restarting the engine if necessary.
  void _startWork(Work work) {
    final flavor = officialStockfishVariants.contains(work.variant)
        ? work.stockfishFlavor
        : StockfishFlavor.variant;

    final stockfishState = _stockfish.state.value;
    final needsRestart =
        _currentFlavor != flavor ||
        stockfishState == StockfishState.initial ||
        stockfishState == StockfishState.error;

    // Check if we need to clear engine context (different game/puzzle)
    final previousWork = _evaluationState.value.currentWork ?? _currentMoveWork;
    final needsNewGame =
        previousWork != null &&
        (previousWork.id != work.id || previousWork.initialPosition != work.initialPosition);

    _logger.finer(
      'Engine restart needed: $needsRestart, new game needed: $needsNewGame, current engine state: $stockfishState',
    );

    switch (work) {
      case final EvalWork evalWork:
        _setEvalWork(evalWork);
        _discardEvalResults = false;
      case final MoveWork moveWork:
        _setMoveWork(moveWork);
        _discardMoveResults = false;
    }

    if (_initInProgress) {
      _logger.fine('Work requested while engine initialization is in progress, queuing work');

      // Init in progress, work will be computed when init finishes
      // (the _initEngine callback checks the current work state)
      return;
    }

    if (needsRestart) {
      _initInProgress = true;
      _setEngineState(EngineState.loading);
      _initEngine(flavor).then((_) {
        // Compute the current work (might be different from original if another request came in)
        final currentWork = _evaluationState.value.currentWork ?? _currentMoveWork;
        if (currentWork != null) {
          _protocol.compute(currentWork);
        }
      });
    } else {
      _protocol.compute(work, newGame: needsNewGame);
    }
  }

  Future<void> _initEngine(StockfishFlavor flavor) async {
    try {
      _logger.fine('Initializing engine with flavor: $flavor');

      await _stockfish.quit();

      _protocol.reset();

      String? smallNetPath;
      String? bigNetPath;
      StockfishFlavor actualFlavor = flavor;

      if (flavor == StockfishFlavor.latestNoNNUE) {
        if (await _nnueService.checkNNUEFiles()) {
          final nnueFiles = _nnueService.nnueFiles;
          smallNetPath = nnueFiles.smallNet.path;
          bigNetPath = nnueFiles.bigNet.path;
        } else {
          _logger.warning('NNUE files not found or corrupted. Falling back to SF16.');
          actualFlavor = StockfishFlavor.sf16;
        }
      }

      await _stockfish.start(
        flavor: actualFlavor,
        smallNetPath: smallNetPath,
        bigNetPath: bigNetPath,
      );

      if (_stockfish.state.value == StockfishState.error) {
        _setEngineState(EngineState.error);
        return;
      }

      _logger.fine('Engine initialized successfully with flavor: $actualFlavor');

      _currentFlavor = actualFlavor;

      _protocol.connected((cmd) => _stockfish.stdin = cmd);
    } catch (e, s) {
      _logger.severe('Error initializing engine', e, s);
      _setEngineState(EngineState.error);
    } finally {
      _initInProgress = false;
    }
  }

  void _onStockfishStateChange() {
    switch (_stockfish.state.value) {
      case StockfishState.initial:
        // Don't overwrite loading state during engine restart
        if (_engineState != EngineState.loading) {
          _setEngineState(EngineState.initial);
        }
      case StockfishState.starting:
        _setEngineState(EngineState.loading);
      case StockfishState.ready:
        if (_engineState != EngineState.computing) {
          _setEngineState(EngineState.idle);
        }
      case StockfishState.error:
        _setEngineState(EngineState.error);
    }
  }

  void _onComputingChange() {
    // When both discard flags are set, a quit is in progress; ignore computing state changes.
    if (_discardEvalResults && _discardMoveResults) return;

    if (_protocol.isComputing.value) {
      _setEngineState(EngineState.computing);
    } else {
      _setEngineState(EngineState.idle);
    }
  }

  void _onEngineNameChange() {
    // engineName is always read from _protocol.engineName.value in _setState,
    // so we just need to trigger a state update
    _setState();
  }

  /// Handles incoming eval results with throttling.
  ///
  /// Implements trailing throttle: emits immediately if no throttle is active,
  /// otherwise stores the result to emit when the throttle window expires.
  void _onEvalResult(EvalResult result) {
    if (_discardEvalResults) return;

    if (_evalThrottleTimer == null) {
      // No active throttle - emit immediately and start throttle window
      _emitEval(result);
      _evalThrottleTimer = Timer(kEngineEvalEmissionThrottleDelay, _onThrottleExpired);
    } else {
      // Within throttle window - store for trailing emission
      _pendingEvalResult = result;
    }
  }

  void _onThrottleExpired() {
    _evalThrottleTimer = null;
    final pending = _pendingEvalResult;
    if (pending != null) {
      _pendingEvalResult = null;
      _emitEval(pending);
      // Start new throttle window for trailing emission
      _evalThrottleTimer = Timer(kEngineEvalEmissionThrottleDelay, _onThrottleExpired);
    }
  }

  void _emitEval(EvalResult result) {
    _setEval(result.$2);
    _evalController.add(result);
  }

  void _onMoveResult(MoveResult result) {
    if (_discardMoveResults) return;
    _moveController.add(result);
  }

  /// Stop the current work (evaluation or move search).
  ///
  /// This method stops the engine from computing further but does not clear the evaluation state.
  /// The engine can still emit results for the current work until it fully stops.
  void stop() {
    _protocol.compute(null);
    _currentMoveWork = null;
    _setEvalWork(null);
  }

  /// Quit the engine entirely.
  ///
  /// This should be called when the engine is no longer needed (e.g., when leaving an analysis screen).
  /// The service can be reused after calling this method.
  void quit() {
    _logger.info('Quitting engine');
    _protocol.compute(null);
    _evalThrottleTimer?.cancel();
    _evalThrottleTimer = null;
    _pendingEvalResult = null;
    _cancelPendingMoveRequest();
    _discardEvalResults = true;
    _discardMoveResults = true;
    _currentMoveWork = null;
    _stockfish.quit();
    _currentFlavor = null;
    _initInProgress = false;

    _evaluationState.value = (
      engineName: null,
      eval: null,
      state: EngineState.initial,
      currentWork: null,
    );
  }

  void _dispose() {
    _evalThrottleTimer?.cancel();
    _evalThrottleTimer = null;
    _pendingEvalResult = null;
    _cancelPendingMoveRequest();
    _currentMoveWork = null;
    _stdoutSubscription.cancel();
    _evalSubscription.cancel();
    _moveSubscription.cancel();
    _stockfish.state.removeListener(_onStockfishStateChange);
    _protocol.isComputing.removeListener(_onComputingChange);
    _protocol.engineName.removeListener(_onEngineNameChange);
    _protocol.dispose();
    _stockfish.quit();
    _evalController.close();
    _moveController.close();
    _evaluationState.dispose();
  }
}

/// Engine state.
enum EngineState { initial, loading, idle, computing, error }

/// A record type holding the current engine evaluation state.
typedef EngineEvaluationState = ({
  String? engineName,
  LocalEval? eval,
  EngineState state,
  EvalWork? currentWork,
});

/// A provider that exposes the current engine evaluation state to the UI.
final engineEvaluationProvider = NotifierProvider.autoDispose
    .family<EngineEvaluationNotifier, EngineEvaluationState, EngineEvaluationFilters>(
      EngineEvaluationNotifier.new,
      name: 'EngineEvaluationProvider',
    );

/// A type for filtering engine evaluation notifications.
typedef EngineEvaluationFilters = ({StringId id, UciPath? path});

class EngineEvaluationNotifier extends Notifier<EngineEvaluationState> {
  EngineEvaluationNotifier(this.filters);

  final EngineEvaluationFilters filters;

  @override
  EngineEvaluationState build() {
    final listenable = ref.watch(evaluationServiceProvider).evaluationState;

    listenable.addListener(_listener);

    ref.onDispose(() {
      listenable.removeListener(_listener);
    });

    final evalState = listenable.value;
    if (_filter(evalState)) {
      return evalState;
    } else {
      return EvaluationService._defaultState;
    }
  }

  void _listener() {
    // Defer state update to run outside Riverpod's callback stack
    // This is needed because notifications can be triggered during disposal
    // of other providers (e.g., when EngineEvaluationMixin's onDispose calls quit())
    Future.microtask(() {
      if (ref.mounted) {
        final evaluationState = ref.read(evaluationServiceProvider).evaluationState.value;
        if (_filter(evaluationState)) {
          state = evaluationState;
        }
      }
    });
  }

  bool _filter(EngineEvaluationState state) {
    final (id: id, path: path) = filters;
    final work = state.currentWork;
    return work == null || (work.id == id && (path == null || work.path == path));
  }
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
  if (localEval?.threatMode == true) {
    return localEval;
  }

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
