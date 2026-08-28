import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:multistockfish/multistockfish.dart';

/// What the engine was doing when it failed.
enum EngineFailureKind {
  /// The engine could not be started.
  start,

  /// The engine neither started nor failed within the time it is given: it is wedged somewhere in
  /// native code that no timeout of the plugin's covers.
  stuck,

  /// A command could not be delivered to a running engine.
  command,

  /// A running engine reported a failure of its own.
  runtime,
}

/// A failure of the local chess engine, with everything known about it at the moment it was
/// detected.
///
/// The interesting part is [diagnostics]: the engine runs on a thread Dart does not own, so
/// `state` alone only says *that* it failed. The native shim publishes which lifecycle phase and
/// step it was on, which is what distinguishes a device that could not load the network from an
/// engine wedged joining its search threads.
class EngineFailure {
  const EngineFailure({
    required this.kind,
    required this.message,
    required this.flavor,
    required this.variant,
    required this.engineState,
    required this.diagnostics,
    required this.maxMemoryInMb,
    this.error,
    this.stackTrace,
  });

  /// What the engine was doing when it failed.
  final EngineFailureKind kind;

  /// A human-readable description of what went wrong, without the diagnostics.
  final String message;

  /// The engine flavor that was being started or used.
  final StockfishFlavor flavor;

  /// The chess variant the engine was configured for.
  final Variant variant;

  /// The state the plugin reported for the engine when the failure was detected.
  final StockfishState engineState;

  /// What the native engine was doing when the failure was detected.
  ///
  /// Must be read as early as possible: asking a stalled engine to quit moves it on to another
  /// phase and erases the evidence of where it stalled.
  final StockfishDiagnostics diagnostics;

  /// The hash size the engine is configured with, in MB. A boot that dies loading the network is
  /// usually a device that could not spare this much.
  final int maxMemoryInMb;

  /// The error that surfaced the failure, if it came from a throw.
  final Object? error;

  /// The stack trace of [error], if any.
  final StackTrace? stackTrace;

  /// Whether the engine is gone for the rest of the process's life.
  ///
  /// Two ways to get there, and neither can be undone by starting another engine. A native engine
  /// stuck in a transitional phase — most often joining its search threads on shutdown — owns the
  /// process globals the next one would need, so the native library refuses it. And an engine
  /// operation that never returns at all jams the queue every later operation is chained onto.
  /// Either way only restarting the app gives the user an engine again, which is why this is the
  /// one engine failure worth interrupting them about.
  bool get isUnrecoverable => kind == EngineFailureKind.stuck || diagnostics.looksStuck;

  @override
  String toString() =>
      'EngineFailure(${kind.name}): $message '
      '[flavor=${flavor.name}, variant=${variant.name}, state=${engineState.name}, '
      'hash=${maxMemoryInMb}MB]. $diagnostics'
      '${error == null ? '' : ' Error: $error'}';
}

/// Records an engine failure as a non-fatal error in Crashlytics, enriched with the native
/// engine's lifecycle diagnostics so that a failure to start can be told apart from a wedge, and
/// both from the device conditions that produced them.
///
/// This never throws: telemetry must not interfere with the engine.
Future<void> reportEngineFailure(EngineFailure failure) async {
  try {
    final crashlytics = LichessBinding.instance.firebaseCrashlytics;
    final diagnostics = failure.diagnostics;

    await crashlytics.setCustomKey('engine_failure_kind', failure.kind.name);
    await crashlytics.setCustomKey('engine_flavor', failure.flavor.name);
    await crashlytics.setCustomKey('engine_variant', failure.variant.name);
    await crashlytics.setCustomKey('engine_state', failure.engineState.name);
    await crashlytics.setCustomKey('engine_max_memory_mb', failure.maxMemoryInMb);
    await crashlytics.setCustomKey('engine_phase', diagnostics.phase.name);
    await crashlytics.setCustomKey(
      'engine_phase_step',
      diagnostics.step.isEmpty ? 'unknown' : diagnostics.step,
    );
    await crashlytics.setCustomKey('engine_phase_elapsed_ms', diagnostics.elapsed.inMilliseconds);
    await crashlytics.setCustomKey('engine_native_error', diagnostics.lastError ?? 'none');
    await crashlytics.setCustomKey('engine_unrecoverable', failure.isUnrecoverable);

    await crashlytics.recordError(
      failure.error ?? failure.message,
      failure.stackTrace,
      reason: failure.toString(),
      fatal: false,
    );
  } catch (e) {
    debugPrint('Failed to report engine failure: $e');
  }
}
