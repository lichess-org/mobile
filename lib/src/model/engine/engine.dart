import 'dart:async';
import 'package:stockfish/stockfish.dart';
import 'package:tuple/tuple.dart';

import 'package:lichess_mobile/src/common/eval.dart';
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
  Future<Stream<Tuple2<Work, ClientEval>>> start(Work work);
  void stop();
  void dispose();
}

class StockfishEngine implements Engine {
  StockfishEngine() : _protocol = UCIProtocol();

  Stockfish? _stockfish;
  StreamSubscription<String>? _stdoutSubscription;
  final UCIProtocol _protocol;

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
  Future<Stream<Tuple2<Work, ClientEval>>> start(Work work) async {
    _protocol.compute(work);

    if (_stockfish == null) {
      _stockfish = await stockfishAsync();
      _stdoutSubscription = _stockfish?.stdout.listen((line) {
        _protocol.received(line);
      });
      _protocol.connected((String cmd) {
        _stockfish?.stdin = cmd;
      });
    }

    return _protocol.evalStream.where((tuple) {
      return tuple.item1 == work;
    });
  }

  @override
  void stop() {
    _protocol.compute(null);
  }

  @override
  void dispose() {
    _stdoutSubscription?.cancel();
    _protocol.disconnected();
    _stockfish?.dispose();
    _stockfish = null;
  }
}
