import 'dart:async';

import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:stockfish/stockfish.dart';

class FakeStockfishFactory extends StockfishFactory {
  const FakeStockfishFactory();

  @override
  Future<Stockfish> create() async => Future.value(FakeStockfish());
}

/// A fake implementation of [Stockfish].
class FakeStockfish implements Stockfish {
  final _state = ValueNotifier<StockfishState>(StockfishState.ready);
  final _stdoutController = StreamController<String>();

  FakeStockfish();

  @override
  set stdin(String line) {
    final parts = line.trim().split(RegExp(r'\s+'));
    switch (parts.first) {
      case 'uci':
        _stdoutController.add('uciok\n');
      case 'isready':
        _stdoutController.add('readyok\n');
      case 'go':
        if (parts.length > 1 && parts[1] == 'movetime') {
          if (parts.length > 2) {
            final moveTime = int.tryParse(parts[2]);
            if (moveTime != null) {
              for (var i = 0; i < 10; i++) {
                _stdoutController.add(
                  'info depth 6 seldepth 8 multipv 1 score cp 23 nodes 359 nps 359000 hashfull 0 tbhits 0 time 1 pv e2e4 e7e5 g1f3 b8c6 f1b5 g8f6\n',
                );
              }
              _stdoutController.add('bestmove e2e4 ponder e7e5\n');
            }
          }
        }
    }
  }

  @override
  void dispose() {}

  @override
  ValueListenable<StockfishState> get state => _state;

  @override
  Stream<String> get stdout => _stdoutController.stream;

  @override
  Completer<Stockfish>? get completer => throw UnimplementedError();
}
