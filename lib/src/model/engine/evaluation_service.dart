import 'dart:async';
import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/nnue_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

final _logger = Logger('EvaluationService');

const kEngineEvalEmissionThrottleDelay = Duration(milliseconds: 200);

/// The shallowest depth worth reporting. Below it the engine is still guessing.
const minDepth = 6;

/// The minimum delay between two engine failure messages shown to the user.
const _kUserNotificationThrottle = Duration(seconds: 10);

/// The message shown to the user when the engine is gone for good.
const _kUnrecoverableEngineMessage =
    'The chess engine stopped responding. Please restart the app to use it again.';

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

/// A service to evaluate chess positions, and to ask the engine for a move to play.
///
/// It owns one [Engine] at a time and multiplexes both roles onto it: only one search can run at
/// a time, and a new request takes over from whatever was running ("last caller wins").
class EvaluationService {
  EvaluationService({required this._ref, required this.maxMemory, required this._nnueService});

  static const _defaultState = (
    engineName: null,
    eval: null,
    state: EngineState.initial,
    currentWork: null,
  );

  final Ref _ref;
  final int maxMemory;
  final NnueService _nnueService;

  /// The live engine, or null while there is none.
  Engine? _engine;

  /// The flavor the live engine was resolved from.
  ///
  /// The *requested* flavor, not the effective one, so that a latestNoNNUE→sf16 fallback does not
  /// make every later latestNoNNUE request look like a change of engine. The variant is not part
  /// of this: it is a per-search option now, so two variants share one Fairy-Stockfish engine.
  StockfishFlavor? _engineFlavor;

  bool _startInProgress = false;

  /// Distinguishes the engine the service is currently interested in from one a [quit] or a
  /// failure has already let go of, so that a start still in flight cannot resurrect it.
  int _generation = 0;

  /// The search whose `info` lines are being accumulated into [_currentEval].
  ///
  /// Tracked rather than assumed, because a search that has been superseded goes on reporting
  /// until its own `bestmove`: the accumulation belongs to whichever search the engine is actually
  /// answering, and is started over when a different one starts to speak.
  Search? _accumulatingFor;

  /// The evaluation being accumulated from that search's `info` lines.
  LocalEval? _currentEval;
  int _expectedPvs = 1;

  /// The failure that killed the engine for the rest of the process's life, if it happened.
  ///
  /// Latched rather than acted upon once: a native engine stuck in a transitional phase owns the
  /// process globals the next one would need, so every later start is refused. Work requested
  /// afterwards is rejected on the spot instead of piling more work onto a jammed engine.
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

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

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

  /// Stop the current work (evaluation or move search).
  ///
  /// This method stops the engine from computing further but does not clear the evaluation state.
  /// The engine can still emit results for the current work until it fully stops.
  void stop() {
    // The search is not forgotten: the engine goes on reporting until its `bestmove`, and that
    // last word on the position is worth having.
    _engine?.stop();
    _currentMoveWork = null;
    _setEvalWork(null);
  }

  /// Quit the engine entirely.
  ///
  /// This should be called when the engine is no longer needed (e.g., when leaving an analysis screen).
  /// The service can be reused after calling this method.
  void quit() {
    if (_engine == null && !_startInProgress) {
      _logger.fine('Engine already quit or uninitialized. Ignoring duplicate quit call.');
      return;
    }
    _logger.info('Quitting engine');
    _generation++;
    _cancelEvalThrottle();
    _cancelPendingMoveRequest();
    _currentMoveWork = null;
    _currentEval = null;
    _accumulatingFor = null;
    unawaited(_disposeEngine());
    _evaluationState.value = _defaultState;
  }

  // ---------------------------------------------------------------------------
  // Engine lifecycle
  // ---------------------------------------------------------------------------

  /// Start the given [work], starting or replacing the engine if necessary.
  void _startWork(Work work) {
    if (_unrecoverableFailure case final failure?) {
      _logger.severe('Refusing engine work: the engine is unusable. $failure');
      _failEngine();
      _notifyUser(failure);
      return;
    }

    final previousWork = _evaluationState.value.currentWork ?? _currentMoveWork;
    final needsNewGame =
        previousWork != null &&
        (previousWork.id != work.id || previousWork.initialPosition != work.initialPosition);

    switch (work) {
      case final EvalWork evalWork:
        _setEvalWork(evalWork);
        _cancelPendingMoveRequest();
      case final MoveWork moveWork:
        _currentMoveWork = moveWork;
    }

    final flavor = _flavorFor(work);

    if (_engine != null && _engineFlavor == flavor) {
      _compute(work, newGame: needsNewGame);
      return;
    }

    if (_startInProgress) {
      // The start in flight picks up whatever work is current when it finishes, and starts another
      // engine itself if that work needs a different one.
      _logger.fine('Work requested while the engine is starting; it will run when it is ready');
      return;
    }

    unawaited(_startEngine(flavor));
  }

