import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/engine/uci_protocol.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

enum EngineState { initial, loading, idle, computing, error, disposed }

/// An engine that can compute chess positions.
///
/// This is a high-level abstraction over a chess engine process.
///
/// See [StockfishEngine] for a concrete implementation.
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

const _nnueDownloadUrl = '$kLichessCDNHost/assets/lifat/nnue/';

/// A concrete implementation of [Engine] that uses Stockfish as the underlying engine.
class StockfishEngine implements Engine {
  StockfishEngine(this.flavor, {String? smallNetPath, String? bigNetPath})
    : _protocol = UCIProtocol(),
      _smallNetPath = smallNetPath,
      _bigNetPath = bigNetPath,
      assert(
        flavor != StockfishFlavor.latestNoNNUE || smallNetPath != null && bigNetPath != null,
        'NNUE paths must be provided for chess flavor',
      );

  /// URL to download the latest big NNUE network.
  static final bigNetUrl = Uri.parse('$_nnueDownloadUrl${Stockfish.latestBigNNUE}');

  /// SHA256 hash (first 12 digits) of the latest big NNUE network.
  static final bigNetHash = Stockfish.latestBigNNUE.substring(3, 15);

  /// URL to download the latest small NNUE network.
  static final smallNetUrl = Uri.parse('$_nnueDownloadUrl${Stockfish.latestSmallNNUE}');

  /// SHA256 hash (first 12 digits) of the latest small NNUE network.
  static final smallNetHash = Stockfish.latestSmallNNUE.substring(3, 15);

  final StockfishFlavor flavor;
  final UCIProtocol _protocol;
  final String? _smallNetPath;
  final String? _bigNetPath;

  Stockfish? _stockfish;
  String _name = 'Stockfish';
  StreamSubscription<String>? _stdoutSubscription;

  bool _isDisposed = false;

  final _state = ValueNotifier(EngineState.initial);

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

    _log.info('engine start at ply ${work.position.ply} and path ${work.path}');
    _protocol.compute(work);

    if (_stockfish == null) {
      try {
        final stockfish = LichessBinding.instance.stockfishFactory(
          flavor,
          smallNetPath: _smallNetPath,
          bigNetPath: _bigNetPath,
        );
        _stockfish = stockfish;

        _state.value = EngineState.loading;
        _stdoutSubscription = stockfish.stdout.listen((line) {
          _protocol.received(line);
        });

        stockfish.state.addListener(_stockfishStateListener);

        // Ensure the engine is ready before sending commands
        void onReadyOnce() {
          if (stockfish.state.value == StockfishState.ready) {
            _protocol.connected((String cmd) {
              stockfish.stdin = cmd;
            });
            stockfish.state.removeListener(onReadyOnce);
          }
        }

        stockfish.state.addListener(onReadyOnce);

        _protocol.isComputing.addListener(() {
          if (_protocol.isComputing.value) {
            _state.value = EngineState.computing;
          } else {
            _state.value = EngineState.idle;
          }
        });
        _protocol.engineName.then((name) {
          _name = name;
        });
      } catch (e, s) {
        _stockfish = null;
        _log.severe('error loading stockfish', e, s);
        _state.value = EngineState.error;
      }
    }

    return _protocol.evalStream.where((e) => e.$1 == work);
  }

  void _stockfishStateListener() {
    switch (_stockfish?.state.value) {
      case StockfishState.ready:
        _state.value = EngineState.idle;
      case StockfishState.error:
        _state.value = EngineState.error;
      case StockfishState.disposed:
        _log.info('engine disposed');
        _state.value = EngineState.disposed;
        _exitCompleter.complete();
        _stockfish?.state.removeListener(_stockfishStateListener);
        _state.dispose();
      default:
      // do nothing
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
    if (_stockfish != null) {
      switch (_stockfish!.state.value) {
        case StockfishState.disposed:
        case StockfishState.error:
          if (_exitCompleter.isCompleted == false) {
            _exitCompleter.complete();
          }
        case StockfishState.ready:
          _stockfish!.dispose();
        case StockfishState.initial:
        case StockfishState.starting:
          // wait to be ready, then dispose
          void onReadyOnce() {
            if (_stockfish!.state.value == StockfishState.ready) {
              _stockfish!.dispose();
              _stockfish!.state.removeListener(onReadyOnce);
            }
          }
          _stockfish!.state.addListener(onReadyOnce);
      }
    } else {
      if (_exitCompleter.isCompleted == false) {
        _exitCompleter.complete();
      }
    }
    return exited;
  }
}

/// A factory to create a [Stockfish].
///
/// This is useful to be able to mock [Stockfish] in tests.
class StockfishFactory {
  const StockfishFactory();

  Stockfish call(
    StockfishFlavor flavor, {

    /// Full path to the small net file for NNUE evaluation.
    String? smallNetPath,

    /// Full path to the big net file for NNUE evaluation.
    String? bigNetPath,
  }) => Stockfish(flavor: flavor, smallNetPath: smallNetPath, bigNetPath: bigNetPath);
}
