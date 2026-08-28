import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/position_evaluator.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PracticeAnalyser');

/// The depth at which an evaluation is good enough to show a hint or judge a move.
///
/// Lower-end devices may not reach it before the search time runs out, in which case whatever the
/// search did reach is used instead — it is a threshold for unlocking, not a requirement.
///
/// Lower than the 18 the old hint burst stopped at, because it no longer *is* where the search
/// stops: it is only where the player stops waiting, and the search runs on to
/// [kPracticeTargetDepth] refining what it found. A shallower unlock costs nothing that the next
/// second of searching does not put back.
///
/// Lower again in debug, where the engine is genuinely slower: `multistockfish` compiles Stockfish
/// without `-O3 -DNDEBUG -funroll-loops` for the Debug configuration, and a debug run would
/// otherwise spend the whole of the player's turn getting to a hint.
// TODO: consider using searched nodes instead of depth
const kPracticeUsableDepth = kDebugMode ? 13 : 15;

/// The depth at which the search stops and lets the engine idle.
///
/// Not infinite: the analysis runs for as long as the player thinks, and an engine searching for
/// minutes on end is a battery and thermal problem the old burst model never had.
const kPracticeTargetDepth = kDebugMode ? 18 : 26;

/// The wall-clock cap on analysing one position, for a device that would never reach either depth.
const kPracticeMaxSearchTime = Duration(seconds: 10);

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
/// **Who has the floor is the caller's to decide**, through [analyse] and [yieldEngine]. On every
/// variant the opponent plays on the same engine (see `EngineBudget`), and a search started there
/// supersedes this one silently: the stream simply stops and nothing restarts it. So the analysis
/// is handed over explicitly rather than left to be discovered — and taken back the same way, by
/// analysing the position the game is at now, which is not always the one that was given up.
class PracticeAnalyser {
  PracticeAnalyser({required this.evaluator, required this.onEval});

  /// The evaluator to run on.
  ///
  /// A function rather than the evaluator itself, because it is keyed by the game being played and
  /// is resolved lazily by the controller that owns both.
  final PositionEvaluator Function() evaluator;

  /// Called whenever a position's evaluation improves, so the game can store it.
  final void Function(Position position, ClientEval eval) onEval;

  /// The work being analysed, or null when nothing is.
  EvalWork? _analysing;

  StreamSubscription<EvalResult>? _subscription;

  /// The best evaluation seen for each position of this game.
  ///
  /// Keyed by position rather than by ply, which is what makes a takeback free: replaying the same
  /// move arrives at a position that has already been analysed, and no search is needed for it.
  final Map<Position, ClientEval> _evals = {};

  final Map<Position, List<_Waiter>> _waiters = {};

  /// Whether an analysis is running.
  bool get isAnalysing => _analysing != null;

  /// The best evaluation known for [position], however shallow.
  ClientEval? evalFor(Position position) => _evals[position];

  /// Analyses the position [work] describes, replacing whatever was being analysed.
  ///
  /// Does nothing if that position is already being analysed, or if it has already been analysed
  /// to [kPracticeTargetDepth] — there is nothing left to learn about it.
  void analyse(EvalWork work) {
    if (_analysing == work) return;

    final known = _evals[work.position];
    if (known != null && known.depth >= kPracticeTargetDepth) {
      _stopSearch();
      _publish(work.position, known);
      return;
    }

    _logger.fine('Analysing ply ${work.position.ply}');
    _stopSearch();
    _analysing = work;

    final stream = evaluator().evaluate(work);
    if (stream == null) {
      // The evaluator had a good enough eval cached and started nothing.
      _analysing = null;
      final cached = work.evalCache;
      if (cached != null) _record(work.position, cached);
      return;
    }

    _subscription = stream.listen((result) {
      final (resultWork, eval) = result;
      if (resultWork != _analysing) return;
      _record(work.position, eval);
      if (eval.depth >= kPracticeTargetDepth) {
        _logger.fine('Reached the target depth at ply ${work.position.ply}; the engine can idle');
        _stopSearch();
      }
    });
  }

