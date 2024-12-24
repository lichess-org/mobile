import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/engine/uci_protocol.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:logging/logging.dart';
import 'package:stockfish/stockfish.dart';

enum EngineState { initial, loading, idle, computing, error, disposed }

abstract class Engine {
  ValueListenable<EngineState> get state;
  String get name;
  Stream<EvalResult> start(Work work);
  void stop();
  Future<void> dispose();
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
    _log.info('engine start at ply ${work.ply} and path ${work.path}');
    _protocol.compute(work);

    if (_stockfish == null) {
      stockfishAsync()
          .then((stockfish) {
            _state.value = EngineState.loading;
            _stockfish = stockfish;
            _stdoutSubscription = stockfish.stdout.listen((line) {
              _protocol.received(line);
            });
            stockfish.state.addListener(_stockfishStateListener);
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
            });
          })
          .catchError((Object e, StackTrace s) {
            _log.severe('error loading stockfish', e, s);
            _state.value = EngineState.error;
          });
    }

    return _protocol.evalStream.where((e) => e.$1 == work);
  }

  void _stockfishStateListener() {
    if (_stockfish?.state.value case StockfishState.ready) {
      _state.value = EngineState.idle;
    } else if (_stockfish?.state.value case StockfishState.error) {
      _state.value = EngineState.error;
    } else if (_stockfish?.state.value case StockfishState.disposed) {
      _log.info('engine disposed');
      _state.value = EngineState.disposed;
      _state.dispose();
      _stockfish?.state.removeListener(_stockfishStateListener);
    }
  }

  @override
  void stop() {
    _protocol.compute(null);
  }

  @override
  Future<void> dispose() {
    _log.fine('disposing engine');
    if (_stockfish == null || _stockfish?.state.value == StockfishState.disposed) {
      return Future.value();
    }
    _stdoutSubscription?.cancel();
    _protocol.dispose();
    final completer = Completer<void>();
    void stateListener() {
      if (_stockfish?.state.value case StockfishState.disposed) {
        _stockfish?.state.removeListener(stateListener);
        completer.complete();
      }
    }

    _stockfish!.state.addListener(stateListener);
    _stockfish?.dispose();
    return completer.future;
  }
}