  Future<void> _startEngine(StockfishFlavor flavor) async {
    final generation = _generation;
    _startInProgress = true;
    _setEngineState(EngineState.loading);

    try {
      final spec = await _resolveSpec(flavor);
      await _disposeEngine();

      _logger.fine('Starting engine: $spec, hash=${maxMemory}MB');
      final engine = await _ref.read(engineFactoryProvider).create(spec);

      if (generation != _generation) {
        // A quit, or a failure, let go of this attempt while it was starting.
        unawaited(engine.dispose());
      } else {
        _engine = engine;
        _engineFlavor = flavor;
        engine.name.addListener(_onEngineNameChange);
        engine.isSearching.addListener(_onSearchingChange);
        unawaited(engine.death.then((failure) => _onEngineDeath(engine, failure)));
        _setEngineState(EngineState.idle);
      }
    } catch (e, st) {
      if (generation != _generation) return;
      _handleFailure(
        switch (e) {
          final EngineCreationException creation => creation.failure,
          _ => EngineFailure(
            kind: EngineFailureKind.start,
            message: 'The engine failed to start',
            flavor: flavor,
            error: e,
            stackTrace: st,
          ),
        }.withContext(maxMemoryInMb: maxMemory),
      );
      _failEngine();
      return;
    } finally {
      _startInProgress = false;
    }

    // Work requested while the engine was starting was left waiting for it, and may not even want
    // the engine that has just started — a quit and a fresh request can have replaced it entirely.
    final currentWork = _evaluationState.value.currentWork ?? _currentMoveWork;
    if (currentWork != null) _startWork(currentWork);
  }

  /// The spec for [flavor], falling back to SF 16 when the NNUE files are not on disk.
  Future<EngineSpec> _resolveSpec(StockfishFlavor flavor) async {
    switch (flavor) {
      case StockfishFlavor.variant:
        return const StockfishSpec.fairy();
      case StockfishFlavor.sf16:
        return const StockfishSpec.sf16();
      case StockfishFlavor.latestNoNNUE:
        if (await _nnueService.checkNNUEFiles()) {
          final files = _nnueService.nnueFiles;
          return StockfishSpec.latest(
            bigNetPath: files.bigNet.path,
            smallNetPath: files.smallNet.path,
          );
        }
        _logger.warning('NNUE files not found or corrupted. Falling back to SF16.');
        return const StockfishSpec.sf16();
    }
  }

  /// The flavor [work] needs: everything Stockfish does not know how to play goes to Fairy.
  StockfishFlavor _flavorFor(Work work) => officialStockfishVariants.contains(work.variant)
      ? work.stockfishFlavor
      : StockfishFlavor.variant;

  Future<void> _disposeEngine() async {
    final engine = _engine;
    if (engine == null) return;
    _engine = null;
    _engineFlavor = null;
    _accumulatingFor = null;
    engine.name.removeListener(_onEngineNameChange);
    engine.isSearching.removeListener(_onSearchingChange);
    await engine.dispose();
  }

  void _onEngineDeath(Engine engine, EngineFailure? failure) {
    // An engine this service has already let go of is not news: either it was disposed on purpose,
    // or the failure that killed it was reported when it was detected.
    if (!identical(_engine, engine) || failure == null) return;

    _handleFailure(failure.withContext(maxMemoryInMb: maxMemory));
    _failEngine();
  }

  /// Puts the service into [EngineState.error] and lets go of everything that was waiting on the
  /// engine.
  ///
  /// Nothing is going to answer the work that was in flight, so its callers are failed instead of
  /// being left waiting forever — a pending [findMove] has no timeout of its own. The engine is
  /// let go of too, so that the next [_startWork] starts a fresh one rather than talking to one
  /// this service already knows is unusable.
  void _failEngine() {
    _generation++;
    _cancelPendingMoveRequest();
    _setEvalWork(null);
    _currentMoveWork = null;
    _currentEval = null;
    _accumulatingFor = null;
    _cancelEvalThrottle();
    unawaited(_disposeEngine());
    _setEngineState(EngineState.error);
  }

  // ---------------------------------------------------------------------------
  // Searching
  // ---------------------------------------------------------------------------

  void _compute(Work work, {bool newGame = false}) {
    final engine = _engine;
    if (engine == null) return;

    final search = engine.search(_searchRequestFor(work, newGame: newGame));

    switch (work) {
      case final EvalWork evalWork:
        search.infos.listen((info) => _onSearchInfo(evalWork, search, info));
        unawaited(search.bestMove.then((_) => _onEvalSearchDone(evalWork, search)));
      case final MoveWork moveWork:
        unawaited(search.bestMove.then((move) => _onMoveSearchDone(moveWork, move)));
    }
  }

