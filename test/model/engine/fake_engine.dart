import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/engine/engine_diagnostics.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_transport.dart';
import 'package:multistockfish/multistockfish.dart';

/// The engine every [EngineFactory] built by `makeContainer` hands out.
///
/// Assign a configured [FakeEngine] before creating the container, the way tests used to assign
/// `testBinding.stockfish`. Read lazily, so a test can set it up right before it makes its
/// container.
FakeEngine fakeEngine = FakeEngine();

Rule ruleFromUciVariant(String uciVariant) => switch (uciVariant) {
  'chess' => Rule.chess,
  'antichess' => Rule.antichess,
  'kingofthehill' => Rule.kingofthehill,
  '3check' => Rule.threecheck,
  'atomic' => Rule.atomic,
  'horde' => Rule.horde,
  'racingkings' => Rule.racingKings,
  'crazyhouse' => Rule.crazyhouse,
  _ => throw ArgumentError('Unexpected uci variant: $uciVariant'),
};

String _engineNameFor(EngineSpec spec) => switch (spec) {
  StockfishSpec(flavor: StockfishFlavor.sf16) => 'Stockfish 16',
  StockfishSpec(flavor: StockfishFlavor.latestNoNNUE) => 'Stockfish 18',
  StockfishSpec(flavor: StockfishFlavor.variant) => 'Fairy-Stockfish',
  Lc0Spec() => 'Lc0 v0.32.1',
};

/// Minimum depth for an eval to be accepted by the evaluation service.
const kMinEngineDepth = 6;

/// A fake engine, standing in for the plugin as a whole.
///
/// It can be started and quit over and over, handing out a fresh [FakeEngineSession] each time, so
/// the counters and the recorded commands accumulate across restarts — which is what lets a test
/// say "the engine was started twice" without holding on to two objects. Several sessions can be
/// live at once, as several flavours can: an offline game runs its opponent on Fairy-Stockfish
/// while its hints are computed on the analysis engine, and each session keeps its own position.
///
/// Subclass it and override [onGo] / [onStop] to control what the engine answers; the lifecycle
/// oddities a test might want (a start that throws, one that never returns, a write that kills the
/// session) are constructor flags rather than subclasses.
class FakeEngine {
  FakeEngine({
    this.engineName,
    this.startDelay = Duration.zero,
    this.quitDelay = Duration.zero,
    this.startThrows = false,
    this.startReportsError = false,
    this.hangsFromStart,
    this.failWrite,
  });

  /// Overrides the name the engine reports, which is otherwise taken from the spec's flavour.
  final String? engineName;

  final Duration startDelay;
  final Duration quitDelay;

  /// Whether starting throws, the way the plugin does when the native library will not run.
  final bool startThrows;

  /// Whether starting reports a failed engine instead of a ready one — the plugin's other way of
  /// refusing, by state rather than by throwing.
  final bool startReportsError;

  /// The first start that never completes, if any. `1` wedges the engine from the outset; `2`
  /// lets it run once and wedges the engine that replaces it.
  final int? hangsFromStart;

  /// Which commands the native side fails to deliver. A failed write leaves the session unusable.
  final bool Function(String command)? failWrite;

  /// How many times the engine was started, and quit.
  int startCount = 0;
  int quitCount = 0;

  /// The most native operations seen running at the same time. Must stay at 1: an engine that is
  /// started while the previous one is still quitting is what crashed the app in #2870.
  int maxConcurrentOps = 0;
  int _inFlightOps = 0;

  /// Every command the engine was sent, across sessions.
  final List<String> commands = [];

  /// The commands whose write failed, in order.
  final List<String> failedCommands = [];

  /// The options currently set on the engine.
  final Map<String, String> options = {};

  int get stopCount => commands.where((command) => command.startsWith('stop')).length;

  /// The position the last `position` command set up, on the session that got it.
  Position? get position => _sessions.lastOrNull?.position;

  /// The variant last set with `setoption name UCI_Variant`.
  String? get variant => _sessions.lastOrNull?.variant;

