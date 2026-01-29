import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:multistockfish/multistockfish.dart';

/// A fake implementation of [Stockfish] for testing.
class FakeStockfish implements Stockfish {
  FakeStockfish();

  final _state = ValueNotifier<StockfishState>(StockfishState.initial);
  final _stdoutController = StreamController<String>.broadcast();

  StockfishFlavor _flavor = StockfishFlavor.sf16;

  String? _variant;
  String? _smallNetPath;
  String? _bigNetPath;

  Position? _position;

  void _emit(String line) {
    _stdoutController.add(line);
  }

  @override
  StockfishFlavor get flavor => _flavor;

  @override
  String? get variant => _variant;

  @override
  String? get bigNetPath => _bigNetPath;

  @override
  String? get smallNetPath => _smallNetPath;

  @override
  Future<void> start({
    StockfishFlavor flavor = StockfishFlavor.sf16,
    String? variant,
    String? smallNetPath,
    String? bigNetPath,
  }) async {
    _flavor = flavor;
    _variant = variant;
    _smallNetPath = smallNetPath;
    _bigNetPath = bigNetPath;
    _state.value = StockfishState.starting;
    await Future.microtask(() {});
    _state.value = StockfishState.ready;
  }

  @override
  Future<void> quit() async {
    await Future.microtask(() {});
    _state.value = StockfishState.initial;
  }

  @override
  set stdin(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    switch (parts.first) {
      case 'uci':
        final engineName = (_flavor == StockfishFlavor.latestNoNNUE
            ? 'Stockfish 17'
            : 'Stockfish 16');
        _emit('id name $engineName\n');
        _emit('uciok\n');
      case 'isready':
        _emit('readyok\n');
      case 'position':
        if (parts.length > 1 && parts[1] == 'fen') {
          final movesPartIndex = parts.indexWhere((p) => p == 'moves');
          if (parts.length > 2) {
            _position = Position.setupPosition(
              Rule.chess,
              Setup.parseFen(
                parts.sublist(2, movesPartIndex != -1 ? movesPartIndex : null).join(' '),
              ),
            );
          }
          if (movesPartIndex != -1) {
            for (var i = movesPartIndex + 1; i < parts.length; i++) {
              final move = Move.parse(parts[i]);
              if (move != null) {
                _position = _position!.play(move);
              }
            }
          }
        }
      case 'go':
        if (parts.length > 1 && parts[1] == 'movetime') {
          if (parts.length > 2) {
            final moveTime = int.tryParse(parts[2]);
            if (moveTime != null) {
              // Emits only 2 info lines, because of the throttler in evaluation service there is no
              // need to emit more.
              // Only the last line will be used after waiting the throttle duration. Which means
              // the depth will always be 15 before throttle delay and 16 after.
              // The cp value will always 23.
              for (var i = 1; i < 3; i++) {
                _emit(
                  'info depth ${14 + i} seldepth 8 multipv 1 score cp ${_position?.turn == Side.black ? '-' : ''}23 nodes ${359 * (i + 14)} nps 359000 hashfull 0 tbhits 0 time ${100 * (i + 14)} pv e2e4 e7e5 g1f3 b8c6 f1b5 g8f6\n',
                );
              }
              _emit('bestmove e2e4 ponder e7e5\n');
            }
          }
        }
    }
  }

  @override
  ValueListenable<StockfishState> get state => _state;

  @override
  Stream<String> get stdout => _stdoutController.stream;
}

/// A fake Stockfish with configurable delays for testing race conditions.
class DelayedFakeStockfish implements Stockfish {
  DelayedFakeStockfish({
    this.startDelay = Duration.zero,
    this.quitDelay = Duration.zero,
    String? engineName,
  }) : _customEngineName = engineName;

  final Duration startDelay;
  final Duration quitDelay;
  final String? _customEngineName;

  final _state = ValueNotifier<StockfishState>(StockfishState.initial);
  final _stdoutController = StreamController<String>.broadcast();

  StockfishFlavor _flavor = StockfishFlavor.sf16;
  Position? _position;

  int startCallCount = 0;
  int quitCallCount = 0;
  final List<String> stdinCommands = [];

  /// Tracks UCI options that have been set.
  final Map<String, String> options = {};

