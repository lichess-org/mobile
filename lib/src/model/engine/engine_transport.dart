import 'dart:async';

import 'package:lichess_mobile/src/model/engine/engine_diagnostics.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';

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
  /// Never throws: a write that leaves the session unusable kills the transport and reports the
  /// failure through [death] instead.
  void send(String command);

  /// Completes when the engine is gone, with the failure if it died badly and null if it was
  /// disposed or exited cleanly.
  ///
  /// A transport's whole lifetime is this one future: alive is "not yet completed", and there is
  /// no second thing to keep in step with it. Starting is expressed by the
  /// `Future<EngineTransport>` a backend returns — a transport that exists is already alive and
  /// answering — and searching belongs to the layers above, not to the pipe.
  Future<EngineFailure?> get death;

  /// Whether the engine is gone, which is [death] asked synchronously.
  bool get isDead;

  /// What the native engine is doing right now, or null if it can no longer be asked.
  EngineDiagnostics? get diagnostics;

  /// Quits the engine and waits for it to exit.
  ///
  /// Commands are dropped from the moment this is called, but the transport is only dead — [death]
  /// completed, [isDead] true — once the engine has really exited.
  Future<void> dispose();
}
