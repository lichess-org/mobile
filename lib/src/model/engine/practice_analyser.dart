import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase_eval.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase_repository.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PracticeAnalyser');

/// The depth at which an evaluation is good enough to show a hint or judge a move.
///
/// Lower-end devices may not reach it before the search time runs out, in which case whatever the
/// search did reach is used instead — it is a threshold for unlocking, not a requirement.
// TODO: consider using searched nodes instead of depth
const kPracticeUsableDepth = kDebugMode ? 13 : 15;

/// The depth at which the search stops and lets the engine idle.
///
/// Not infinite: the analysis runs for as long as the player thinks, and an engine searching for
/// minutes on end is a battery and thermal problem the old burst model never had. Kept close to
/// [kPracticeUsableDepth] for the same reason — the last few plies of a practice-game eval change
/// the hint almost never, and cost more battery than everything before them put together.
const kPracticeTargetDepth = kDebugMode ? 18 : 20;

/// How many times a search is started again when it ends without a usable eval.
///
/// Small on purpose: a device that cannot reach [kPracticeUsableDepth] in three windows of
/// [kPracticeMaxSearchTime] is not going to, and the chapter is better left without an eval than
/// with an engine running on a loop.
const _kMaxRestarts = 3;

/// The ply past which a cloud eval is a miss far more often than a hit.
///
/// Only consulted when the caller has not said its positions are always worth asking for: see
/// [PracticeAnalyser.alwaysRequestCloudEvals].
const _kCloudEvalPlyThreshold = 30;

/// How long a cloud eval request waits for the server's answer before the search is left to it.
const _kCloudEvalTimeout = Duration(seconds: 2);

/// The wall-clock cap on analysing one position, for a device that would never reach either depth.
///
/// Short, because it is a battery cap and not a quality one: a device still searching after this
/// long is not about to find something better, and the player is waiting on the hint behind it.
const kPracticeMaxSearchTime = Duration(seconds: 5);

/// The cap on a wait whose search has not started yet.
///
/// [kPracticeMaxSearchTime] is search time and nothing else — the engine counts it from the moment
/// it starts searching — so spawning the process and loading its network come before it rather
/// than out of it, and on a cold device that is seconds. A wait is therefore not given its own
/// deadline until the engine has said something about the position; this is what bounds it until
/// then, for an engine that is never going to start at all.
const kPracticeEngineStartWait = Duration(seconds: 15);

