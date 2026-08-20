import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/nnue_service.dart';
import 'package:lichess_mobile/src/model/engine/uci_protocol.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

final _logger = Logger('EvaluationService');

const kEngineEvalEmissionThrottleDelay = Duration(milliseconds: 200);

/// How long a single engine (re)start is given before the engine is declared stuck.
///
/// The plugin bounds the start itself — 5s to reach the engine's greeting, 5s more to reach
/// `uciok` — but nothing bounds the quit that precedes a restart. An engine wedged while joining
/// its search threads never reports the exit that `quit()` waits for, so that future, and the
/// whole operation queue chained onto it, stays pending forever. This watchdog is what turns that
/// silence into a reported failure instead of an engine that is loading and always will be.
const kEngineInitTimeout = Duration(seconds: 20);

/// The minimum delay between two engine failure messages shown to the user.
const _kUserNotificationThrottle = Duration(seconds: 10);

/// The message shown to the user when the engine is gone for good.
const _kUnrecoverableEngineMessage =
    'The chess engine stopped responding. Please restart the app to use it again.';

/// Variants supported by the official Stockfish engine.
const officialStockfishVariants = {Variant.standard, Variant.chess960, Variant.fromPosition};

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
  final service = EvaluationService(ref: ref, maxMemory: maxMemory, nnueService: nnueService);

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
  EvaluationService({required this._ref, required this.maxMemory, required this._nnueService}) {
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

  final Ref _ref;
  final int maxMemory;
  final NnueService _nnueService;

  Stockfish get _stockfish => LichessBinding.instance.stockfish;

  final UCIProtocol _protocol = UCIProtocol();

  // serialize engine start/quit operations to avoid races
  Future<void> _engineOpQueue = Future<void>.value();

  Future<void> _runStockfishOperation(Future<void> Function() op) {
    final result = _engineOpQueue.then((_) => op());
    // The queue tail swallows errors so a single failed operation doesn't block
    // the ones chained after it, but the future returned to the caller keeps the
    // error so awaiting callers (e.g. _initEngine) can still detect failures.
    _engineOpQueue = result.catchError((_, _) {});
    return result;
  }

  late final StreamSubscription<String> _stdoutSubscription;
  late final StreamSubscription<EvalResult> _evalSubscription;
  late final StreamSubscription<MoveResult> _moveSubscription;

  /// The flavor that was originally requested when the engine was last (re)started.
  ///
  /// Used for restart comparisons so that a latestNoNNUE→sf16 fallback doesn't cause restarts on
  /// subsequent latestNoNNUE requests.
  StockfishFlavor? _currentRequestedFlavor;
  Variant? _currentVariant;
  bool _initInProgress = false;
  bool _quitInProgress = false;
  bool _discardEvalResults = false;
  bool _discardMoveResults = false;

  /// Identifies the latest [_initEngine] attempt.
  ///
  /// [quit] clears [_initInProgress] without waiting for the attempt in flight, so a later work
  /// request can start a second [_initEngine] while the first is still awaiting a native
  /// operation. Both then race to cancel [_initWatchdog] and clear [_initInProgress]; without a
  /// token to tell them apart, the older attempt disarms the newer one's watchdog and a start that
  /// never completes is never reported. Only the attempt still holding the current generation
  /// touches that shared state.
  int _initGeneration = 0;

  /// Fires if a (re)start neither succeeds nor fails within [kEngineInitTimeout].
  Timer? _initWatchdog;

  /// The failure that killed the engine for the rest of the process's life, if it happened.
  ///
  /// Latched rather than acted upon once: the native engine keeps its state in process globals
  /// that a wedged engine still owns, so every later start is refused. Work requested afterwards
  /// is rejected on the spot instead of piling more pending operations onto a jammed queue.
  EngineFailure? _unrecoverableFailure;

  /// When the user was last told about an engine failure.
  DateTime? _lastUserNotification;

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
  Stream<EvalResult>? evaluate(EvalWork work, {bool goDeeper = false}) {
    // reset eval is needed to avoid showing a stale eval from a previous work in a different position
    _setEval(null);

    if (!work.threatMode) {
      // If we have an already good enough eval in cache, skip the evaluation
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
  /// If provided, the evaluation will stop at [depthThreshold], if the [minSearchTime] has passed.
  /// This allows for better evaluations in high end devices while still providing quick responses in low end devices.
  /// Even if [depthThreshold] is not reached, the evaluation will still stop at [EvalWork.searchTime].
  Future<LocalEval?> findEval(EvalWork work, {int? depthThreshold, Duration? minSearchTime}) async {
    _setEval(null);

    _logger.info(
      'Finding evaluation at ply ${work.position.ply} with options: '
      'flavor=${work.stockfishFlavor}, multiPv=${work.multiPv}, cores=${work.threads}, '
      'searchTime=${work.searchTime.inMilliseconds}ms, threatMode=${work.threatMode}',
    );

    _startWork(work);

    LocalEval? finalEval;

    try {
      await for (final (_, eval)
          in evalStream
              .where((result) => result.$1 == work)
              .timeout(work.searchTime + const Duration(milliseconds: 1000))) {
        finalEval = eval;
        // if depth threshold is reached quickly, let's still wait min search time (but skip for
        // higher depths)
        if ((eval.depth >= 25 || minSearchTime == null || eval.searchTime >= minSearchTime) &&
            (depthThreshold != null && eval.depth >= depthThreshold)) {
          stop();
          break;
        } else if (eval.searchTime >= work.searchTime) {
          break;
        }
      }
    } on TimeoutException {
      if (_evaluationState.value.currentWork == work) {
        stop();
      }
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
  /// Throws [MoveRequestCancelledException] if the request is cancelled by [quit] or
  /// superseded by another [findMove] call.
  Future<UCIMove> findMove(MoveWork work) {
    _logger.info(
      'Finding move at ply ${work.position.ply} with options: '
      'flavor=${work.stockfishFlavor}, skill=${work.skill}, cores=${work.threads}, '
      'searchTime=${work.searchTime.inMilliseconds}ms',
    );

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

  /// Builds a failure report from the engine's current situation.
  ///
  /// [diagnostics] should be passed when it was captured earlier: quitting a stalled engine moves
  /// it on to another phase, which erases the evidence of where it stalled.
  EngineFailure _describeFailure(
    EngineFailureKind kind,
    String message, {
    required StockfishFlavor flavor,
    required Variant variant,
    StockfishDiagnostics? diagnostics,
    Object? error,
    StackTrace? stackTrace,
  }) => EngineFailure(
    kind: kind,
    message: message,
    flavor: flavor,
    variant: variant,
    engineState: _stockfish.state.value,
    diagnostics: diagnostics ?? _stockfish.diagnostics,
    maxMemoryInMb: maxMemory,
    error: error,
    stackTrace: stackTrace,
  );

  /// Logs a failure, reports it to Crashlytics, and tells the user about it if the engine is not
  /// coming back.
  void _handleFailure(EngineFailure failure) {
    _logger.severe(failure.toString(), failure.error, failure.stackTrace);

    if (failure.isUnrecoverable) {
      _unrecoverableFailure = failure;
    }

    // Fire and forget: reportEngineFailure never throws.
    reportEngineFailure(failure);

    _notifyUser(failure);
  }

  /// Shows the user a snackbar for a failure they cannot work around.
  ///
  /// Recoverable failures are left to the engine button, which already shows an error state; only
  /// an engine that will not come back until the app is restarted is worth interrupting for.
  void _notifyUser(EngineFailure failure) {
    if (!failure.isUnrecoverable) return;

    final now = DateTime.now();
    if (_lastUserNotification != null &&
        now.difference(_lastUserNotification!) < _kUserNotificationThrottle) {
      return;
    }

    try {
      final context = _ref.read(currentNavigatorKeyProvider).currentContext;
      if (context == null || !context.mounted) return;

      showSnackBar(context, _kUnrecoverableEngineMessage, type: SnackBarType.error);
      _lastUserNotification = now;
    } catch (e) {
      // There may be no widget tree to show anything in. Telling the user is best effort and must
      // never take the failure handling around it down.
      _logger.fine('Could not show the engine failure message: $e');
    }
  }

  /// Puts the service into [EngineState.error] and lets go of everything that was waiting on the
  /// engine.
  ///
  /// Three things have to happen together, which is why they live here rather than at each failure
  /// site.
  ///
  /// Nothing is going to answer the work that was in flight, so its callers are failed instead of
  /// being left waiting forever — a pending [findMove] has no timeout of its own.
  ///
  /// The engine identity is forgotten, so that the next [_startWork] restarts the engine rather
  /// than talking to one this service already knows is unusable: the flavor and variant are what
  /// [_startWork] compares to decide, and an engine can break without the plugin moving its own
  /// state to [StockfishState.error].
  ///
  /// And anything the broken engine still emits is dropped. A failed command does not stop the
  /// protocol mid-exchange — [_sendToEngine] reports the refusal rather than throwing it back into
  /// [UCIProtocol], which carries on and announces that it is computing — so without this the
  /// engine state set here is overwritten by the very call that failed.
  void _failEngine() {
    _cancelPendingMoveRequest();
    _setEvalWork(null);
    _currentMoveWork = null;
    _currentRequestedFlavor = null;
    _currentVariant = null;
    _evalThrottleTimer?.cancel();
    _evalThrottleTimer = null;
    _pendingEvalResult = null;
    _discardEvalResults = true;
    _discardMoveResults = true;
    _setEngineState(EngineState.error);
  }

  /// Arms the watchdog that catches a (re)start which never completes at all.
  ///
  /// [generation] is the attempt the watchdog belongs to: it fires only while that attempt is
  /// still the current one, so a superseded start cannot report a failure against the one that
  /// replaced it.
  void _startInitWatchdog(int generation, StockfishFlavor flavor, Variant variant) {
    _cancelInitWatchdog();
    _initWatchdog = Timer(kEngineInitTimeout, () {
      if (generation != _initGeneration) return;
      _initWatchdog = null;
      if (!_initInProgress) return;

      _handleFailure(
        _describeFailure(
          EngineFailureKind.stuck,
          'The engine neither started nor failed within '
          '${kEngineInitTimeout.inSeconds}s. The operation it is blocked on will never complete, '
          'so no further engine work is possible until the app is restarted',
          flavor: flavor,
          variant: variant,
        ),
      );

      // Nothing will ever answer the work that was waiting on this start, so release its callers
      // instead of leaving them thinking forever.
      _failEngine();
    });
  }

  void _cancelInitWatchdog() {
    _initWatchdog?.cancel();
    _initWatchdog = null;
  }

  /// Start the given [work], restarting the engine if necessary.
  void _startWork(Work work) {
    if (_unrecoverableFailure case final failure?) {
      _logger.severe('Refusing engine work: the engine is unusable. $failure');
      _failEngine();
      _notifyUser(failure);
      return;
    }

    final flavor = officialStockfishVariants.contains(work.variant)
        ? work.stockfishFlavor
        : StockfishFlavor.variant;

    final stockfishState = _stockfish.state.value;

    // Compare against the originally requested flavor, not the effective one. This prevents restart
    // when latestNoNNUE fell back to sf16
    final needsRestart =
        _quitInProgress ||
        _currentRequestedFlavor != flavor ||
        _currentVariant != work.variant ||
        stockfishState == StockfishState.initial ||
        stockfishState == StockfishState.error;

    final previousWork = _evaluationState.value.currentWork ?? _currentMoveWork;
    final needsNewGame =
        previousWork != null &&
        (previousWork.id != work.id || previousWork.initialPosition != work.initialPosition);

    _logger.finer(
      'Engine restart needed: $needsRestart, new game needed: $needsNewGame, current engine state: $stockfishState',
    );
    // Update work and flag other type of work to be discarded
    switch (work) {
      case final EvalWork evalWork:
        _setEvalWork(evalWork);
        _discardEvalResults = false;
        _discardMoveResults = true;
        _cancelPendingMoveRequest();
      case final MoveWork moveWork:
        _setMoveWork(moveWork);
        _discardMoveResults = false;
        _discardEvalResults = true;
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
      _initEngine(flavor, work.variant).then((_) {
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

  Future<void> _initEngine(StockfishFlavor flavor, Variant variant) async {
    // The effective flavor, which differs from the requested one when NNUE files are missing. Kept
    // outside the try so that a failure report names the flavor that actually failed.
    StockfishFlavor actualFlavor = flavor;

    final generation = ++_initGeneration;

    _startInitWatchdog(generation, flavor, variant);

    try {
      _logger.fine(
        'Initializing engine: flavor=${flavor.name}, variant=${variant.name}, '
        'hash=${maxMemory}MB, engine state=${_stockfish.state.value.name}',
      );

      await _runStockfishOperation(() => _stockfish.quit());

      _protocol.reset();

      String? smallNetPath;
      String? bigNetPath;

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

      await _runStockfishOperation(
        () => _stockfish.start(
          flavor: actualFlavor,
          // We always pass the variant, but this is ignored if flavor is not StockfishFlavor.variant
          variant: variant.fairy,
          smallNetPath: smallNetPath,
          bigNetPath: bigNetPath,
        ),
      );

      if (_stockfish.state.value == StockfishState.error) {
        _handleFailure(
          _describeFailure(
            EngineFailureKind.start,
            'The engine reported an error state instead of becoming ready',
            flavor: actualFlavor,
            variant: variant,
          ),
        );
        _failEngine();
        return;
      }

      _logger.fine(
        'Engine initialized successfully: flavor=${actualFlavor.name}, '
        'diagnostics: ${_stockfish.diagnostics}',
      );

      _currentRequestedFlavor = flavor;
      _currentVariant = variant;

      _protocol.connected(_sendToEngine);
    } catch (e, st) {
      // start() reports where it gave up in its own TimeoutException, but the diagnostics read
      // here still say which phase the engine is sitting in now, which is what tells a failed boot
      // apart from a shutdown that never finished.
      _handleFailure(
        _describeFailure(
          EngineFailureKind.start,
          'The engine failed to start',
          flavor: actualFlavor,
          variant: variant,
          error: e,
          stackTrace: st,
        ),
      );
      _failEngine();
    } finally {
      // A superseded attempt owns none of this any more: the start that replaced it — or the
      // quit that cancelled it — is what the watchdog and the in-progress flag now describe.
      if (generation == _initGeneration) {
        _cancelInitWatchdog();
        _initInProgress = false;
      }
    }
  }

  /// Sends a command to a running engine, reporting a refusal rather than throwing it at the
  /// caller.
  ///
  /// The plugin's `stdin` setter throws when the engine is no longer ready — which happens on its
  /// own, without anything here asking for it, when a write breaks the command stream. It is
  /// called from deep inside [UCIProtocol], so letting it throw would surface as a crash in
  /// whatever UI happened to request the evaluation.
  void _sendToEngine(String command) {
    try {
      _stockfish.stdin = command;
    } catch (e, st) {
      _handleFailure(
        _describeFailure(
          EngineFailureKind.command,
          'The engine refused the command "$command"',
          flavor: _currentRequestedFlavor ?? _stockfish.flavor,
          variant: _currentVariant ?? Variant.standard,
          error: e,
          stackTrace: st,
        ),
      );
      _failEngine();
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
        if (_initInProgress) {
          // The (re)start in flight owns this outcome: _initEngine reports the failure with the
          // flavor and variant it was starting, and a start that recovers from a failed shutdown
          // still has work to run, so nothing is given up on here.
          _setEngineState(EngineState.error);
        } else {
          // A running engine broke under us — including one that could not even be asked to quit,
          // which the plugin reports the same way.
          _handleFailure(
            _describeFailure(
              EngineFailureKind.runtime,
              _quitInProgress
                  ? 'The engine failed while shutting down'
                  : 'The engine failed while it was running',
              flavor: _currentRequestedFlavor ?? _stockfish.flavor,
              variant: _currentVariant ?? Variant.standard,
            ),
          );
          _failEngine();
        }
    }
  }

  void _onComputingChange() {
    // When both discard flags are set, the engine is being quit or has failed; its computing
    // state says nothing about work this service still cares about.
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
      // Drop results if they are flagged to be discarded
      if (_discardEvalResults) return;
      _emitEval(pending);
      // Start new throttle window for trailing emission
      _evalThrottleTimer = Timer(kEngineEvalEmissionThrottleDelay, _onThrottleExpired);
    }
  }

  void _emitEval(EvalResult result) {
    if (_discardEvalResults) return;
    _evalController.add(result);
    final currentWork = _evaluationState.value.currentWork ?? _currentMoveWork;
    if (currentWork != null && result.$1 == currentWork) {
      _setEval(result.$2);
    }
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
    if (_engineState == EngineState.initial && !_initInProgress) {
      _logger.fine('Engine already quit or uninitialized. Ignoring duplicate quit call.');
      return;
    }
    _logger.info('Quitting engine');
    _quitInProgress = true;
    _cancelInitWatchdog();
    _protocol.compute(null);
    _evalThrottleTimer?.cancel();
    _evalThrottleTimer = null;
    _pendingEvalResult = null;
    _cancelPendingMoveRequest();
    _discardEvalResults = true;
    _discardMoveResults = true;
    _currentMoveWork = null;
    _runStockfishOperation(() async {
      try {
        await _stockfish.quit();
      } finally {
        _quitInProgress = false;
      }
    });
    _currentRequestedFlavor = null;
    _currentVariant = null;
    _initInProgress = false;

    _evaluationState.value = (
      engineName: null,
      eval: null,
      state: EngineState.initial,
      currentWork: null,
    );
  }

  void _dispose() {
    _cancelInitWatchdog();
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
    _runStockfishOperation(() => _stockfish.quit());
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

  late ValueListenable<EngineEvaluationState> _listenable;

  @override
  EngineEvaluationState build() {
    _listenable = ref.watch(evaluationServiceProvider).evaluationState;

    _listenable.addListener(_listener);

    ref.onDispose(() {
      _listenable.removeListener(_listener);
    });

    final evalState = _listenable.value;
    return _filter(evalState) ? evalState : EvaluationService._defaultState;
  }

  void _listener() {
    // Defer state update to run outside Riverpod's callback stack
    // This is needed because notifications can be triggered during disposal
    // of other providers (e.g., when EngineEvaluationMixin's onDispose calls quit())
    Future.microtask(() {
      if (!ref.mounted) return;
      final evaluationState = _listenable.value;
      if (_filter(evaluationState)) {
        state = evaluationState;
      } else {
        state = EvaluationService._defaultState;
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

extension FairyVariantExtension on Variant {
  /// The Fairy-Stockfish variant name
  String get fairy => switch (this) {
    Variant.standard => 'chess',
    Variant.chess960 => 'chess',
    Variant.fromPosition => 'chess',
    Variant.antichess => 'antichess',
    Variant.kingOfTheHill => 'kingofthehill',
    Variant.threeCheck => '3check',
    Variant.atomic => 'atomic',
    Variant.horde => 'horde',
    Variant.racingKings => 'racingkings',
    Variant.crazyhouse => 'crazyhouse',
  };
}
