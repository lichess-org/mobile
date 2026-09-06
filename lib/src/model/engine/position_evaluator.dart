import 'dart:async';
import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_budget.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_providers.dart';
import 'package:lichess_mobile/src/model/engine/engine_slot.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_context.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

final _logger = Logger('PositionEvaluator');

const kEngineEvalEmissionThrottleDelay = Duration(milliseconds: 200);

/// The shallowest depth worth reporting. Below it the engine is still guessing.
const minDepth = 6;

/// How long a paused evaluator keeps the engine it is not using.
const kEnginePauseDelay = Duration(seconds: 3);

/// The minimum delay between two engine failure messages shown to the user.
const _kUserNotificationThrottle = Duration(seconds: 10);

/// The message shown to the user when the engine is gone for good.
const _kUnrecoverableEngineMessage =
    'The chess engine stopped responding. Please restart the app to use it again.';

/// The evaluator for one [EvaluationContext] — one game, study, puzzle or offline game.
///
/// Per context rather than app-wide, so results never have to be demultiplexed: a screen watching
/// its own evaluator cannot see another screen's evaluation, and the engine underneath is shared
/// through [engineProvider] rather than by sharing the evaluator.
final positionEvaluatorProvider = NotifierProvider.autoDispose
    .family<PositionEvaluator, EngineEvaluationState, EvaluationContext>(
      PositionEvaluator.new,
      name: 'PositionEvaluatorProvider',
    );

/// The flavor the evaluator will use for [variant].
///
/// The user's preference, except for the variants Stockfish does not know how to play, which only
/// Fairy-Stockfish can evaluate. Read when the work starts rather than carried on it, so that
/// changing the preference is picked up by the next evaluation wherever it comes from.
StockfishFlavor evaluatorFlavorFor(Ref ref, Variant variant) =>
    officialStockfishVariants.contains(variant)
    ? ref.read(engineEvaluationPreferencesProvider).enginePref.flavor
    : StockfishFlavor.variant;

/// The engine the evaluator will run [variant] on.
///
/// The slot rather than the [EngineSpec] because resolving a spec is asynchronous — it depends on
/// whether the NNUE files are on disk — while the caller needs the answer now, in order to build a
/// search request. What it is asked is whether some other role shares the evaluator's engine, and
/// the slot settles that: the `latestNoNNUE` → `sf16` fallback can make this name the wrong
/// Stockfish, but only a variant ever resolves to Fairy.
EngineSlot evaluatorEngineSlotFor(Ref ref, Variant variant) =>
    switch (evaluatorFlavorFor(ref, variant)) {
      StockfishFlavor.variant => EngineSlot.fairy,
      StockfishFlavor.sf16 => EngineSlot.sf16,
      StockfishFlavor.latestNoNNUE => EngineSlot.sfLatest,
    };

/// Evaluates positions for analysis.
///
/// It does not play moves, does not start engines, and does not know what a skill level is: an
/// opponent is [EngineOpponent], and the engine is [engineProvider]'s to own.
///
/// Only one evaluation runs at a time; a new request takes over from whatever was running ("last
/// caller wins").
class PositionEvaluator extends Notifier<EngineEvaluationState> {
  PositionEvaluator(this.context);

  /// What is being evaluated: a game, a study, a puzzle.
  final EvaluationContext context;

  /// What the UI sees before anything has been asked of the engine.
  static const defaultState = (engine: null, eval: null, isComputing: false, currentWork: null);

  @override
  EngineEvaluationState build() {
    ref.onDispose(_dispose);
    return defaultState;
  }

  /// How this device's engines share it.
  EngineBudget get budget => ref.read(engineBudgetProvider);

  StockfishNnueService get _nnueService => ref.read(stockfishNnueServiceProvider);

  /// The live engine, or null while there is none.
  Engine? _engine;

  /// The spec [_engineSubscription] is watching, or null when nothing is.
  EngineSpec? _spec;

  /// What keeps the engine alive. Closing it is the whole of letting go of an engine: the provider
  /// disposes it once the grace window passes with nobody else watching.
  ProviderSubscription<AsyncValue<Engine>>? _engineSubscription;

  /// The flavor [_spec] was resolved from.
  ///
  /// The *requested* flavor, not the effective one, so that a latestNoNNUE→sf16 fallback does not
  /// make every later latestNoNNUE request look like a change of engine. The variant is not part
  /// of this: it is a per-search option now, so two variants share one Fairy-Stockfish engine.
  StockfishFlavor? _engineFlavor;

