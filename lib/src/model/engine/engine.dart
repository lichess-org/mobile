import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/engine/uci_protocol.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

enum EngineState { initial, loading, idle, computing, error }

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

  /// Whether the engine is disposed.
  ///
  /// This will be `true` once [dispose] is called. Once the engine is disposed, it cannot be
  /// used anymore, and [start] and [stop] methods will throw a [StateError].
  bool get isDisposed;

  /// Dispose the engine. It cannot be used after this method is called.
  ///
  /// It is safe to call this method multiple times.
  void dispose();
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

  Stockfish get _stockfish => LichessBinding.instance.stockfish;

  String _name = 'Stockfish';
  StreamSubscription<String>? _stdoutSubscription;
  bool _isDisposed = false;
  bool _initInProgress = false;

  final _state = ValueNotifier(EngineState.initial);

  final _log = Logger('StockfishEngine');

  @override
  ValueListenable<EngineState> get state => _state;

  @override
  String get name => _name;

  @override
  bool get isDisposed => _isDisposed;

  @override
  Stream<EvalResult> start(Work work) {
    if (isDisposed) {
      throw StateError('Engine is disposed');
    }

    _log.info('engine start at ply ${work.position.ply} and path ${work.path}');
    _protocol.compute(work);

    if (!_initInProgress && _stockfish.state.value != StockfishState.ready) {
      _initInProgress = true;
      _state.value = EngineState.loading;
      _initStockfish();
    }

    return _protocol.evalStream.where((e) => e.$1 == work);
  }

  Future<void> _initStockfish() async {
    try {
      _stockfish.state.addListener(_stockfishStateListener);

      await _stockfish.quit();
      if (isDisposed) return;

      await _stockfish.start(flavor: flavor, smallNetPath: _smallNetPath, bigNetPath: _bigNetPath);
      if (isDisposed) return;

      _stdoutSubscription = _stockfish.stdout.listen(_protocol.received);
      _protocol.connected((cmd) => _stockfish.stdin = cmd);
      _protocol.isComputing.addListener(_computingListener);
      _protocol.engineName.then((name) => _name = name);
    } catch (e, s) {
      if (!isDisposed) {
        _log.severe('error starting stockfish', e, s);
        _state.value = EngineState.error;
      }
    } finally {
      _initInProgress = false;
    }
  }

  void _computingListener() {
    _state.value = _protocol.isComputing.value ? EngineState.computing : EngineState.idle;
  }

  void _stockfishStateListener() {
    switch (_stockfish.state.value) {
      case StockfishState.ready:
        _state.value = EngineState.idle;
      case StockfishState.error:
        _state.value = EngineState.error;
      default:
        break;
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
  void dispose() {
    if (isDisposed) return;
    _log.fine('disposing engine');
    _isDisposed = true;
    _stdoutSubscription?.cancel();
    _protocol.dispose();
    _stockfish.state.removeListener(_stockfishStateListener);
    _stockfish.quit();
    _state.dispose();
  }
}