  /// The spec of the last start.
  EngineSpec? spec;

  final List<FakeEngineSession> _sessions = [];

  /// The sessions that are live, oldest first.
  List<FakeEngineSession> get sessions => List.unmodifiable(_sessions);

  /// Whether any session is live.
  bool get isRunning => _sessions.isNotEmpty;

  /// Starts the engine, as [EngineFactory] does through its connector.
  Future<EngineTransport> connect(EngineSpec spec) async {
    _enter();
    startCount++;
    this.spec = spec;

    if (startThrows) {
      _exit();
      throw Exception('The engine failed to start');
    }
    if (hangsFromStart != null && startCount >= hangsFromStart!) {
      // Deliberately never completes, and never leaves the in-flight count either: this engine is
      // wedged somewhere no timeout of the plugin's covers.
      return Completer<EngineTransport>().future;
    }

    if (startDelay > Duration.zero) {
      await Future<void>.delayed(startDelay);
    } else {
      await Future.microtask(() {});
    }

    if (startReportsError) {
      _exit();
      throw StateError('The engine reported error instead of becoming ready');
    }

    final session = FakeEngineSession(this, spec);
    _sessions.add(session);
    _exit();
    return session;
  }

  /// The lines the engine writes before anyone can listen, replayed to the first listener.
  @protected
  List<String> handshakeLines(EngineSpec spec) => [
    'id name ${engineName ?? _engineNameFor(spec)}',
    // No `option` declarations: an engine that lists none is the harder case for option hygiene,
    // and it is what [Engine]'s fallback defaults exist for.
    'uciok',
  ];

  /// Writes a line from the session that most recently started.
  ///
  /// Enough for a test driving a single engine; a subclass answering a command writes to the
  /// session that was asked.
  void emit(String line) => _sessions.lastOrNull?._receiveLine(line);

  /// What the engine answers a `go` with. The default is two info lines and a bestmove, enough for
  /// the throttle to have something to swallow.
  ///
  /// A bounded search answers; `go infinite` does not, because an engine told to search forever
  /// only stops when it is told to.
  @protected
  void onGo(FakeEngineSession session, List<String> parts) {
    if (parts.length < 3) return;
    if (!const {'movetime', 'nodes', 'depth'}.contains(parts[1])) return;
    if (int.tryParse(parts[2]) == null) return;
    for (var i = 1; i < 3; i++) {
      session.emit(
        'info depth ${14 + i} seldepth 8 multipv 1 score cp '
        '${session.position?.turn == Side.black ? '-' : ''}23 nodes ${359 * (i + 14)} nps 359000 '
        'hashfull 0 tbhits 0 time ${100 * (i + 14)} pv e2e4 e7e5 g1f3 b8c6 f1b5 g8f6',
      );
    }
    session.emit('bestmove e2e4 ponder e7e5');
  }

  /// What the engine answers a `stop` with. Nothing, by default: the search that was running has
  /// already said its last word.
  @protected
  void onStop(FakeEngineSession session) {}

  /// Called when a session ends, so that a subclass can forget what it was counting.
  @protected
  void onQuit() {}

  /// Kills the most recent session, as an engine that breaks under load would.
  void kill(EngineFailure failure) => _sessions.lastOrNull?._die(failure);

  void _enter() {
    _inFlightOps++;
    if (_inFlightOps > maxConcurrentOps) maxConcurrentOps = _inFlightOps;
  }

  void _exit() => _inFlightOps--;

  void _receive(FakeEngineSession session, String command) {
    if (!_sessions.contains(session)) return;
    commands.add(command);

    if (failWrite?.call(command) ?? false) {
      // Logged natively and dropped: the engine is told nothing, and neither is the caller. Only
      // the state moving to failed says the session is over.
      failedCommands.add(command);
      session._die(
        EngineFailure(
          kind: EngineFailureKind.command,
          message: 'The engine could not be sent the command "$command"',
          engine: session.spec.label,
        ),
      );
      return;
    }

    final parts = command.split(RegExp(r'\s+'));
    switch (parts.first) {
      case 'isready':
        session.emit('readyok');
      case 'setoption' when parts.length >= 5 && parts[1] == 'name':
        final valueIndex = parts.indexOf('value');
        final name = parts.sublist(2, valueIndex).join(' ');
        final value = parts.sublist(valueIndex + 1).join(' ');
        options[name] = value;
        if (name == 'UCI_Variant') session.variant = value;
      case 'position':
        _setUpPosition(session, parts);
      case 'go':
        onGo(session, parts);
      case 'stop':
        onStop(session);
    }
  }

