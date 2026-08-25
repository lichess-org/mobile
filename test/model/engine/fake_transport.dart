import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/engine/engine_diagnostics.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_transport.dart';

/// The `option` declarations a Stockfish-like engine prints during its `uci` handshake.
///
/// Only the ones the app ever sets, which are the only ones option hygiene has to put back.
const kFakeOptionDeclarations = [
  'option name Threads type spin default 1 min 1 max 1024',
  'option name Hash type spin default 16 min 1 max 33554432',
  'option name MultiPV type spin default 1 min 1 max 256',
  'option name Skill Level type spin default 20 min -20 max 20',
  'option name UCI_Chess960 type check default false',
  'option name UCI_Variant type combo default chess var chess var crazyhouse var atomic',
];

/// An [EngineTransport] that records what was sent to it and lets a test answer by hand.
///
/// This is the seam for testing the UCI protocol itself: no plugin, no isolates, no engine — just
/// the lines in and the lines out.
class FakeTransport implements EngineTransport {
  FakeTransport({
    this.spec = const StockfishSpec.sf16(),
    List<String> startupLines = const [
      'Stockfish 16.1 by the Stockfish developers',
      'id name Stockfish 16.1',
      ...kFakeOptionDeclarations,
      'uciok',
    ],
  }) {
    _pending.addAll(startupLines);
    _controller.onListen = () {
      if (_replayed) return;
      _replayed = true;
      for (final line in _pending) {
        _controller.add(line);
      }
      _pending.clear();
    };
  }

  @override
  final EngineSpec spec;

  /// Every command the engine was sent, in order.
  final List<String> commands = [];

  final _controller = StreamController<String>.broadcast();
  final _status = ValueNotifier(EngineStatus.ready);
  final _death = Completer<EngineFailure?>();
  final _pending = <String>[];
  bool _replayed = false;

  /// The commands sent since the last [takeCommands].
  List<String> takeCommands() {
    final taken = List<String>.of(commands);
    commands.clear();
    return taken;
  }

  /// Answers with a line, as the engine would.
  void emit(String line) {
    if (!_controller.isClosed) _controller.add(line);
  }

  /// Kills the engine, with [failure] if it died badly.
  void die([EngineFailure? failure]) {
    if (_death.isCompleted) return;
    _status.value = EngineStatus.dead;
    _death.complete(failure);
    if (!_controller.isClosed) _controller.close();
  }

  @override
  Stream<String> get lines => _controller.stream;

  @override
  ValueListenable<EngineStatus> get status => _status;

  @override
  Future<EngineFailure?> get death => _death.future;

  @override
  EngineDiagnostics? get diagnostics => const EngineDiagnostics(
    phase: 'idle',
    step: 'idle',
    elapsed: Duration.zero,
    looksStuck: false,
  );

  @override
  void send(String command) {
    if (_status.value == EngineStatus.dead) return;
    commands.add(command);
  }

  @override
  Future<void> dispose() async {
    die();
  }
}
