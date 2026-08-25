import 'package:lc0/lc0.dart';
import 'package:multistockfish/multistockfish.dart';

/// A snapshot of what a native engine is doing, whichever backend it is.
///
/// Both plugins publish the same thing — a lifecycle phase, a step within it,
/// how long it has been there, and whatever the native side last complained
/// about — because the engine runs on a thread Dart does not own and `state`
/// alone only says *that* it failed. This is that snapshot with the plugin's
/// types flattened out, so an [EngineFailure] can describe either engine.
class EngineDiagnostics {
  const EngineDiagnostics({
    required this.phase,
    required this.step,
    required this.elapsed,
    required this.looksStuck,
    this.lastError,
  });

  EngineDiagnostics.stockfish(StockfishDiagnostics diagnostics)
    : phase = diagnostics.phase.name,
      step = diagnostics.step,
      elapsed = diagnostics.elapsed,
      looksStuck = diagnostics.looksStuck,
      lastError = diagnostics.lastError;

  EngineDiagnostics.lc0(Lc0Diagnostics diagnostics)
    : phase = diagnostics.phase.name,
      step = diagnostics.step,
      elapsed = diagnostics.elapsed,
      looksStuck = diagnostics.looksStuck,
      lastError = diagnostics.lastError;

  /// The engine's lifecycle phase, e.g. `engineBooting` or `uciLoop`.
  final String phase;

  /// The step within [phase], e.g. `nnue` or `engine_teardown`.
  final String step;

  /// How long the engine has been on this step.
  final Duration elapsed;

  /// Whether the engine looks wedged rather than merely busy.
  ///
  /// Decided by the plugin, because what counts as too long depends on the
  /// engine: loading an LC0 network is real work where the equivalent Stockfish
  /// transition is a handover.
  final bool looksStuck;

  /// The most recent error reported by the native library, if any.
  final String? lastError;

  @override
  String toString() {
    final buffer = StringBuffer(
      'phase=$phase${step.isEmpty ? '' : ' step=$step'} for ${elapsed.inMilliseconds}ms',
    );
    if (looksStuck) buffer.write(' (STUCK)');
    if (lastError != null) buffer.write('; native error: $lastError');
    return buffer.toString();
  }
}
