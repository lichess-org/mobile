import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_failure.dart';
import 'package:lichess_mobile/src/model/engine/engine_slot.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/model/engine/engine_transport.dart';
import 'package:lichess_mobile/src/model/engine/lc0_transport.dart';
import 'package:lichess_mobile/src/model/engine/stockfish_transport.dart';
import 'package:logging/logging.dart';

final _logger = Logger('EngineFactory');

/// How long a create is given — including waiting for the engine it replaces to finish exiting —
/// before the engine is declared stuck.
///
/// The plugin bounds every step it takes: 5s to reach the engine's greeting, 5s more to reach
/// `uciok`, 5s for a quit. This is the backstop for the case none of those cover, an engine wedged
/// somewhere in native code that never reports anything at all, which would otherwise leave the
/// app showing an engine that is loading and always will be.
const kEngineCreateTimeout = Duration(seconds: 20);

/// Starts an engine for [spec] and hands back a transport that is already answering.
///
/// This is the seam the tests replace: a fake connector hands out fake transports, so nothing
/// process-wide has to be faked or reset between tests.
typedef EngineConnector = Future<EngineTransport> Function(EngineSpec spec);

/// Thrown when two engines are asked for on one [EngineSlot] at the same time.
///
/// This is a programming error, not a runtime condition: it means the spec→slot mapping is wrong,
/// or that someone got hold of an engine without going through the factory. Killing the incumbent
/// would hide the bug and take away an engine somebody else is using.
class EngineSlotConflict implements Exception {
  const EngineSlotConflict(this.requested, this.live);

  final EngineSpec requested;
  final EngineSpec live;

  @override
  String toString() =>
      'EngineSlotConflict: cannot create $requested, $live is still live on ${requested.slot.name}';
}

/// Thrown by [EngineFactory.create] when the engine could not be started.
class EngineCreationException implements Exception {
  const EngineCreationException(this.failure);

  /// Everything known about why the engine did not start.
  final EngineFailure failure;

  @override
  String toString() => 'EngineCreationException: $failure';
}

/// Creates engines, one per [EngineSlot].
///
/// This is the only place that knows a native engine takes a moment to let go of its slot: a
/// create that follows a dispose waits for the previous engine to finish exiting, so callers never
/// see the plugin refuse an engine as a result of ordinary provider churn.
class EngineFactory {
  EngineFactory({EngineConnector? connect}) : _connect = connect ?? _connectToPlugin;

  final EngineConnector _connect;

  /// The engine holding each slot, until it reports that it is gone.
  final Map<EngineSlot, Engine> _live = {};

  /// The create in flight on each slot, if there is one.
  ///
  /// Claimed before the first await and held until the engine exists, so a second create queues
  /// behind the first instead of racing it into a native library that hosts one engine at a time.
  /// Never completes with an error, so a failed create does not take its successor down with it.
  final Map<EngineSlot, Future<void>> _starting = {};

  /// Creates and starts an engine, completing when it answers `uciok`.
  ///
  /// Throws an [EngineCreationException] describing what went wrong if it does not get that far.
  Future<Engine> create(EngineSpec spec) async {
    final attempt = _Attempt();
    final queued = _starting[spec.slot];

    final started = _create(spec, attempt, after: queued);
    final claim = started.then((_) {}, onError: (Object _) {});
    attempt.claim = claim;
    _starting[spec.slot] = claim;

    try {
      return await started.timeout(kEngineCreateTimeout);
    } on TimeoutException catch (e, st) {
      // The create goes on regardless -- a future cannot be cancelled -- so the engine it is
      // starting may still arrive. Saying here that nobody wants it any more is what keeps it from
      // being left running with no owner, holding its native slot for the life of the process.
      attempt.abandoned = true;
      throw EngineCreationException(
        EngineFailure(
          kind: EngineFailureKind.stuck,
          message:
              'The engine neither started nor failed within ${kEngineCreateTimeout.inSeconds}s. '
              'The operation it is blocked on will never complete, so no further engine work is '
              'possible until the app is restarted',
          engine: spec.label,
          error: e,
          stackTrace: st,
        ),
      );
    } on EngineCreationException {
      rethrow;
    } catch (e, st) {
      throw EngineCreationException(
        EngineFailure(
          kind: EngineFailureKind.start,
          message: 'The engine failed to start',
          engine: spec.label,
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  Future<Engine> _create(EngineSpec spec, _Attempt attempt, {required Future<void>? after}) async {
    try {
      if (after != null) {
        _logger.fine('Waiting for the create already running on ${spec.slot.name}');
        await after;
      }
      return await _connectAndRegister(spec, attempt);
    } finally {
      if (identical(_starting[spec.slot], attempt.claim)) _starting.remove(spec.slot);
    }
  }

  Future<Engine> _connectAndRegister(EngineSpec spec, _Attempt attempt) async {
    if (_live[spec.slot] case final incumbent?) {
      assert(
        incumbent.isDisposed,
        'Engine slot conflict: ${incumbent.spec} is live on ${spec.slot.name} and was never '
        'disposed, so $spec cannot be created. Engines must be obtained through the factory, and '
        'two specs that share a slot must be equal.',
      );
      if (!incumbent.isDisposed) throw EngineSlotConflict(spec, incumbent.spec);

      // Hand-off: the engine has been let go but the native library does not free the slot until
      // it has actually exited.
      _logger.fine('Waiting for the previous ${spec.slot.name} engine to exit');
      await incumbent.death;
    }

    _logger.fine('Creating engine: $spec');

    final transport = await _connect(spec);
    final engine = Engine(transport);

    if (attempt.abandoned) {
      // Nobody is waiting for this engine any more, and an engine nobody owns is never disposed:
      // it keeps its native slot until the process restarts, and every later engine of this kind
      // is refused.
      _logger.warning('Disposing the $spec that arrived after its create had given up');
      await engine.dispose();
      throw StateError('The create for $spec gave up before the engine had started');
    }

    _live[spec.slot] = engine;
    unawaited(
      engine.death.then((_) {
        if (identical(_live[spec.slot], engine)) _live.remove(spec.slot);
      }),
    );

    return engine;
  }
}

/// One call to [EngineFactory.create], as the create running underneath it sees it.
class _Attempt {
  /// Whether the caller has given up. An engine that arrives after this is disposed rather than
  /// handed over.
  bool abandoned = false;

  /// The entry this attempt put in [EngineFactory._starting], so that it only ever removes its
  /// own.
  Future<void>? claim;
}

Future<EngineTransport> _connectToPlugin(EngineSpec spec) => switch (spec) {
  final StockfishSpec stockfish => StockfishTransport.connect(stockfish),
  final Lc0Spec lc0 => Lc0Transport.connect(lc0),
};

/// The app's [EngineFactory].
///
/// Overriding this is how tests get fake engines; nothing else in the app creates one.
final engineFactoryProvider = Provider<EngineFactory>(
  (ref) => EngineFactory(),
  name: 'EngineFactoryProvider',
);
