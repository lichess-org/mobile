import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/engine_factory.dart';
import 'package:lichess_mobile/src/model/engine/engine_spec.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('EngineProvider');

/// How long an engine outlives its last watcher.
///
/// Leaving one analysis screen for another disposes the first watcher before the second one
/// appears; without this window the engine would be quit and started again in between.
const kEngineDisposeDelay = Duration(seconds: 10);

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
    ref.cacheFor(kEngineDisposeDelay);

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
