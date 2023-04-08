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
  EngineState get state;
  String get name;
  Future<void> start(Work work);
  void stop();
  void dispose();
}

class StockfishEngine implements Engine {
  StockfishEngine() : _protocol = UCIProtocol();

  Stockfish? _stockfish;
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
  Future<void> start(Work work) async {
    _protocol.compute(work);

    if (_stockfish == null) {
      _stockfish = await stockfishAsync();
      _stockfish?.stdout.listen((line) {
        _protocol.received(line);
      });
      _protocol.connected((String cmd) {
        _stockfish?.stdin = cmd;
      });
    }
  }

  @override
  void stop() {
    _protocol.compute(null);
  }

  @override
  void dispose() {
    _stockfish?.dispose();
    _stockfish = null;
  }
}
