import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/engine/uci_protocol.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:logging/logging.dart';
import 'package:stockfish/stockfish.dart';

enum EngineState { initial, loading, idle, computing, error, disposed }

abstract class Engine {
  /// The current state of the engine.
  ValueListenable<EngineState> get state;

  /// The name of the engine.
  String get name;

  /// Start the engine with the given [work].
  Stream<EvalResult> start(Work work);

  /// Stop the engine current computation.
  void stop();

  /// A future that completes once the underlying engine process is exited.
  Future<void> get exited;

  /// Whether the engine is disposed.
  ///
  /// This will be `true` once [dispose] is called. Once the engine is disposed, it cannot be
  /// used anymore, and [start] and [stop] methods will throw a [StateError].
  bool get isDisposed;

  /// Dispose the engine. It cannot be used after this method is called.
  ///
  /// Returns the same future as [exited], that completes once the underlying engine process is exited.
  ///
  /// It is safe to call this method multiple times.
  Future<void> dispose();
}

class StockfishEngine implements Engine {
  StockfishEngine() : _protocol = UCIProtocol();

  Stockfish? _stockfish;
  String _name = 'Stockfish';
  StreamSubscription<String>? _stdoutSubscription;

  bool _isDisposed = false;

  final _state = ValueNotifier(EngineState.initial);

  final UCIProtocol _protocol;
  final _log = Logger('StockfishEngine');

  /// A completer that completes once the underlying engine has exited.
  final _exitCompleter = Completer<void>();

  @override
  ValueListenable<EngineState> get state => _state;

  @override
  String get name => _name;

  @override
  Future<void> get exited => _exitCompleter.future;

  @override
  bool get isDisposed => _isDisposed;

  @override
  Stream<EvalResult> start(Work work) {
    if (isDisposed) {
      throw StateError('Engine is disposed');
    }

    _log.info('engine start at ply ${work.ply} and path ${work.path}');
    _protocol.compute(work);

    if (_stockfish == null) {
      final stockfishFuture = LichessBinding.instance.stockfishFactory();

      stockfishFuture
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
      _exitCompleter.complete();
      _stockfish?.state.removeListener(_stockfishStateListener);
      _state.dispose();
    }
  }

  @override
  void stop() {
    if (isDisposed) {
      throw StateError('Engine is disposed');
    }
    _protocol.compute(null);
  }

  @override
  Future<void> dispose() {
    if (isDisposed) {
      return exited;
    }
    _log.fine('disposing engine');
    _isDisposed = true;
    _stdoutSubscription?.cancel();
    _protocol.dispose();
    _stockfish?.dispose();
    return exited;
  }
}

/// A factory to create a [Stockfish] asynchronously.
///
/// This is useful to be able to mock [Stockfish] in tests.
class StockfishFactory {
  const StockfishFactory();

  Future<Stockfish> call() => stockfishAsync();
}