/// Keeps an evaluation running on the position the game is at, for as long as it is worth running.
///
/// This is the practice-mode *policy* that [PositionEvaluator] deliberately has none of: how deep
/// is deep enough to show a hint, how deep is deep enough to stop, and who has the engine. The
/// evaluator underneath still only knows how to evaluate a position.
///
/// Two depths, because they answer different questions. Hints and move feedback unlock at
/// [kPracticeUsableDepth] so the player is not kept waiting; the search then runs on to
/// [kPracticeTargetDepth], refining the eval while the player thinks — which is the whole point:
/// their thinking time becomes engine time instead of idle time.
///
/// The local search is not alone: every position analysed is also asked of the server — a cloud
/// eval, and a tablebase lookup in an endgame — and whatever comes back first and deepest wins.
class PracticeAnalyser({
  /// Where the network lookups are made from, and what says whether the owner is still there.
  required final Ref ref,

  /// The evaluator to run on.
  ///
  /// A function rather than the evaluator itself, because it is keyed by the game being played and
  /// is resolved lazily by the controller that owns both.
  required final PositionEvaluator Function() evaluator,

  /// Whether every position analysed is worth asking the server about, whatever its ply.
  required final bool alwaysRequestCloudEvals,

  /// Called whenever a position's evaluation improves, so the game can store it.
  required final void Function(Position position, ClientEval eval) onEval,
}) {
  /// The work being analysed, or null when nothing is.
  EvalWork? _analysing;

  /// The position the engine has reported on, or null when it has not reported on any.
  ///
  /// What tells a wait on a search that is running from a wait on an engine that is still starting
  /// up.
  Position? _engineSpokeFor;

  /// The work [_restarts] counts for, since a restart clears [_analysing] on its way through.
  EvalWork? _restartedWork;

  /// How many times that work has been started again after its search ended too early.
  int _restarts = 0;

  StreamSubscription<EvalResult>? _subscription;

  /// The best evaluation seen for each position of this game.
  final Map<Position, ClientEval> _evals = {};

  final Map<Position, List<_Waiter>> _waiters = {};

  /// The positions the server has already been asked about, so that two searches on the same
  /// position do not each pay for the round trip.
  final Set<Position> _raced = {};

  /// Bumped every time everything known is thrown away.
  ///
  /// What tells a lookup coming back from the server that the game it was asked for is not the one
  /// being played any more: a network round trip outlives a [clear] easily, and an answer landing
  /// after one would put back an evaluation the retry was there to forget.
  int _epoch = 0;

  /// The socket [_socketSubscription] is held on, or null when there is none.
  SocketClient? _socketClient;

  StreamSubscription<SocketEvent>? _socketSubscription;

  bool _disposed = false;

  /// Whether an analysis is running.
  bool get isAnalysing => _analysing != null;

  /// The best evaluation known for [position], however shallow.
  ClientEval? evalFor(Position position) => _evals[position];

  /// Analyses the position [work] describes, replacing whatever was being analysed.
  ///
  /// Does nothing if that position is already being analysed, or if it has already been analysed
  /// deeply enough that there is nothing left to learn about it.
  void analyse(EvalWork work) {
    // The evaluator is asked as well, rather than trusted to be running whatever it was last
    // given: it drops the work on its own when the engine fails, and an analyser that took its
    // own record for the truth would refuse to ask for this position ever again.
    if (_analysing == work && evaluator().currentWork == work) return;

    _raceTheSearch(work);

    final known = _evals[work.position];
    if (known != null && _isFinal(known)) {
      _stopSearch();
      _publish(work.position, known);
      _strandWaiters(work.position);
      return;
    }

    _logger.fine('Analysing ply ${work.position.ply}');
    _stopSearch(resumingOn: work.position);
    _analysing = work;

    final stream = evaluator().evaluate(work);
    if (stream == null) {
      // The evaluator had a good enough eval cached and started nothing.
      _analysing = null;
      final cached = work.evalCache;
      if (cached != null) _record(work.position, cached);
      _strandWaiters(work.position);
      return;
    }

    _subscription = stream.listen((result) {
      // The stream is filtered on this work, so a result can only ever be for it; what is worth
      // asking is whether it is still the work being analysed.
      if (_analysing != work) return;
      final (_, eval) = result;
      // The engine has spoken, so it is searching rather than starting up, and a wait on this
      // position is now a wait on the search: its own deadline can start.
      _engineSpoke(work.position);
      _record(work.position, eval);
      // Asked again rather than taken from the check above: recording an eval reports it to the
      // owner, which may well have moved the analysis on by now, and what is worth stopping is the
      // search that is running rather than the one this result came from.
      if (_analysing == work && _isFinal(eval)) {
        _logger.fine('Reached the target depth at ply ${work.position.ply}; the engine can idle');
        _stopSearch();
      }
    });
  }

  /// Takes in the evaluator's state, which is how the analysis hears that the engine has stopped.
  ///
  /// The owner has that subscription anyway — it is what keeps the evaluator alive — so it passes
  /// the state through rather than working out which change matters, which is a question about the
  /// analysis and belongs here with [resumeIfUnfinished].
  void onEvaluatorStateChanged(EngineEvaluationState? previous, EngineEvaluationState next) {
    if (previous?.isComputing == true && !next.isComputing) resumeIfUnfinished();
  }

  /// Starts the search again when it stopped before the position was understood at all.
  ///
  /// The search is capped at [kPracticeMaxSearchTime] but that cap is meant to stop an eval being
  /// *refined*, not to leave a position without one.
  ///
  /// Called when the engine stops searching, which is what [onEvaluatorStateChanged] watches for.
  void resumeIfUnfinished() {
    final work = _analysing;
    if (work == null) return;
    final known = _evals[work.position];
    if (known != null && _isUsable(known)) return;
    if (_restartedWork != work) {
      _restartedWork = work;
      _restarts = 0;
    }
    if (_restarts >= _kMaxRestarts) {
      _logger.warning(
        'Giving up on ply ${work.position.ply} after $_restarts restarts without a usable eval',
      );
      // The search that was running is left alone: it has said its last word to the engine, but
      // that word may still be on its way through the evaluator's throttle, and it is the only one
      // this position is going to get.
      return;
    }
    _restarts++;
    _logger.info(
      'The search at ply ${work.position.ply} ended at depth ${known?.depth ?? 0} without a usable '
      'eval; starting it again ($_restarts)',
    );
    // Cleared so that `analyse` does not take this work for one already running.
    _analysing = null;
    analyse(work);
  }

  /// Takes in an evaluation that came from somewhere else — a cloud eval, a tablebase lookup.
  ///
  /// Kept if it is deeper than what the search has reached, and it ends the search when it is
  /// deeper than anything the search would have reached.
  void offer(Position position, ClientEval eval) {
    if (_disposed || !ref.mounted) return;
    if (!_record(position, eval)) return;
    if (_isFinal(eval) && _analysing?.position == position) {
      _logger.fine('An eval from elsewhere beat the search at ply ${position.ply}');
      _stopSearch();
    }
  }

  /// Gives the engine up: the opponent needs it, or the game is over, or the screen has gone away.
  ///
  /// Nothing is remembered to be restarted, because what should run next is a question about the
  /// position the game is at when the engine comes back, not about the search that was given up.
  /// [analyse] is how it comes back.
  void yieldEngine() {
    // The restarts already spent are part of what is not remembered: they count what one search on
    // one position was given, and the engine coming back is a fresh go at whatever position the
    // game is at by then — on an engine that is warm now, where the restarts went on starting it.
    _restartedWork = null;
    _restarts = 0;
    final analysing = _analysing;
    if (analysing == null) return;
    _logger.fine('Yielding the engine at ply ${analysing.position.ply}');
    _stopSearch();
  }

  /// Forgets every evaluation made so far, and gives the engine up.
  ///
  /// For starting or loading another game, and for replaying the same one from the start: an
  /// evaluation kept across a retry would hand the player the same answer to the same move again.
  void clear() {
    // Which gives up the engine, and with it the restarts spent on the search that had it.
    yieldEngine();
    _epoch++;
    _evals.clear();
    _raced.clear();
    _engineSpokeFor = null;
    // With nothing to hand out: an eval of the game that was is exactly what this is forgetting.
    _completeAll(handOutEvals: false);
  }

  /// The evaluation of [position] once it is at least [minDepth] deep and says what to play.
  ///
  /// Completes at once when it already is — which, with the analysis running throughout the
  /// player's turn, is the ordinary case. Otherwise it completes with the first eval that answers
  /// for it, or, when [timeout] passes first, with the best one reached by then — which is the
  /// best there is rather than one that answers, so it may be shallower than [minDepth] or have no
  /// move to play, and is null when the search produced nothing at all.
  ///
  /// [timeout] is given to the search, and only starts once there is one: until the engine has
  /// said something about the position it may still be starting up, which is not time the search
  /// is spending and not time this is willing to hold against it. [kPracticeEngineStartWait] is
  /// what bounds the wait until then — and only an engine that is still on its way, since a
  /// position the analysis gives up on before the engine ever speaks ends its waits there and
  /// then.
  ///
  /// [minDepth] defaults to [kPracticeUsableDepth], which is what unlocking a hint asks for.
  /// Judging a move the player has already played is allowed to ask for more: nobody is waiting on
  /// a board for it, and the verdict is worth more than the promptness.
  ///
  /// The caller is expected to have [analyse]d the position: nothing here starts a search.
  Future<ClientEval?> usableEval(
    Position position, {
    required Duration timeout,
    int minDepth = kPracticeUsableDepth,
  }) {
    final known = _evals[position];
    if (known != null && _satisfies(known, minDepth)) return Future.value(known);

    final waiter = _Waiter(minDepth, timeout, (waiter) {
      final deadline = waiter.started ? timeout : kPracticeEngineStartWait;
      _dropWaiters(position, (other) => identical(other, waiter));
      _logger.info('No usable eval at ply ${position.ply} within ${deadline.inMilliseconds}ms');
      waiter.complete(_evals[position]);
    });
    (_waiters[position] ??= []).add(waiter);

    // Anything else — a position the analysis is not on, an engine that has already spoken, a
    // search the evaluator has dropped — is a wait on the caller's own deadline.
    if (_engineSpokeFor != position && _isEngineOnItsWayTo(position)) {
      waiter.waitForTheEngine();
    } else {
      waiter.start();
    }

    return waiter.future;
  }

  /// Lets go of everything, without touching the evaluator.
  ///
  /// Called from the owner's disposal, where the evaluator is being disposed too and reaching for
  /// it is not allowed — a provider may not be read from a life-cycle callback.
  void dispose() {
    _disposed = true;
    _stopSearch(stopEngine: false);
    _socketSubscription?.cancel();
    _socketSubscription = null;
    _socketClient = null;
    _completeAll();
    _evals.clear();
    _raced.clear();
  }

  /// Whether an engine is on its way to [position], which is what [kPracticeEngineStartWait] is
  /// there to bound.
  ///
  /// The analysis being on the position is not enough on its own: the evaluator drops the work when
  /// the engine will not run at all, and a wait for an engine that is never coming is one nothing
  /// but its own deadline will ever end.
  bool _isEngineOnItsWayTo(Position position) {
    final analysing = _analysing;
    if (analysing == null || analysing.position != position) return false;
    if (_disposed || !ref.mounted) return false;
    return evaluator().currentWork == analysing;
  }

  /// Asks the server for the evaluations that would beat the search: a cloud eval in the opening —
  /// or at any ply when [alwaysRequestCloudEvals] — and a tablebase lookup in an endgame. Whatever
  /// comes back is offered to the analysis.
  void _raceTheSearch(EvalWork work) {
    if (!kPracticeCloudEvalsEnabled || _disposed) return;

    final position = work.position;

    // Nothing to beat: this position has already been analysed as deeply as it is going to be.
    if (_evals[position] case final known? when _isFinal(known)) return;

    // Already asked about. A second search on the same position — a takeback replayed, the screen
    // coming back — would otherwise pay for the round trip all over again.
    if (_raced.contains(position)) return;

    final wantsCloudEval =
        work.variant == Variant.standard &&
        (alwaysRequestCloudEvals || position.ply < _kCloudEvalPlyThreshold);
    final wantsTablebase = isTablebaseRelevant(position);
    if (!wantsCloudEval && !wantsTablebase) return;

    _raced.add(position);
    final epoch = _epoch;

    // Offered one by one rather than once both are in: in an endgame lesson the two are asked
    // together, and the search has no reason to wait on the slower of them.
    Future<ClientEval?> ask(Future<ClientEval?> request) => request.then((eval) {
      if (eval != null && epoch == _epoch) offer(position, eval);
      return eval;
    });

    Future.wait([
          if (wantsCloudEval) ask(_getCloudEval(work)),
          if (wantsTablebase) ask(_fetchTablebaseEval(position)),
        ])
        .then((evals) {
          // A [clear] since. The attempt belongs to the game that was, and so does the record of
          // it: another one has since been made, or will be, for the game being played now.
          if (epoch != _epoch) return;
          // Nothing answered: no network, or a position the server has never seen. The attempt is
          // forgotten, so that analysing this position again asks again.
          if (evals.every((eval) => eval == null)) _raced.remove(position);
        })
        // Everything either lookup can fail on is caught where it happens, so this is here for
        // what [offer] reports the evaluation to rather than for the lookups themselves — and a
        // throw from there is no reason to leave an unhandled error behind.
        .catchError((Object e, StackTrace st) {
          _logger.warning('Could not offer an eval from the server:', e, st);
        });
  }

  /// The socket the cloud evals go over.
  SocketClient? get _socket {
    if (_disposed || !ref.mounted) return null;
    final client = ref.read(socketPoolProvider).open(AnalysisController.socketUri);
    // Held so that the pool does not let go of the connection between two requests. A client the
    // pool has replaced leaves its subscription behind on a stream that is closed for good.
    if (!identical(_socketClient, client)) {
      _socketSubscription?.cancel();
      _socketClient = client;
      _socketSubscription = client.stream.listen((_) {});
    }
    return client;
  }

  /// Asks the server for its evaluation of the position [work] describes.
  ///
  /// Returns null when the server has none, or does not answer within [_kCloudEvalTimeout].
  Future<CloudEval?> _getCloudEval(EvalWork work) async {
    final socketClient = _socket;
    if (socketClient == null) return null;

    try {
      final uciPath = UciPath.fromUciMoves(
        work.steps.map((s) => s.sanMove.normalizeUci(work.variant)),
      );

      _logger.fine(
        'Requesting cloud eval for ply ${work.position.ply} and fen ${work.position.fen}',
      );

      socketClient.send('evalGet', {
        'fen': work.position.fen,
        'path': uciPath.value,
        if (work.position.rule != Rule.chess) 'variant': Variant.fromRule(work.position.rule).name,
        'mpv': work.multiPv,
      });

      await for (final event
          in socketClient.stream.where((e) => e.topic == 'evalHit').timeout(_kCloudEvalTimeout)) {
        final path = pick(event.data, 'path').asStringOrThrow();
        if (path != uciPath.value) continue;

        final nodes = pick(event.data, 'knodes').asIntOrThrow() * 1000;
        final depth = pick(event.data, 'depth').asIntOrThrow();
        final pvs = pick(event.data, 'pvs')
            .asListOrThrow(
              (pv) => PvData(
                moves: pv('moves').asStringOrThrow().split(' ').toIList(),
                cp: pv('cp').asIntOrNull(),
                mate: pv('mate').asIntOrNull(),
              ),
            )
            .toIList();

        _logger.fine('Got a cloud eval at ply ${work.position.ply} with depth $depth');

        return CloudEval(depth: depth, nodes: nodes, pvs: pvs, position: work.position);
      }
    } catch (e, st) {
      _logger.fine('Could not get cloud eval:', e, st);
    }

    return null;
  }

  /// The tablebase evaluation of [position], or null when the lookup fails or is not conclusive.
  Future<ClientEval?> _fetchTablebaseEval(Position position) async {
    if (_disposed || !ref.mounted) return null;
    try {
      final entry = await ref
          .read(tablebaseRepositoryProvider)
          .getTablebaseEntry(position.fen, Variant.fromRule(position.rule));
      return tablebaseEntryToCloudEval(entry, position);
    } catch (e, st) {
      _logger.fine('Could not get tablebase eval:', e, st);
      return null;
    }
  }

  /// Whether [eval] answers a question asked of a [minDepth]-deep evaluation.
  ///
  /// Depth alone does not settle it. An evaluation that does not say what to play settles nothing:
  /// both the hint and the opponent's reply are read off the move, so a position whose only
  /// evaluation is moveless — a tablebase entry that listed none, a cloud eval whose variation
  /// came back empty — is one the search still has work to do on, however deep that evaluation
  /// claims to be.
  bool _satisfies(ClientEval eval, int minDepth) => eval.depth >= minDepth && eval.bestMove != null;

  /// Whether [eval] is enough to show a hint or judge a move.
  bool _isUsable(ClientEval eval) => _satisfies(eval, kPracticeUsableDepth);

  /// Whether there is nothing left to learn about the position [eval] is of.
  bool _isFinal(ClientEval eval) => _satisfies(eval, kPracticeTargetDepth);

  /// Keeps [eval] if it is an improvement, and tells everyone waiting on it. Returns whether it
  /// was kept.
  bool _record(Position position, ClientEval eval) {
    final known = _evals[position];
    if (known != null && !_isImprovement(eval, on: known)) return false;
    _publish(position, eval);
    return true;
  }

  /// Whether [eval] is worth keeping over [on], the best known so far.
  ///
  /// Depth decides it between two evals that both say what to play. One that does not leaves the
  /// position scored and unplayable — no hint, and no move for the opponent to answer with — so a
  /// tablebase entry that listed no moves, or a cloud eval whose variation came back empty, never
  /// buries an eval that has a move, and never keeps one out either however much shallower it is.
  /// The search runs on for that move; taking it when it arrives is what the search is for.
  bool _isImprovement(ClientEval eval, {required ClientEval on}) {
    if ((eval.bestMove != null) != (on.bestMove != null)) return eval.bestMove != null;
    return eval.depth >= on.depth;
  }

  /// Removes the waits on [position] that [end] returns true for, and [position] with them when
  /// none is left.
  ///
  /// Nothing completes a waiter once it is dropped, so a caller drops one only where it is
  /// completing it too.
  void _dropWaiters(Position position, bool Function(_Waiter waiter) end) {
    final waiters = _waiters[position];
    if (waiters == null) return;
    waiters.removeWhere(end);
    if (waiters.isEmpty) _waiters.remove(position);
  }

  /// Records that the engine is searching [position], and gives every wait on it its own deadline.
  void _engineSpoke(Position position) {
    _engineSpokeFor = position;
    for (final waiter in _waiters[position] ?? const <_Waiter>[]) {
      waiter.start();
    }
  }

  void _publish(Position position, ClientEval eval) {
    _evals[position] = eval;
    onEval(position, eval);
    // Only the waiters this eval answers: they do not all ask for the same depth, and one waiting
    // on a deeper eval must stay waiting while a shallower one is served.
    _dropWaiters(position, (waiter) {
      if (!_satisfies(eval, waiter.minDepth)) return false;
      waiter.complete(eval);
      return true;
    });
  }

  /// Stops the search, if this analyser started one. The engine is shared, so only its own work is
  /// ever stopped.
  ///
  /// [resumingOn] is the position about to be searched instead, whose waits go on rather than
  /// being stranded: a search started again on the position it was already on is the same wait
  /// carrying on.
  void _stopSearch({bool stopEngine = true, Position? resumingOn}) {
    _subscription?.cancel();
    _subscription = null;
    final analysing = _analysing;
    _analysing = null;
    if (analysing == null) return;
    if (analysing.position != resumingOn) {
      if (_engineSpokeFor == analysing.position) _engineSpokeFor = null;
      _strandWaiters(analysing.position);
    }
    if (!stopEngine) return;
    final currentEvaluator = evaluator();
    if (currentEvaluator.currentWork == analysing) currentEvaluator.stop();
  }

  /// Ends the waits on [position] that are still waiting for the engine to start.
  ///
  /// [kPracticeEngineStartWait] bounds an engine that is on its way, and nothing is on its way to
  /// this position any more: it has been given up, or the analysis has moved on to another
  /// position. Left alone, those waits would run out on a deadline of the analyser's rather than
  /// the caller's — several times longer than the one the caller asked for.
  ///
  /// A wait whose deadline has already started is not touched: it is the caller's own, and the
  /// search may yet come back to the position before it passes.
  void _strandWaiters(Position position) {
    _dropWaiters(position, (waiter) {
      if (waiter.started) return false;
      waiter.complete(_evals[position]);
      return true;
    });
  }

  /// Ends every wait, with the best eval known for its position unless [handOutEvals] says not to.
  void _completeAll({bool handOutEvals = true}) {
    _waiters.forEach((position, waiters) {
      for (final waiter in waiters) {
        waiter.complete(handOutEvals ? _evals[position] : null);
      }
    });
    _waiters.clear();
  }
}

