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
  Stream<EngineState> get stateStream;
  String get name;
  Stream<EvalResult> start(Work work);
  void stop();
  void dispose();
}

class StockfishEngine implements Engine {
  StockfishEngine() : _protocol = UCIProtocol();

  Stockfish? _stockfish;
  String _name = 'Stockfish';
  bool _loaded = false;
  StreamSubscription<String>? _stdoutSubscription;
  StreamSubscription<bool>? _isComputingSubscription;

  final StreamController<EngineState> _stateStreamController =
      StreamController<EngineState>.broadcast()..add(EngineState.initial);

  final UCIProtocol _protocol;
  final _log = Logger('StockfishEngine');

  @override
  EngineState get state => _stockfish == null
      ? EngineState.initial
      : !_loaded
          ? EngineState.loading
          : _protocol.isComputing
              ? EngineState.computing
              : EngineState.idle;

  @override
  Stream<EngineState> get stateStream => _stateStreamController.stream;

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
        _stateStreamController.sink.add(EngineState.loading);
        _stockfish = stockfish;
        _stdoutSubscription = stockfish.stdout.listen((line) {
          _protocol.received(line);
        });
        _isComputingSubscription =
            _protocol.isComputingStream.listen((isComputing) {
          if (isComputing) {
            _stateStreamController.sink.add(EngineState.computing);
          } else {
            _stateStreamController.sink.add(EngineState.idle);
          }
        });
        _protocol.connected((String cmd) {
          stockfish.stdin = cmd;
        });
        _protocol.engineName.then((name) {
          _name = name;
          _loaded = true;
          _stateStreamController.sink.add(EngineState.idle);
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
    _isComputingSubscription?.cancel();
    _protocol.disconnected();
    _stockfish?.dispose();
    _stockfish = null;
  }
}
