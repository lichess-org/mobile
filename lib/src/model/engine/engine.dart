import 'dart:async';
import 'package:stockfish/stockfish.dart';
import 'package:logging/logging.dart';

import 'uci_protocol.dart';
import 'work.dart';

enum EngineState {
  initial,
  loading,
  idle,
  computing,
}

abstract class Engine {
  EngineState get state;
  String get name;
  Stream<EvalResult> start(Work work);
  void stop();
  void dispose();
}

class StockfishEngine implements Engine {
  StockfishEngine() : _protocol = UCIProtocol();

  Stockfish? _stockfish;
  StreamSubscription<String>? _stdoutSubscription;
  final UCIProtocol _protocol;
  final _log = Logger('StockfishEngine');

  @override
  EngineState get state => _stockfish == null
      ? EngineState.initial
      : _protocol.engineName == null
          ? EngineState.loading
          : _protocol.isComputing()
              ? EngineState.computing
              : EngineState.idle;

  @override
  String get name => _protocol.engineName ?? 'Stockfish';

  @override
  Stream<EvalResult> start(Work work) {
    _log.info('engine start at ply ${work.ply} moves ${work.moves.join(' ')}');
    _protocol.compute(work);

    if (_stockfish == null) {
      stockfishAsync().then((stockfish) {
        _stockfish = stockfish;
        _stdoutSubscription = stockfish.stdout.listen((line) {
          _protocol.received(line);
        });
        _protocol.connected((String cmd) {
          stockfish.stdin = cmd;
        });
      });
    }

    return _protocol.evalStream.where((tuple) {
      return tuple.$1 == work;
    });
  }

  @override
  void stop() {
    _protocol.compute(null);
  }

  @override
  void dispose() {
    _log.info('engine dispose');
    _stdoutSubscription?.cancel();
    _protocol.disconnected();
    _stockfish?.dispose();
    _stockfish = null;
  }
}