  void _setUpPosition(FakeEngineSession session, List<String> parts) {
    if (parts.length < 3 || parts[1] != 'fen') return;
    final movesIndex = parts.indexWhere((part) => part == 'moves');
    var position = Position.setupPosition(
      session.variant != null ? ruleFromUciVariant(session.variant!) : Rule.chess,
      Setup.parseFen(parts.sublist(2, movesIndex != -1 ? movesIndex : null).join(' ')),
    );
    if (movesIndex != -1) {
      for (var i = movesIndex + 1; i < parts.length; i++) {
        final move = Move.parse(parts[i]);
        if (move != null) position = position.play(move);
      }
    }
    session.position = position;
  }

  Future<void> _quit(FakeEngineSession session) async {
    if (!_sessions.contains(session)) return;
    _enter();
    quitCount++;

    if (quitDelay > Duration.zero) {
      await Future<void>.delayed(quitDelay);
    } else {
      await Future.microtask(() {});
    }

    _sessions.remove(session);
    onQuit();
    session._die(null);
    _exit();
  }
}

/// One live engine: what a single [Stockfish.create] hands back.
class FakeEngineSession implements EngineTransport {
  FakeEngineSession(this._engine, this.spec) {
    _pending.addAll(_engine.handshakeLines(spec));
    _controller.onListen = () {
      if (_replayed) return;
      _replayed = true;
      for (final line in _pending) {
        _controller.add(line);
      }
      _pending.clear();
    };
  }

  final FakeEngine _engine;

  @override
  final EngineSpec spec;

  final _controller = StreamController<String>.broadcast();
  final _death = Completer<EngineFailure?>();
  final _pending = <String>[];
  bool _replayed = false;

  /// The position this session's last `position` command set up.
  Position? position;

  /// The variant this session was last told to play.
  String? variant;

  /// Writes a line, as this engine would.
  void emit(String line) => _receiveLine(line);

  @override
  Stream<String> get lines => _controller.stream;

  @override
  Future<EngineFailure?> get death => _death.future;

  @override
  bool get isDead => _death.isCompleted;

  @override
  EngineDiagnostics? get diagnostics => diagnosticsOverride;

  /// What the engine reports it was doing, for failure reports.
  EngineDiagnostics? diagnosticsOverride = const EngineDiagnostics(
    phase: 'idle',
    step: 'idle',
    elapsed: Duration.zero,
    looksStuck: false,
  );

  @override
  void send(String command) {
    if (isDead) return;
    _engine._receive(this, command);
  }

  @override
  Future<void> dispose() => _engine._quit(this);

  void _receiveLine(String line) {
    if (_controller.isClosed) return;
    if (_replayed) {
      _controller.add(line);
    } else {
      _pending.add(line);
    }
  }

  void _die(EngineFailure? failure) {
    if (_death.isCompleted) return;
    _death.complete(failure);
    if (!_controller.isClosed) _controller.close();
  }
}

/// A fake Fairy-Stockfish for crazyhouse that answers with a drop move in its principal variation.
///
/// Used to check that engine lines handle drop moves.
class CrazyhouseDropMoveEngine extends FakeEngine {
  CrazyhouseDropMoveEngine() : super(engineName: 'Fairy-Stockfish');