  int get stopCallCount => stdinCommands.where((cmd) => cmd.startsWith('stop')).length;

  void _emit(String line) {
    if (!_stdoutController.isClosed) {
      _stdoutController.add(line);
    }
  }

  @override
  StockfishFlavor get flavor => _flavor;

  @override
  String? get variant => null;

  @override
  String? get bigNetPath => null;

  @override
  String? get smallNetPath => null;

  @override
  Future<void> start({
    StockfishFlavor flavor = StockfishFlavor.sf16,
    String? variant,
    String? smallNetPath,
    String? bigNetPath,
  }) async {
    startCallCount++;
    _flavor = flavor;
    _state.value = StockfishState.starting;
    if (startDelay > Duration.zero) {
      await Future<void>.delayed(startDelay);
    } else {
      await Future.microtask(() {});
    }
    _state.value = StockfishState.ready;
  }

  @override
  Future<void> quit() async {
    quitCallCount++;
    if (quitDelay > Duration.zero) {
      await Future<void>.delayed(quitDelay);
    } else {
      await Future.microtask(() {});
    }
    _state.value = StockfishState.initial;
  }

  @override
  set stdin(String line) {
    stdinCommands.add(line.trim());
    final parts = line.trim().split(RegExp(r'\s+'));
    switch (parts.first) {
      case 'uci':
        final engineName =
            _customEngineName ??
            (_flavor == StockfishFlavor.latestNoNNUE ? 'Stockfish 17' : 'Stockfish 16');
        _emit('id name $engineName\n');
        _emit('uciok\n');
      case 'isready':
        _emit('readyok\n');
      case 'position':
        if (parts.length > 1 && parts[1] == 'fen') {
          final movesPartIndex = parts.indexWhere((p) => p == 'moves');
          if (parts.length > 2) {
            _position = Position.setupPosition(
              Rule.chess,
              Setup.parseFen(
                parts.sublist(2, movesPartIndex != -1 ? movesPartIndex : null).join(' '),
              ),
            );
          }
          if (movesPartIndex != -1) {
            for (var i = movesPartIndex + 1; i < parts.length; i++) {
              final move = Move.parse(parts[i]);
              if (move != null) {
                _position = _position!.play(move);
              }
            }
          }
        }
      case 'setoption':
        // Parse "setoption name <name> value <value>"
        final nameIndex = parts.indexOf('name');
        final valueIndex = parts.indexOf('value');
        if (nameIndex != -1 && valueIndex != -1 && valueIndex > nameIndex) {
          final name = parts.sublist(nameIndex + 1, valueIndex).join(' ');
          final value = parts.sublist(valueIndex + 1).join(' ');
          options[name] = value;
        }
      case 'go':
        if (parts.length > 1 && parts[1] == 'movetime') {
          if (parts.length > 2) {
            final moveTime = int.tryParse(parts[2]);
            if (moveTime != null) {
              for (var i = 1; i < 3; i++) {
                _emit(
                  'info depth ${14 + i} seldepth 8 multipv 1 score cp ${_position?.turn == Side.black ? '-' : ''}23 nodes ${359 * (i + 14)} nps 359000 hashfull 0 tbhits 0 time ${100 * (i + 14)} pv e2e4 e7e5 g1f3 b8c6 f1b5 g8f6\n',
                );
              }
              _emit('bestmove e2e4 ponder e7e5\n');
            }
          }
        }
    }
  }

  @override
  ValueListenable<StockfishState> get state => _state;

  @override
  Stream<String> get stdout => _stdoutController.stream;
}

/// A fake Stockfish that emits multiple eval events with controllable timing.
/// Used for testing throttle behavior.
class ThrottleTestStockfish implements Stockfish {
  ThrottleTestStockfish({this.evalEventCount = 5, this.evalEventInterval = Duration.zero});

  /// Number of eval events to emit per `go` command.
  final int evalEventCount;

  /// Interval between each eval event emission.
  final Duration evalEventInterval;

  final _state = ValueNotifier<StockfishState>(StockfishState.initial);
  final _stdoutController = StreamController<String>.broadcast();

  Position? _position;

  /// Tracks how many eval info lines have been emitted.
  int emittedEvalCount = 0;