  SearchRequest _searchRequestFor(Work work, {required bool newGame}) {
    final threatMode = work is EvalWork && work.threatMode;
    return SearchRequest(
      initialPosition: work.initialPosition,
      moves: IList(work.steps.map((step) => step.sanMove.normalizeUci(work.variant))),
      variant: work.variant,
      limit: SearchLimit.movetime(work.searchTime),
      fenOverride: threatMode ? threatModePosition(work.position).fen : null,
      threads: work.threads,
      hashSize: work.hashSize ?? 16,
      multiPv: work.multiPv,
      // The complete option set for this search: whatever an evaluation does not name here — the
      // opponent's `Skill Level`, most of all — is put back to its default by the engine before
      // the search starts.
      options: switch (work) {
        final MoveWork moveWork => IMap({'Skill Level': moveWork.skill.toString()}),
        EvalWork() => const IMapConst({}),
      },
      newGame: newGame,
    );
  }

  /// Accumulates one `info` line into the evaluation of [work].
  void _onSearchInfo(EvalWork work, Search search, UciInfo info) {
    if (!identical(_accumulatingFor, search)) {
      _accumulatingFor = search;
      _currentEval = null;
      _expectedPvs = 1;
    }

    // Track max pv index to determine when pv prints are done.
    if (_expectedPvs < info.multiPv) _expectedPvs = info.multiPv;

    if (info.depth < minDepth && info.pv.isNotEmpty) return;

    final isMate = info.mate != null;
    final povEv = info.mate ?? info.cp!;

    final pivot = work.threatMode ? Side.black : Side.white;
    final ev = work.position.turn == pivot ? povEv : -povEv;

    // For now, ignore most upperbound/lowerbound messages.
    // However non-primary pvs may only have an upperbound.
    if ((info.isLowerBound || info.isUpperBound) && info.multiPv == 1) return;

    final pvData = PvData(moves: info.pv, cp: isMate ? null : ev, mate: isMate ? ev : null);

    if (info.multiPv == 1) {
      _currentEval = LocalEval(
        position: work.threatMode ? threatModePosition(work.position) : work.position,
        searchTime: info.elapsed,
        depth: info.depth,
        nodes: info.nodes,
        cp: isMate ? null : ev,
        mate: isMate ? ev : null,
        pvs: IList([pvData]),
        millis: info.elapsed.inMilliseconds,
        threatMode: work.threatMode,
      );
    } else if (_currentEval != null) {
      _currentEval = _currentEval!.copyWith(
        pvs: _currentEval!.pvs.add(pvData),
        depth: math.min(_currentEval!.depth, info.depth),
      );
    }

    if (info.multiPv == _expectedPvs && _currentEval != null) {
      _onEvalResult((work, _currentEval!));

      // Engines report past their own `movetime` — they only check the clock between nodes — so
      // the search is ended here rather than waited out.
      if (info.elapsed > work.searchTime) {
        search.stop();
      }
    }
  }

  void _onEvalSearchDone(EvalWork work, Search search) {
    if (!identical(_accumulatingFor, search)) return;
    // The engine's last word on this position, which the throttle may otherwise have swallowed.
    if (_currentEval case final eval?) _onEvalResult((work, eval));
  }

  void _onMoveSearchDone(MoveWork work, UCIMove? move) {
    // A superseded search has no move to report; whoever superseded it has already failed the
    // request that was waiting.
    if (move == null) return;
    if (!_moveController.isClosed) _moveController.add((work, move));
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

  // ---------------------------------------------------------------------------
  // Eval emission
  // ---------------------------------------------------------------------------

  /// Handles eval results with throttling.
  ///
  /// Implements trailing throttle: emits immediately if no throttle is active,
  /// otherwise stores the result to emit when the throttle window expires.
  void _onEvalResult(EvalResult result) {
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
    if (_evalController.isClosed) return;
    _evalController.add(result);
    final currentWork = _evaluationState.value.currentWork ?? _currentMoveWork;
    if (currentWork != null && result.$1 == currentWork) {
      _setEval(result.$2);
    }
  }

  void _cancelEvalThrottle() {
    _evalThrottleTimer?.cancel();
    _evalThrottleTimer = null;
    _pendingEvalResult = null;
  }

  // ---------------------------------------------------------------------------
  // Failure reporting
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // State bookkeeping
  // ---------------------------------------------------------------------------

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

  void _setState({
    EngineState? state,
    LocalEval? Function()? evalFn,
    EvalWork? Function()? workFn,
  }) {
    final current = _evaluationState.value;
    final newState = (
      engineName: _engine?.name.value,
      eval: evalFn != null ? evalFn() : current.eval,
      state: state ?? current.state,
      currentWork: workFn != null ? workFn() : current.currentWork,
    );
    if (current != newState) {
      _evaluationState.value = newState;
    }
  }

  void _onSearchingChange() {
    final engine = _engine;
    if (engine == null) return;
    _setEngineState(engine.isSearching.value ? EngineState.computing : EngineState.idle);
  }

  void _onEngineNameChange() {
    // engineName is always read from the engine in _setState, so this just triggers an update.
    _setState();
  }

  void _dispose() {
    _generation++;
    _cancelEvalThrottle();
    _cancelPendingMoveRequest();
    _currentMoveWork = null;
    unawaited(_disposeEngine());
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