  @override
  void onGo(FakeEngineSession session, List<String> parts) {
    session.emit(
      'info depth 15 seldepth 8 multipv 1 score cp 50 nodes 5000 nps 359000 hashfull 0 tbhits 0 '
      'time 1500 pv P@c4 d5c4 d2d4',
    );
    session.emit(
      'info depth 16 seldepth 8 multipv 1 score cp 50 nodes 5359 nps 359000 hashfull 0 tbhits 0 '
      'time 1600 pv P@c4 d5c4 d2d4',
    );
    session.emit('bestmove P@c4 ponder d5c4');
  }
}

/// A fake engine that says nothing until the test tells it to, for throttle tests.
/// A fake engine that takes its time answering, so that a test can tell a search that ran from a
/// wait that was imposed on top of one.
class SlowEngine extends FakeEngine {
  SlowEngine(this.searchDuration);

  /// How long the engine takes to reach its `bestmove`.
  final Duration searchDuration;

  @override
  void onGo(FakeEngineSession session, List<String> parts) {
    Future<void>.delayed(searchDuration, () {
      // The session may have been disposed while the search was running.
      if (sessions.contains(session)) session.emit('bestmove e2e4');
    });
  }
}

class ThrottleTestEngine extends FakeEngine {
  ThrottleTestEngine({this.evalEventCount = 5});

  /// How many info lines [emitEvalEvents] writes.
  final int evalEventCount;

  /// How many info lines have been written so far.
  int emittedEvalCount = 0;

  /// Writes a burst of info lines. Tests call this to control the timing.
  void emitEvalEvents() {
    for (var i = 0; i < evalEventCount; i++) {
      emittedEvalCount++;
      final depth = 10 + emittedEvalCount;
      final time = 100 * emittedEvalCount;
      emit(
        'info depth $depth seldepth 8 multipv 1 score cp '
        '${position?.turn == Side.black ? '-' : ''}${emittedEvalCount * 10} '
        'nodes ${359 * depth} nps 359000 hashfull 0 tbhits 0 time $time pv e2e4 e7e5 g1f3',
      );
    }
  }

  /// Writes the bestmove that ends the search.
  void emitBestMove() => emit('bestmove e2e4 ponder e7e5');

  @override
  void onGo(FakeEngineSession session, List<String> parts) {}

  @override
  void onQuit() => emittedEvalCount = 0;
}

/// A fake engine for analysis scenarios, with the eval emitted a depth at a time.
///
/// Deepens on demand, gives every position a different but deterministic eval, and records the
/// positions it was asked about so a test can check what was and was not debounced away.
class AnalysisTestEngine extends FakeEngine {
  /// The positions the engine was asked to search, in order.
  final List<String> requestedPositions = [];

  /// Starts one below [kMinEngineDepth] so that the first [emitNextDepth] emits that depth.
  int _currentDepth = kMinEngineDepth - 1;

  /// A deterministic eval for [position]: different positions get different evals, and the same
  /// position always gets the same one.
  int _cpForPosition(Position position) {
    const baseValues = [15, 20, 30, 10, 25, 15, 35, 5, 40, 22, 33, 11];
    return baseValues[position.ply % baseValues.length];
  }

  /// Emits one info line, a ply deeper than the last, and returns the depth it reported.
  int emitNextDepth() {
    final current = position;
    if (current == null) return 0;

    _currentDepth++;
    final cp = _cpForPosition(current);
    final signedCp = current.turn == Side.white ? cp : -cp;

    emit(
      'info depth $_currentDepth seldepth ${_currentDepth + 2} multipv 1 score cp $signedCp '
      'nodes ${1000 * _currentDepth} nps 100000 hashfull 0 tbhits 0 time ${100 * _currentDepth} '
      'pv e2e4 e7e5 g1f3 b8c6 f1b5 g8f6',
    );

    return _currentDepth;
  }

  /// Emits every depth up to [toDepth], simulating a complete search.
  void emitDepthRange({required int toDepth}) {
    while (_currentDepth < toDepth) {
      emitNextDepth();
    }
  }

  /// Forgets what was asked and how deep it got.
  void resetTracking() {
    requestedPositions.clear();
    _currentDepth = kMinEngineDepth - 1;
  }

