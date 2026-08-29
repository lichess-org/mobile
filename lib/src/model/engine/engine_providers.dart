import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:logging/logging.dart';

final _logger = Logger('EngineProvider');

/// How long an engine outlives its last watcher.
///
/// Leaving one analysis screen for another disposes the first watcher before the second one
/// appears; without this window the engine would be quit and started again in between. The window
/// is idle time rather than a lifetime: it starts when the last watcher goes away, however long the
/// engine has been in use.
///
/// Short, because the only thing it has to cover is one screen handing the engine to the next, and
/// an engine waiting one out is memory nobody is using: see [EngineGraceWindows].
const kEngineDisposeDelay = Duration(seconds: 2);

/// How long a new engine waits for an unwatched one to exit before starting anyway.
///
/// An engine that will not quit must not keep every later engine from starting: the wait is what
/// keeps two transposition tables from overlapping, and going ahead without it is worse for memory
/// than it is for correctness.
const _kGraceWindowExitWait = Duration(seconds: 2);

/// The engines that are alive with nobody watching them.
///
/// An engine in its grace window still holds the transposition table it was given, and the memory
/// budget is the device's rather than each engine's (see `EngineBudget`), so an engine nobody is
/// watching has to be gone before the next one allocates — otherwise leaving an analysis screen and
/// opening one on another variant has two engines each holding a whole budget's worth. Engines on
/// two slots are then only ever resident together while both are watched, which is the case the
/// budget splits.
class EngineGraceWindows {
  final _waiting = <EngineSpec, Future<void> Function()>{};

  /// Registers [release], which quits [spec]'s engine and completes when it has exited.
  void add(EngineSpec spec, Future<void> Function() release) => _waiting[spec] = release;

  void remove(EngineSpec spec) => _waiting.remove(spec);

  /// Quits every engine that is waiting out its window, and waits for them to exit.
  Future<void> releaseAll() async {
    if (_waiting.isEmpty) return;
    final releases = _waiting.values.toList();
    _waiting.clear();
    await Future.wait(releases.map((release) => release()));
  }
}

/// The engines of [engineProvider] that are outliving their last watcher.
final engineGraceWindowsProvider = Provider<EngineGraceWindows>(
  (ref) => EngineGraceWindows(),
  name: 'EngineGraceWindowsProvider',
);

/// A live engine for [EngineSpec], shared by every watcher.
///
/// The engine is started when the first watcher appears and disposed a short while after the last
/// one goes away. Two watchers asking for the same spec get the same engine, which is what makes
/// the plugin's "one engine per native library" constraint structural rather than something every
/// caller has to remember: see [EngineSlot].
///
/// A failed start is not retried. The app's default policy would keep the provider in
/// [AsyncLoading] through six backoffs, which is exactly the "loading and always will be" state
/// this layer replaced; a caller that wants another go invalidates the provider.
final engineProvider = AsyncNotifierProvider.autoDispose.family<EngineHolder, Engine, EngineSpec>(
  EngineHolder.new,
  name: 'EngineProvider',
  retry: (_, _) => null,
);

class EngineHolder extends AsyncNotifier<Engine> {
  EngineHolder(this.spec);

  final EngineSpec spec;

  @override
  Future<Engine> build() async {
    final graceWindows = ref.read(engineGraceWindowsProvider);

    // Before allocating anything, hand back what nobody is using: an engine waiting out its window
    // still holds its table, and the budget is the device's. The factory does the same for the slot
    // this engine is about to take; this covers the other slots, which it has no reason to touch.
    await graceWindows.releaseAll().timeout(
      _kGraceWindowExitWait,
      onTimeout: () => _logger.warning('An unwatched engine did not exit; starting $spec anyway'),
    );

    final engine = await ref.read(engineFactoryProvider).create(spec);

    // The provider is autoDispose and starting an engine takes a moment, so the last watcher can
    // go away while this is suspended — leaving one analysis screen, or switching to another
    // engine, is enough. Riverpod has disposed the element by the time this resumes, every `ref`
    // method below would throw, and the engine created above would be left running with nobody
    // holding it: a native slot occupied for the rest of the process's life, which is what the
    // plugin refuses the next engine over.
    if (!ref.mounted) {
      _logger.info('Nobody is waiting for $spec any more; disposing the engine that just started');
      unawaited(engine.dispose());
      throw StateError('The engine provider was disposed while $spec was starting');
    }

    // Registered before anything else can throw, so that from here on the engine has an owner
    // whatever else happens in this build.
    ref.onDispose(() {
      // Fire and forget: the factory holds the slot until the engine has actually exited, and
      // makes the next create wait for it.
      unawaited(engine.dispose());
    });

    // Only a working engine is worth holding on to: a failed one should be built again from
    // scratch by whoever asks next, not served from the cache for the length of the window.
    //
    // The link is held for as long as the engine is watched and closed [kEngineDisposeDelay] after
    // the last watcher leaves, which is what makes the window idle time rather than a lifetime:
    // a timer started here would already have fired by the time a screen that was open for a minute
    // is left, and the engine would be quit the moment its last watcher went away.
    final link = ref.keepAlive();
    Timer? graceTimer;

    void endGraceWindow() {
      graceTimer?.cancel();
      graceTimer = null;
      graceWindows.remove(spec);
    }

    ref.onCancel(() {
      // Closing the link is the whole of quitting the engine: with no watchers left riverpod
      // disposes the element, and `onDispose` above disposes the engine.
      graceWindows.add(spec, () async {
        endGraceWindow();
        link.close();
        await engine.death;
      });
      graceTimer = Timer(kEngineDisposeDelay, () {
        endGraceWindow();
        link.close();
      });
    });
    ref.onResume(endGraceWindow);
    ref.onDispose(endGraceWindow);

    // An engine that dies takes the provider with it, so watchers see the failure instead of an
    // engine that has stopped answering. Nothing latches: the failure belongs to this handle, and
    // the next build makes another one.
    unawaited(
      engine.death.then((failure) {
        if (!ref.mounted || failure == null) return;
        _logger.severe('The engine died: $failure');
        state = AsyncError(failure, StackTrace.current);
      }),
    );

    return engine;
  }
}