  /// Takes in an evaluation that came from somewhere else — a cloud eval, a tablebase lookup.
  ///
  /// Kept if it is deeper than what the search has reached, and it ends the search when it is
  /// deeper than anything the search would have reached.
  void offer(Position position, ClientEval eval) {
    if (!_record(position, eval)) return;
    if (eval.depth >= kPracticeTargetDepth && _analysing?.position == position) {
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
    final analysing = _analysing;
    if (analysing == null) return;
    _logger.fine('Yielding the engine at ply ${analysing.position.ply}');
    _stopSearch();
  }

  /// Forgets every evaluation of this game. For starting or loading another one.
  void clear() {
    yieldEngine();
    _evals.clear();
    _completeAll();
  }

  /// The evaluation of [position] once it is at least [minDepth] deep.
  ///
  /// Completes at once when it already is — which, with the analysis running throughout the
  /// player's turn, is the ordinary case. Otherwise it completes with the first eval that reaches
  /// the depth, or, when [timeout] passes first, with the best one reached by then (null if the
  /// search produced nothing at all).
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
    if (known != null && known.depth >= minDepth) return Future.value(known);

    final waiter = _Waiter(minDepth);
    (_waiters[position] ??= []).add(waiter);

    waiter.deadline = Timer(timeout, () {
      _waiters[position]?.remove(waiter);
      _logger.info('No usable eval at ply ${position.ply} within ${timeout.inMilliseconds}ms');
      waiter.complete(_evals[position]);
    });

    return waiter.future;
  }

  /// Lets go of everything, without touching the evaluator.
  ///
  /// Called from the owner's disposal, where the evaluator is being disposed too and reaching for
  /// it is not allowed — a provider may not be read from a life-cycle callback.
  void dispose() {
    _stopSearch(stopEngine: false);
    _completeAll();
    _evals.clear();
  }

  /// Keeps [eval] if it is an improvement, and tells everyone waiting on it. Returns whether it
  /// was kept.
  bool _record(Position position, ClientEval eval) {
    final known = _evals[position];
    if (known != null && known.depth > eval.depth) return false;
    _publish(position, eval);
    return true;
  }

  void _publish(Position position, ClientEval eval) {
    _evals[position] = eval;
    onEval(position, eval);
    final waiters = _waiters[position];
    if (waiters == null) return;
    // Only the waiters this eval is deep enough for: they do not all ask for the same depth, and
    // one waiting on a deeper eval must stay waiting while a shallower one is served.
    waiters.removeWhere((waiter) {
      if (eval.depth < waiter.minDepth) return false;
      waiter.complete(eval);
      return true;
    });
    if (waiters.isEmpty) _waiters.remove(position);
  }

  /// Stops the search, if this analyser started one. The engine is shared, so only its own work is
  /// ever stopped.
  void _stopSearch({bool stopEngine = true}) {
    _subscription?.cancel();
    _subscription = null;
    final analysing = _analysing;
    _analysing = null;
    if (analysing == null || !stopEngine) return;
    final evaluator = this.evaluator();
    if (evaluator.currentWork == analysing) evaluator.stop();
  }

  void _completeAll() {
    for (final entry in _waiters.entries) {
      for (final waiter in entry.value) {
        waiter.complete(_evals[entry.key]);
      }
    }
    _waiters.clear();
  }
}

/// Somebody waiting on a position reaching a depth, and the deadline they gave it.
class _Waiter {
  _Waiter(this.minDepth);

  /// The depth this waiter is waiting for.
  final int minDepth;

  final _completer = Completer<ClientEval?>();

  /// Cancelled when the wait ends another way, so that nothing is left ticking behind it.
  Timer? deadline;

  Future<ClientEval?> get future => _completer.future;

  void complete(ClientEval? eval) {
    deadline?.cancel();
    deadline = null;
    if (!_completer.isCompleted) _completer.complete(eval);
  }
}