  @override
  void onGo(FakeEngineSession session, List<String> parts) {
    if (session.position case final position?) requestedPositions.add(position.fen);
  }

  @override
  void onStop(FakeEngineSession session) {
    // The search is over as soon as it is asked to stop, which is what tests drive it with.
    final current = session.position;
    final best = current == null ? null : _firstLegalMove(current);
    if (current == null || best == null) return;
    session.emit('bestmove ${best.uci}${_ponder(current)}');
  }

  @override
  void onQuit() => _currentDepth = kMinEngineDepth - 1;
}

/// A fake engine that plays the first legal move it finds.
class LegalMoveEngine extends FakeEngine {
  @override
  void onGo(FakeEngineSession session, List<String> parts) {
    final current = session.position;
    final best = current == null ? null : _firstLegalMove(current);
    if (current == null || best == null) return;

    final signedCp = current.turn == Side.white ? '23' : '-23';
    session.emit(
      'info depth 15 seldepth 8 multipv 1 score cp $signedCp nodes 5000 nps 359000 hashfull 0 '
      'tbhits 0 time 1500 pv ${best.uci}',
    );
    session.emit('bestmove ${best.uci}${_ponder(current)}');
  }
}

/// A fake engine that answers with several principal variations, for hint tests.
class MultiPvEngine extends FakeEngine {
  @override
  void onGo(FakeEngineSession session, List<String> parts) {
    final current = session.position;
    if (current == null) return;
    final moves = _firstLegalMoves(current, 5);
    if (moves.isEmpty) return;

    // Each variation is five centipawns worse than the one before it.
    final baseCp = current.turn == Side.white ? 30 : -30;
    for (var i = 0; i < moves.length; i++) {
      final cp = current.turn == Side.white ? baseCp - (i * 5) : baseCp + (i * 5);
      session.emit(
        'info depth 15 seldepth 8 multipv ${i + 1} score cp $cp nodes 5000 nps 359000 '
        'hashfull 0 tbhits 0 time 1500 pv ${moves[i].uci}',
      );
    }
    session.emit('bestmove ${moves.first.uci}${_ponder(current)}');
  }
}

/// A fake engine whose second line falls behind as the search deepens, for the hint tests.
///
/// The shallow pair it answers with is close enough that both moves are offered as hints; the
/// deeper pair, emitted on demand, leaves the second one far enough behind that the hint filter
/// drops it — which is what a hint the player is looking at has to survive.
class NarrowingHintEngine extends FakeEngine {
  @override
  void onGo(FakeEngineSession session, List<String> parts) =>
      _emitPair(session, depth: 15, secondCp: 180);

  /// Emits the deeper pair. Tests call this to control the timing.
  void emitNarrowedDepth() {
    final session = sessions.lastOrNull;
    if (session != null) _emitPair(session, depth: 17, secondCp: 0);
  }

  void _emitPair(FakeEngineSession session, {required int depth, required int secondCp}) {
    final current = session.position;
    if (current == null) return;
    final moves = _firstLegalMoves(current, 2);
    if (moves.length < 2) return;

    final cps = [200, secondCp];
    for (var i = 0; i < moves.length; i++) {
      final cp = current.turn == Side.white ? cps[i] : -cps[i];
      session.emit(
        'info depth $depth seldepth ${depth + 2} multipv ${i + 1} score cp $cp nodes 50000 '
        'nps 500000 hashfull 100 tbhits 0 time ${depth * 100} pv ${moves[i].uci}',
      );
    }
  }

  @override
  void onStop(FakeEngineSession session) {
    final current = session.position;
    final best = current == null ? null : _firstLegalMove(current);
    if (current == null || best == null) return;
    session.emit('bestmove ${best.uci}${_ponder(current)}');
  }
}

/// A fake engine for practice mode, whose eval can be made to drop by a set amount after the
/// player's move so that a test can produce any move quality it wants.
class PracticeModeEngine extends FakeEngine {
  PracticeModeEngine({this.initialEvalCp = 30, this.evalShiftCp = 0});

  /// The evaluation before the player's move.
  final int initialEvalCp;