  void _emit(String line) {
    if (!_stdoutController.isClosed) {
      _stdoutController.add(line);
    }
  }

  /// Emits eval events. Call this from tests to control timing.
  void emitEvalEvents() {
    for (var i = 0; i < evalEventCount; i++) {
      emittedEvalCount++;
      final depth = 10 + emittedEvalCount;
      final time = 100 * emittedEvalCount;
      _emit(
        'info depth $depth seldepth 8 multipv 1 score cp ${_position?.turn == Side.black ? '-' : ''}${emittedEvalCount * 10} nodes ${359 * depth} nps 359000 hashfull 0 tbhits 0 time $time pv e2e4 e7e5 g1f3\n',
      );
    }
  }

  /// Emits bestmove to signal evaluation complete.
  void emitBestMove() {
    _emit('bestmove e2e4 ponder e7e5\n');
  }

  @override
  StockfishFlavor get flavor => StockfishFlavor.sf16;

  @override
  String? get variant => null;

  @override
  String? get bigNetPath => null;

  @override
  String? get smallNetPath => null;

  @override
  Future<void> start({
    StockfishFlavor flavor = StockfishFlavor.sf16,
    String? variant,
    String? smallNetPath,
    String? bigNetPath,
  }) async {
    _state.value = StockfishState.starting;
    await Future.microtask(() {});
    _state.value = StockfishState.ready;
  }

  @override
  Future<void> quit() async {
    await Future.microtask(() {});
    _state.value = StockfishState.initial;
    emittedEvalCount = 0;
  }

  @override
  set stdin(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    switch (parts.first) {
      case 'uci':
        _emit('id name Stockfish 16\n');
        _emit('uciok\n');
      case 'isready':
        _emit('readyok\n');
      case 'position':
        if (parts.length > 1 && parts[1] == 'fen') {
          final movesPartIndex = parts.indexWhere((p) => p == 'moves');
          if (parts.length > 2) {
            _position = Position.setupPosition(
              Rule.chess,
              Setup.parseFen(
                parts.sublist(2, movesPartIndex != -1 ? movesPartIndex : null).join(' '),
              ),
            );
          }
        }
      case 'go':
        // Don't emit automatically - tests will call emitEvalEvents() manually
        break;
    }
  }

  @override
  ValueListenable<StockfishState> get state => _state;

  @override
  Stream<String> get stdout => _stdoutController.stream;
}

/// Minimum depth for eval to be accepted by UCIProtocol.
const kMinEngineDepth = 6;

/// A fake Stockfish for testing analysis scenarios with controllable eval emission.
///
/// Key features:
/// - Progressive depth emission (depth increases with each eval event, starting from minDepth=6)
/// - Position-dependent cp values (different positions get different, but deterministic, evals)
/// - Manual control over when evals are emitted
/// - Tracks all 'go' commands to verify debouncing
class AnalysisTestStockfish implements Stockfish {
  AnalysisTestStockfish();

  final _state = ValueNotifier<StockfishState>(StockfishState.initial);
  final _stdoutController = StreamController<String>.broadcast();

  Position? _position;

  /// Tracks positions requested for evaluation (for verifying debouncing).
  final List<String> requestedPositions = [];

  /// Current depth being emitted for the active position.
  /// Starts at kMinEngineDepth - 1 so first emitNextDepth() returns kMinEngineDepth.
  int _currentDepth = kMinEngineDepth - 1;

  void _emit(String line) {
    if (!_stdoutController.isClosed) {
      _stdoutController.add(line);
    }
  }

  /// Computes a deterministic cp value based on position ply.
  /// Different positions get different evals, but the same position always gets the same eval.
  /// Always returns positive values (white advantage) for simplicity in tests.
  int _cpForPosition(Position position) {
    // Use ply to generate different evals: starting position = 15, after e4 = 20, etc.
    // This gives us predictable evals: +0.15, +0.2, +0.3, +0.1, +0.25, etc.
    final baseValues = [15, 20, 30, 10, 25, 15, 35, 5, 40, 22, 33, 11];
    final index = position.ply % baseValues.length;
    return baseValues[index];
  }

