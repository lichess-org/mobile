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
/// appears; without this window the engine would be quit and started again in between, which is
/// the restart dance this whole layer exists to remove. Safe to have a real engine sitting idle
/// for a moment because engines no longer hijack the process's stdin and stdout.
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

    ref.onDispose(() {
      // Fire and forget: the factory holds the slot until the engine has actually exited, and
      // makes the next create wait for it.
      unawaited(engine.dispose());
    });

    return engine;
  }
}