  /// How much the evaluation moves after it: negative means the position got worse.
  final int evalShiftCp;

  int _goCount = 0;
  List<NormalMove>? _lastMoves;

  @override
  void onGo(FakeEngineSession session, List<String> parts) {
    _goCount++;
    final current = session.position;
    if (current == null) return;
    final moves = _firstLegalMoves(current, 4);
    if (moves.isEmpty) return;
    _lastMoves = moves;

    // The first search is the hint, before the move; every later one evaluates what was played.
    final baseCp = _goCount > 1 ? initialEvalCp + evalShiftCp : initialEvalCp;

    // Practice mode only accepts evals from depth 16 up.
    for (var depth = 16; depth <= 18; depth++) {
      for (var i = 0; i < moves.length; i++) {
        final cp = current.turn == Side.white ? baseCp - (i * 5) : -(baseCp - (i * 5));
        session.emit(
          'info depth $depth seldepth ${depth + 2} multipv ${i + 1} score cp $cp nodes 50000 '
          'nps 500000 hashfull 100 tbhits 0 time ${depth * 100} pv ${moves[i].uci}',
        );
      }
    }

    session.emit('bestmove ${moves.first.uci}${_ponder(current)}');
  }

  @override
  void onStop(FakeEngineSession session) {
    final current = session.position;
    if (current == null || _lastMoves == null || _lastMoves!.isEmpty) return;
    session.emit('bestmove ${_lastMoves!.first.uci}${_ponder(current)}');
  }

  @override
  void onQuit() => _goCount = 0;
}

NormalMove? _firstLegalMove(Position position) {
  final legalMoves = makeLegalMoves(position);
  if (legalMoves.isEmpty) return null;
  final from = legalMoves.keys.first;
  return NormalMove(from: from, to: legalMoves[from]!.first);
}

List<NormalMove> _firstLegalMoves(Position position, int count) {
  final moves = <NormalMove>[];
  for (final entry in makeLegalMoves(position).entries) {
    if (moves.length >= count) break;
    moves.add(NormalMove(from: entry.key, to: entry.value.first));
  }
  return moves;
}

/// The ` ponder <move>` suffix of a bestmove, or nothing if the position after it is terminal.
String _ponder(Position position) {
  final best = _firstLegalMove(position);
  if (best == null) return '';
  final ponder = _firstLegalMove(position.play(best));
  return ponder == null ? '' : ' ponder ${ponder.uci}';
}

/// An engine whose start reports a failure instead of becoming ready.
///
/// The plugin has two ways of refusing: throwing, and moving the engine's state. This is the
/// second, which the transport turns into a failed connect.
class ErrorEngine extends FakeEngine {
  ErrorEngine() : super(startReportsError: true);
}

/// An engine whose start throws, the way the plugin does when the native library will not run.
class ThrowingStartEngine extends FakeEngine {
  ThrowingStartEngine() : super(startThrows: true);
}

/// An engine that never finishes starting: wedged somewhere no timeout of the plugin's covers.
class StuckEngine extends FakeEngine {
  StuckEngine() : super(hangsFromStart: 1);
}

/// An engine that starts once and then wedges, so that the engine replacing a healthy one is the
/// one that never becomes ready.
class WedgesOnRestartEngine extends FakeEngine {
  WedgesOnRestartEngine() : super(hangsFromStart: 2);
}

/// An engine that starts normally and then breaks the command stream.
///
/// Models the plugin's write contract, which is not the obvious one: a write the native side
/// could not deliver never throws. It is logged and dropped, and only a failure that leaves the
/// session unusable moves the engine's state — which is what the transport is watching for while
/// it writes, so the failure names the command that caused it.
///
/// By default the very first write fails. Pass [fails] to break the engine part-way through an
/// exchange instead: a session that answers `isready` and then chokes on `go` is what a real
/// engine looks like when it dies under load.
class FatalWriteEngine extends FakeEngine {
  FatalWriteEngine({bool Function(String command)? fails})
    : super(failWrite: fails ?? ((_) => true));
}
