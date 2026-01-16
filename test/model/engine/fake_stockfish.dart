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
    scheduleMicrotask(() {
      _stdoutController.add(line);
    });
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
