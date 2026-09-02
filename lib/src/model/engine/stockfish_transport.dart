import 'dart:async';

import 'package:lichess_mobile/src/model/engine/engine_diagnostics.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_transport.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

final _logger = Logger('StockfishTransport');

/// An [EngineTransport] over a `multistockfish` engine handle.
class StockfishTransport implements EngineTransport {
  StockfishTransport._(this.spec, this._stockfish) {
    _controller.onListen = _replayStartupLines;
    _stockfish.state.addListener(_onStockfishStateChange);
  }

  /// Starts an engine for [spec] and completes when it is ready for commands.
  ///
  /// Throws whatever the plugin throws when the engine will not start — a [TimeoutException] with
  /// the native diagnostics in its message, most often.
  static Future<StockfishTransport> connect(StockfishSpec spec) async {
    // The output is collected from before the handle exists, because the plugin runs the `uci`
    // handshake itself: a listener attached afterwards has already missed the engine's name and
    // its option declarations, and those declared defaults are what lets a search be given a
    // complete option set.
    StockfishTransport? transport;
    final buffered = <String>[];

    final stockfish = await Stockfish.create(
      flavor: spec.flavor,
      bigNetPath: spec.bigNetPath,
      smallNetPath: spec.smallNetPath,
      onStdout: (line) => transport == null ? buffered.add(line) : transport._receive(line),
    );

    if (stockfish.state.value != StockfishState.ready) {
      // The plugin reports some failures by state rather than by throwing, and an engine that is
      // already broken is not something to wrap a transport around.
      final state = stockfish.state.value;
      await stockfish.dispose().catchError((_) {});
      throw StateError('The engine reported ${state.name} instead of becoming ready');
    }

    transport = StockfishTransport._(spec, stockfish);
    buffered.forEach(transport._receive);
    buffered.clear();
    return transport;
  }

  @override
  final StockfishSpec spec;

  final Stockfish _stockfish;

  final _controller = StreamController<String>.broadcast();
  final _death = Completer<EngineFailure?>();

  /// The lines the engine wrote before anyone could listen, replayed to the first listener.
  final List<String> _startupLines = [];
  bool _replayed = false;

  bool _disposing = false;
  Future<void>? _disposal;

  /// The command being written, while one is.
  String? _sending;

  @override
  Stream<String> get lines => _controller.stream;

  @override
  Future<EngineFailure?> get death => _death.future;

  @override
  bool get isDead => _death.isCompleted;

  @override
  EngineDiagnostics? get diagnostics => EngineDiagnostics.stockfish(_stockfish.diagnostics);

  @override
  void send(String command) {
    if (_disposing || isDead) {
      _logger.fine('Dropping "$command": the engine is gone or on its way out.');
      return;
    }
    try {
      // Remembered for the duration of the write, because the plugin reports the failure that
      // makes a session unusable by moving its state rather than by throwing: without this the
      // state listener would have to call it a runtime failure of unknown origin.
      _sending = command;
      _stockfish.stdin = command;
    } catch (e, st) {
      // The setter only throws for a session the plugin has already given up on, so there is
      // nothing left to salvage; the state listener may have reported it first.
      _die(
        _failure(
          EngineFailureKind.command,
          'The engine refused the command "$command"',
          error: e,
          stackTrace: st,
        ),
      );
    } finally {
      _sending = null;
    }
  }

  @override
  Future<void> dispose() {
    if (_disposal case final disposal?) return disposal;
    _disposing = true;
    return _disposal = _stockfish
        .dispose()
        .catchError((Object e, StackTrace st) {
          _logger.warning('The engine could not be disposed cleanly', e, st);
        })
        .whenComplete(() {
          _die(null);
          _stockfish.state.removeListener(_onStockfishStateChange);
          if (!_controller.isClosed) _controller.close();
        });
  }

  void _replayStartupLines() {
    if (_replayed) return;
    _replayed = true;
    for (final line in _startupLines) {
      _receive(line);
    }
    _startupLines.clear();
  }

  void _receive(String line) {
    if (_controller.isClosed) return;
    final trimmed = line.trim();
    if (trimmed.isEmpty) return;
    if (_replayed) {
      _controller.add(trimmed);
    } else {
      _startupLines.add(trimmed);
    }
  }

  void _onStockfishStateChange() {
    switch (_stockfish.state.value) {
      case StockfishState.starting:
      case StockfishState.ready:
        break;
      case StockfishState.error:
        _die(switch (_sending) {
          final command? => _failure(
            EngineFailureKind.command,
            'The engine could not be sent the command "$command", and the session is '
            'unusable from here on',
          ),
          null => _failure(
            EngineFailureKind.runtime,
            _disposing
                ? 'The engine failed while shutting down'
                : 'The engine failed while it was running',
          ),
        });
      // `initial` is what the plugin's deprecated singleton reports after a clean quit; a handle
      // from create() ends as `disposed`. Either way the engine is gone and nothing went wrong.
      case StockfishState.initial:
      case StockfishState.disposed:
        _die(null);
    }
  }

  /// Ends the session: nothing more is sent, nothing more is delivered, and [death] is answered.
  void _die(EngineFailure? failure) {
    if (_death.isCompleted) return;
    _death.complete(failure);
    if (!_controller.isClosed) _controller.close();
  }

  EngineFailure _failure(
    EngineFailureKind kind,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) => EngineFailure(
    kind: kind,
    message: message,
    engine: spec.label,
    engineState: _stockfish.state.value.name,
    diagnostics: EngineDiagnostics.stockfish(_stockfish.diagnostics),
    error: error,
    stackTrace: stackTrace,
  );
}
