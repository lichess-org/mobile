import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:stockfish/stockfish.dart';

import 'uci_protocol.dart';
import 'work.dart';

enum EngineState {
  initial,
  loading,
  idle,
  computing,
}

abstract class Engine {
  ValueListenable<EngineState> get state;
  String get name;
  Stream<EvalResult> start(Work work);
  void stop();
  void dispose();
}

class StockfishEngine implements Engine {
  StockfishEngine() : _protocol = UCIProtocol();

  Stockfish? _stockfish;
  String _name = 'Stockfish';
  StreamSubscription<String>? _stdoutSubscription;

  final _state = ValueNotifier(EngineState.initial);

  final UCIProtocol _protocol;
  final _log = Logger('StockfishEngine');

  @override
  ValueListenable<EngineState> get state => _state;

  @override
  String get name => _name;

  @override
  Stream<EvalResult> start(Work work) {
    _log.info(
      'engine start at ply ${work.ply} and path ${work.path}',
    );
    _protocol.compute(work);

    if (_stockfish == null) {
      stockfishAsync().then((stockfish) {
        _state.value = EngineState.loading;
        _stockfish = stockfish;
        _stdoutSubscription = stockfish.stdout.listen((line) {
          _protocol.received(line);
        });
        _protocol.isComputing.addListener(() {
          if (_protocol.isComputing.value) {
            _state.value = EngineState.computing;
          } else {
            _state.value = EngineState.idle;
          }
        });
        _protocol.connected((String cmd) {
          stockfish.stdin = cmd;
        });
        _protocol.engineName.then((name) {
          _name = name;
          _state.value = EngineState.idle;
        });
      });
    }

    return _protocol.evalStream.where((e) => e.$1 == work);
  }

  @override
  void stop() {
    _protocol.compute(null);
  }

  @override
  void dispose() {
    _log.info('engine disposed');
    _stdoutSubscription?.cancel();
    _state.dispose();
    _protocol.dispose();
    _stockfish?.dispose();
    _stockfish = null;
  }
}