  /// Set while the spec for a flavor is being resolved, which is async because it depends on
  /// whether the NNUE files are on disk.
  bool _resolvingSpec = false;

  /// Whether the user has turned the engine off with [release].
  ///
  /// A paused evaluator still holds its engine, but says nothing about it: the UI's view of the
  /// engine is what the button shows, and there is nothing to show for an engine nobody asked for.
  bool _paused = false;

  /// What lets go of a paused engine nobody turned back on, after [kEnginePauseDelay].
  Timer? _pauseTimer;

  /// Distinguishes the engine the service is currently interested in from one a [quit] or a
  /// failure has already let go of, so that a resolution still in flight cannot resurrect it.
  int _generation = 0;

  /// The search whose `info` lines are being accumulated into [_currentEval].
  ///
  /// Tracked rather than assumed, because a search that has been superseded goes on reporting
  /// until its own `bestmove`: the accumulation belongs to whichever search the engine is actually
  /// answering, and is started over when a different one starts to speak.
  Search? _accumulatingFor;

  /// The search this evaluator started, so that stopping stops only its own work: the engine
  /// underneath is shared, and an offline game's opponent may be thinking on it.
  Search? _currentSearch;

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

  final _evalController = StreamController<EvalResult>.broadcast();

  /// Stream of evaluation results tagged with their [EvalWork].
  ///
  /// Listeners should filter results by comparing the Work to their own request
  /// to determine if the result is relevant to them.
  ///
  /// This stream is throttled to avoid excessive UI updates.
  Stream<EvalResult> get evalStream => _evalController.stream;

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
      'multiPv=${work.multiPv}, cores=${work.threads}, '
      'searchTime=${work.searchTime.inMilliseconds}ms, threatMode=${work.threatMode}',
    );

    _startWork(work);

    return evalStream.where((result) => result.$1 == work);
  }

  /// The work being evaluated, if any.
  EvalWork? get currentWork => state.currentWork;

  /// Stops the current evaluation.
  ///
  /// The engine stops computing further but the evaluation state is not cleared: it goes on
  /// reporting until its `bestmove`, and that last word on the position is worth having.
  void stop() {
    _currentSearch?.stop();
    _setEvalWork(null);
  }

  /// Stops evaluating, keeping the engine for a moment.
  ///
  /// Called when the user turns the engine off. The engine is kept — attached, idle, and reporting
  /// nothing — for [kEnginePauseDelay], so that flicking the button off and on is free: letting go
  /// of it on the first tap would quit an engine the second one starts again, and the plugin makes
  /// that start wait for the quit it follows. Nobody turning it back on within the window lets go
  /// of it for real, as leaving the screen does.
  void release() {
    if (_spec == null && !_resolvingSpec) {
      _logger.fine('Engine already released or never asked for. Ignoring duplicate release call.');
      return;
    }
    _logger.info('Pausing the engine');
    _paused = true;
    _currentSearch?.stop();
    _currentSearch = null;
    _cancelEvalThrottle();
    _currentEval = null;
    _accumulatingFor = null;

    _pauseTimer?.cancel();
    _pauseTimer = Timer(kEnginePauseDelay, () {
      _pauseTimer = null;
      _logger.info('Releasing the engine nobody turned back on');
      _releaseEngine();
    });

    if (ref.mounted) state = defaultState;
  }

  // ---------------------------------------------------------------------------
  // Engine lifecycle
  // ---------------------------------------------------------------------------

  /// Starts the given [work], asking for a different engine first if it needs one.
  void _startWork(EvalWork work) {
    // Work asked for means the engine is wanted again, whatever [release] did.
    _paused = false;
    _pauseTimer?.cancel();
    _pauseTimer = null;

    if (_unrecoverableFailure case final failure?) {
      _logger.severe('Refusing engine work: the engine is unusable. $failure');
      _abandonPendingWork();
      _releaseEngine();
      _setEngine(AsyncError(failure, StackTrace.current));
      _notifyUser(failure);
      return;
    }

    _setEvalWork(work);

    final flavor = _flavorFor(work.variant);

    if (_engineFlavor == flavor) {
      // Already asking for the right engine. It may not be ready yet, in which case the work runs
      // when it is.
      if (_engine case final engine?) {
        // A pause hid the engine rather than letting go of it, so coming back is a matter of
        // saying which one it is again and searching on it.
        _setEngine(AsyncData(engine.name.value));
        _compute(work);
      }
      return;
    }

    if (_resolvingSpec) {
      _logger.fine('Work requested while the engine is being chosen; it will run when it is ready');
      return;
    }

    unawaited(_acquireEngine(flavor));
  }

  /// Points the service at the engine [flavor] needs, and lets go of the previous one.
  Future<void> _acquireEngine(StockfishFlavor flavor) async {
    final generation = _generation;
    _resolvingSpec = true;
    _setEngine(const AsyncLoading());

    try {
      final spec = await _resolveSpec(flavor);
      if (generation != _generation) return;

      _logger.fine('Using engine: $spec, budget: $budget');
      _engineFlavor = flavor;
      _watchEngine(spec);
    } finally {
      if (generation == _generation) _resolvingSpec = false;
    }
  }

  /// Subscribes to [spec]'s engine, replacing whatever was subscribed to before.
  void _watchEngine(EngineSpec spec) {
    if (_spec == spec) return;

    _detachEngine();
    _engineSubscription?.close();
    _spec = spec;
    _engineSubscription = ref.listen<AsyncValue<Engine>>(
      engineProvider(spec),
      (_, next) => _onEngineChanged(spec, next),
      fireImmediately: true,
    );
  }

  void _onEngineChanged(EngineSpec spec, AsyncValue<Engine> value) {
    // An update for an engine this service has already moved on from.
    if (_spec != spec) return;

    if (value case AsyncError(:final error, :final stackTrace)) {
      _detachEngine();
      _handleFailure(_asFailure(error, stackTrace, spec));
      _releaseEngine(invalidate: true);
      _setEngine(AsyncError(error, stackTrace));
      _abandonPendingWork();
      return;
    }

    if (value.value case final Engine engine) {
      _attachEngine(engine);
      _computeCurrentWork();
      return;
    }

    _detachEngine();
    _setEngine(const AsyncLoading());
  }

  void _attachEngine(Engine engine) {
    if (identical(_engine, engine)) return;
    _detachEngine();
    _engine = engine;
    engine.name.addListener(_onEngineNameChange);
    engine.isSearching.addListener(_onSearchingChange);
    _setEngine(AsyncData(engine.name.value));
  }

  void _detachEngine() {
    final engine = _engine;
    if (engine == null) return;
    _engine = null;
    _accumulatingFor = null;
    engine.name.removeListener(_onEngineNameChange);
    engine.isSearching.removeListener(_onSearchingChange);
  }

  /// Lets go of the engine.
  ///
  /// The engine itself is not quit here: the provider disposes it once the grace window passes
  /// with nobody watching, which is what lets one analysis screen hand its engine to the next.
  /// [invalidate] skips that, for an engine that is already broken.
  void _releaseEngine({bool invalidate = false}) {
    _pauseTimer?.cancel();
    _pauseTimer = null;

    // The engine outlives this release, so it must not be left evaluating for a screen that is
    // gone — but it is shared, so only this evaluator's own search is stopped.
    _currentSearch?.stop();
    _currentSearch = null;
    _detachEngine();
    _engineSubscription?.close();
    _engineSubscription = null;
    final spec = _spec;
    _spec = null;
    _engineFlavor = null;
    _resolvingSpec = false;
    if (invalidate && spec != null) ref.invalidate(engineProvider(spec));
  }

  EngineFailure _asFailure(Object error, StackTrace stackTrace, EngineSpec spec) => switch (error) {
    final EngineCreationException creation => creation.failure,
    final EngineFailure failure => failure,
    _ => EngineFailure(
      kind: EngineFailureKind.start,
      message: 'The engine failed to start',
      engine: spec.label,
      error: error,
      stackTrace: stackTrace,
    ),
  }.withContext(maxMemoryInMb: budget.maxMemoryInMb);

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

  /// The flavor to evaluate [variant] with.
  StockfishFlavor _flavorFor(Variant variant) => evaluatorFlavorFor(ref, variant);

  /// Runs whatever work is current on the engine that has just become available.
  void _computeCurrentWork() {
    final work = state.currentWork;
    if (work != null) _startWork(work);
  }

  /// Lets go of the work that was waiting on an engine that is not coming back.
  void _abandonPendingWork() {
    _generation++;
    _setEvalWork(null);
    _currentEval = null;
    _accumulatingFor = null;
    _cancelEvalThrottle();
  }

  // ---------------------------------------------------------------------------
  // Searching
  // ---------------------------------------------------------------------------

  void _compute(EvalWork work) {
    final engine = _engine;
    if (engine == null) return;

    final search = engine.search(_searchRequestFor(work));
    _currentSearch = search;

    search.infos.listen((info) => _onSearchInfo(work, search, info));
    unawaited(search.bestMove.then((_) => _onEvalSearchDone(work, search)));
  }

  SearchRequest _searchRequestFor(EvalWork work) {
    final threatMode = work.threatMode;
    return SearchRequest(
      initialPosition: work.initialPosition,
      moves: IList(work.steps.map((step) => step.sanMove.normalizeUci(work.variant))),
      variant: work.variant,
      limit: SearchLimit.movetime(work.searchTime),
      fenOverride: threatMode ? threatModePosition(work.position).fen : null,
      threads: work.threads,
      multiPv: work.multiPv,
      // Nothing beyond the defaults: an evaluation names no options of its own, so the engine puts
      // back whatever the opponent set — its `Skill Level`, most of all — before this search runs.
      //
      // The context is the game: one evaluator evaluates one game, study chapter or puzzle, and it
      // is the engine underneath that is shared with the screen the user was on a moment ago.
      game: context,
    );
  }

  /// Accumulates one `info` line into the evaluation of [work].
  void _onSearchInfo(EvalWork work, Search search, UciInfo info) {
    // The engine has been let go of: whatever it is still saying is for nobody.
    if (_engine == null) return;

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
    if (result.$1 == state.currentWork) _setEval(result.$2);
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
      final navigatorContext = ref.read(currentNavigatorKeyProvider).currentContext;
      if (navigatorContext == null || !navigatorContext.mounted) return;

      showSnackBar(navigatorContext, _kUnrecoverableEngineMessage, type: SnackBarType.error);
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

  void _setEngine(AsyncValue<String?> engine) {
    // A paused evaluator keeps its engine but shows none: see [release].
    if (_paused) return;
    _setState(engineFn: () => engine);
  }

  void _setEval(LocalEval? eval) {
    _setState(evalFn: () => eval);
  }

  void _setEvalWork(EvalWork? work) {
    _setState(workFn: () => work);
  }

  void _setState({
    AsyncValue<String?>? Function()? engineFn,
    LocalEval? Function()? evalFn,
    EvalWork? Function()? workFn,
  }) {
    if (!ref.mounted) return;
    final current = state;
    final newState = (
      engine: engineFn != null ? engineFn() : current.engine,
      eval: evalFn != null ? evalFn() : current.eval,
      isComputing: _engine?.isSearching.value ?? false,
      currentWork: workFn != null ? workFn() : current.currentWork,
    );
    if (current != newState) state = newState;
  }

  void _onSearchingChange() => _setState();

  void _onEngineNameChange() {
    final engine = _engine;
    if (engine == null) return;
    _setEngine(AsyncData(engine.name.value));
  }

  void _dispose() {
    _generation++;
    _cancelEvalThrottle();
    _releaseEngine();
    _evalController.close();
  }
}

