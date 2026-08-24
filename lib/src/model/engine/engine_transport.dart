import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

final _logger = Logger('EngineTransport');

/// A snapshot of what a native engine is doing.
///
/// Still the plugin's own type: the two engine backends the app will run are close enough that
/// generalising this is worth doing only once the second one exists.
typedef EngineDiagnostics = StockfishDiagnostics;

/// Whether a transport can still be talked to.
///
/// Deliberately only two values. Starting is expressed by the `Future<EngineTransport>` a backend
/// returns — a transport that exists is already alive and answering — and searching belongs to the
/// layers above, not to the pipe.
enum EngineStatus { ready, dead }

/// A running native engine, seen as a line-oriented pipe with a lifetime.
///
/// Backends are responsible for their own start-up handshake, so everything that can fail before
/// the engine answers fails the future that produces the transport, and there is no "loading"
/// state to model up here.
abstract class EngineTransport {
  /// What this transport was created for.
  EngineSpec get spec;

  /// Every line the engine has written, including the ones it wrote while starting up.
  ///
  /// Broadcast, and closed when the engine is gone. The start-up lines matter: the plugin runs the
  /// `uci` handshake inside its own create, so `id name` and the engine's `option` declarations
  /// are already in the past by the time anyone can subscribe. A backend replays them to its first
  /// listener rather than losing them.
  Stream<String> get lines;

  /// Sends a command.
  ///
  /// Never throws: a write that leaves the session unusable moves [status] to [EngineStatus.dead]
  /// and reports the failure through [death] instead.
  void send(String command);

  ValueListenable<EngineStatus> get status;

  /// Completes when the engine is gone, with the failure if it died badly and null if it was
  /// disposed or exited cleanly.
  Future<EngineFailure?> get death;

  /// What the native engine is doing right now, or null if it can no longer be asked.
  EngineDiagnostics? get diagnostics;

  /// Quits the engine and waits for it to exit.
  Future<void> dispose();
}

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

    final stockfish = await LichessBinding.instance.createStockfish(
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
  final _status = ValueNotifier(EngineStatus.ready);
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
  ValueListenable<EngineStatus> get status => _status;

  @override
  Future<EngineFailure?> get death => _death.future;

  @override
  EngineDiagnostics? get diagnostics => _stockfish.diagnostics;

  @override
  void send(String command) {
    if (_status.value == EngineStatus.dead) {
      _logger.fine('Dropping "$command": the engine is gone.');
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
    _status.value = EngineStatus.dead;
    return _disposal = _stockfish
        .dispose()
        .catchError((Object e, StackTrace st) {
          _logger.warning('The engine could not be disposed cleanly', e, st);
        })
        .whenComplete(() {
          if (!_death.isCompleted) _death.complete(null);
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
    _status.value = EngineStatus.dead;
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
    flavor: spec.flavor,
    engineState: _stockfish.state.value,
    diagnostics: _stockfish.diagnostics,
    error: error,
    stackTrace: stackTrace,
  );
}