  /// Emits a single eval event at the next depth level.
  /// The first call emits depth [kMinEngineDepth] (6), subsequent calls increment by 1.
  /// Returns the depth that was emitted.
  int emitNextDepth() {
    if (_position == null) return 0;

    _currentDepth++;
    final cp = _cpForPosition(_position!);
    final signedCp = _position!.turn == Side.white ? cp : -cp;
    final time = 100 * _currentDepth;
    final nodes = 1000 * _currentDepth;

    _emit(
      'info depth $_currentDepth seldepth ${_currentDepth + 2} multipv 1 score cp $signedCp '
      'nodes $nodes nps 100000 hashfull 0 tbhits 0 time $time '
      'pv e2e4 e7e5 g1f3 b8c6 f1b5 g8f6\n',
    );

    return _currentDepth;
  }

  /// Emits multiple depth levels up to [toDepth].
  /// Useful for simulating a complete evaluation cycle.
  void emitDepthRange({required int toDepth}) {
    while (_currentDepth < toDepth) {
      emitNextDepth();
    }
  }

  /// Resets the internal state for a new test.
  void resetTracking() {
    requestedPositions.clear();
    _currentDepth = kMinEngineDepth - 1;
  }

  @override
  StockfishFlavor get flavor => StockfishFlavor.sf16;

  @override
  String? get variant => null;

  @override
  String? get bigNetPath => null;

  @override
  String? get smallNetPath => null;

  @override
  Future<void> start({
    StockfishFlavor flavor = StockfishFlavor.sf16,
    String? variant,
    String? smallNetPath,
    String? bigNetPath,
  }) async {
    _state.value = StockfishState.starting;
    await Future.microtask(() {});
    _state.value = StockfishState.ready;
  }

  @override
  Future<void> quit() async {
    await Future.microtask(() {});
    _state.value = StockfishState.initial;
    _currentDepth = kMinEngineDepth - 1;
  }

  @override
  set stdin(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    switch (parts.first) {
      case 'uci':
        _emit('id name Stockfish 16\n');
        _emit('uciok\n');
      case 'isready':
        _emit('readyok\n');
      case 'position':
        if (parts.length > 1 && parts[1] == 'fen') {
          final movesPartIndex = parts.indexWhere((p) => p == 'moves');
          if (parts.length > 2) {
            _position = Position.setupPosition(
              Rule.chess,
              Setup.parseFen(
                parts.sublist(2, movesPartIndex != -1 ? movesPartIndex : null).join(' '),
              ),
            );
          }
          if (movesPartIndex != -1) {
            for (var i = movesPartIndex + 1; i < parts.length; i++) {
              final move = Move.parse(parts[i]);
              if (move != null) {
                _position = _position!.play(move);
              }
            }
          }
        }
        // Reset depth counter when position changes
        _currentDepth = kMinEngineDepth - 1;
      case 'go':
        // Track the position being evaluated
        if (_position != null) {
          requestedPositions.add(_position!.fen);
        }
      // Don't emit automatically - tests will call emitNextDepth() or emitDepthRange()
      case 'stop':
        // Emit bestmove (first available move) to signal evaluation is complete
        if (_position != null) {
          final bestMove = makeLegalMoves(
            _position!,
          ).entries.map((e) => NormalMove(from: e.key, to: e.value.first)).first;
          final afterBestMove = _position!.play(bestMove);
          final ponderMove = makeLegalMoves(
            afterBestMove,
          ).entries.map((e) => NormalMove(from: e.key, to: e.value.first)).firstOrNull;
          final ponderPart = ponderMove != null ? ' ponder ${ponderMove.uci}' : '';
          _emit('bestmove ${bestMove.uci}$ponderPart\n');
        }
    }
  }

  @override
  ValueListenable<StockfishState> get state => _state;

  @override
  Stream<String> get stdout => _stdoutController.stream;
}

/// A fake Stockfish that returns the first legal move from the current position.
/// This is useful for tests that need realistic game progression.
class LegalMoveFakeStockfish implements Stockfish {
  LegalMoveFakeStockfish();

  final _state = ValueNotifier<StockfishState>(StockfishState.initial);
  final _stdoutController = StreamController<String>.broadcast();

  StockfishFlavor _flavor = StockfishFlavor.sf16;
  Position? _position;