/// Somebody waiting on a position reaching a depth, and the deadline they gave it.
class _Waiter(
  /// The depth this waiter is waiting for.
  final int minDepth,

  /// How long the search is given, once it is the search that is being waited on.
  final Duration timeout,

  /// Called when the deadline passes, whichever of the two it was.
  final void Function(_Waiter waiter) onTimeout,
) {
  final _completer = Completer<ClientEval?>();

  /// Cancelled when the wait ends another way, so that nothing is left ticking behind it.
  Timer? _deadline;

  /// Whether [timeout] is what is running, rather than the wait for the engine to start.
  bool started = false;

  Future<ClientEval?> get future => _completer.future;

  /// Waits [kPracticeEngineStartWait] for the engine to say anything at all about the position.
  void waitForTheEngine() {
    _arm(kPracticeEngineStartWait);
  }

  /// Starts the search's own deadline, the engine having started searching.
  ///
  /// Does nothing once it has: a search started again by [PracticeAnalyser.resumeIfUnfinished]
  /// is the same wait going on, not a new one to give the full [timeout] to.
  void start() {
    if (started) return;
    started = true;
    _arm(timeout);
  }

  void complete(ClientEval? eval) {
    _deadline?.cancel();
    _deadline = null;
    if (!_completer.isCompleted) _completer.complete(eval);
  }

  void _arm(Duration duration) {
    if (_completer.isCompleted) return;
    _deadline?.cancel();
    _deadline = Timer(duration, () => onTimeout(this));
  }
}