/// A record type holding the current engine evaluation state.
typedef EngineEvaluationState = ({
  /// The engine backing the evaluation.
  ///
  /// Null when none has been asked for, [AsyncLoading] while one is starting, its `id name` once
  /// it is ready, and [AsyncError] when it could not start or has died. This is the whole of the
  /// engine's lifecycle as the UI sees it — there is no separate state machine to keep in step.
  AsyncValue<String?>? engine,
  LocalEval? eval,

  /// Whether the engine is searching right now.
  bool isComputing,

  EvalWork? currentWork,
});

/// The evaluation state for [filters], with results for other paths filtered out.
///
/// The identity filtering another screen's results used to need is structural now — evaluators are
/// per [EvaluationContext] — so all that is left is the path: a widget showing the eval of one node
/// must not show the eval of the node the user has just moved on to.
final engineEvaluationProvider = Provider.autoDispose
    .family<EngineEvaluationState, EngineEvaluationFilters>((ref, filters) {
      final state = ref.watch(positionEvaluatorProvider(filters.context));
      final work = state.currentWork;
      if (work == null || filters.path == null || work.path == filters.path) return state;
      return PositionEvaluator.defaultState;
    }, name: 'EngineEvaluationProvider');

/// A type for filtering engine evaluation notifications.
typedef EngineEvaluationFilters = ({EvaluationContext context, UciPath? path});