  void _emit(String line) {
    if (!_stdoutController.isClosed) {
      _stdoutController.add(line);
    }
  }

  @override
  StockfishFlavor get flavor => _flavor;

  @override
  String? get variant => null;

  @override
  String? get bigNetPath => null;

  @override
  String? get smallNetPath => null;

  @override
  Future<void> start({
    StockfishFlavor flavor = StockfishFlavor.sf16,
    String? variant,
    String? smallNetPath,
    String? bigNetPath,
  }) async {
    _flavor = flavor;
    _state.value = StockfishState.starting;
    await Future.microtask(() {});
    _state.value = StockfishState.ready;
  }

  @override
  Future<void> quit() async {
    await Future.microtask(() {});
    _state.value = StockfishState.initial;
  }

  @override
  set stdin(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    switch (parts.first) {
      case 'uci':
        final engineName = _flavor == StockfishFlavor.latestNoNNUE
            ? 'Stockfish 17'
            : 'Stockfish 16';
        _emit('id name $engineName\n');
        _emit('uciok\n');
      case 'isready':
        _emit('readyok\n');
      case 'position':
        if (parts.length > 1 && parts[1] == 'fen') {
          final movesPartIndex = parts.indexWhere((p) => p == 'moves');
          if (parts.length > 2) {
            _position = Position.setupPosition(
              Rule.chess,
              Setup.parseFen(
                parts.sublist(2, movesPartIndex != -1 ? movesPartIndex : null).join(' '),
              ),
            );
          }
          if (movesPartIndex != -1) {
            for (var i = movesPartIndex + 1; i < parts.length; i++) {
              final move = Move.parse(parts[i]);
              if (move != null) {
                _position = _position!.play(move);
              }
            }
          }
        }
      case 'go':
        if (_position != null) {
          // Find the first legal move from the current position
          final legalMoves = makeLegalMoves(_position!);
          if (legalMoves.isNotEmpty) {
            final from = legalMoves.keys.first;
            final to = legalMoves[from]!.first;
            final bestMove = NormalMove(from: from, to: to);

            // Also find a ponder move
            final afterBestMove = _position!.play(bestMove);
            final ponderMoves = makeLegalMoves(afterBestMove);
            String ponderPart = '';
            if (ponderMoves.isNotEmpty) {
              final ponderFrom = ponderMoves.keys.first;
              final ponderTo = ponderMoves[ponderFrom]!.first;
              final ponderMove = NormalMove(from: ponderFrom, to: ponderTo);
              ponderPart = ' ponder ${ponderMove.uci}';
            }

            // Emit info and bestmove
            final signedCp = _position!.turn == Side.white ? '23' : '-23';
            _emit(
              'info depth 15 seldepth 8 multipv 1 score cp $signedCp nodes 5000 nps 359000 hashfull 0 tbhits 0 time 1500 pv ${bestMove.uci}\n',
            );
            _emit('bestmove ${bestMove.uci}$ponderPart\n');
          }
        }
    }
  }

  @override
  ValueListenable<StockfishState> get state => _state;

  @override
  Stream<String> get stdout => _stdoutController.stream;
}

/// A fake Stockfish that transitions to error state instead of ready.
/// This simulates initialization failure scenarios.
class ErrorStockfish implements Stockfish {
  ErrorStockfish();

  final _state = ValueNotifier<StockfishState>(StockfishState.initial);
  final _stdoutController = StreamController<String>.broadcast();

  @override
  StockfishFlavor get flavor => StockfishFlavor.sf16;

  @override
  String? get variant => null;

  @override
  String? get bigNetPath => null;

  @override
  String? get smallNetPath => null;

  @override
  Future<void> start({
    StockfishFlavor flavor = StockfishFlavor.sf16,
    String? variant,
    String? smallNetPath,
    String? bigNetPath,
  }) async {
    _state.value = StockfishState.starting;
    await Future.microtask(() {});
    _state.value = StockfishState.error;
  }

  @override
  Future<void> quit() async {
    await Future.microtask(() {});
    _state.value = StockfishState.initial;
  }

  @override
  set stdin(String line) {
    // Do nothing - engine is in error state
  }

  @override
  ValueListenable<StockfishState> get state => _state;

  @override
  Stream<String> get stdout => _stdoutController.stream;
}
