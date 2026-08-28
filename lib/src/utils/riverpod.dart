import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// The retry policy used by every provider in the app.
///
/// A provider that is retrying stays in [AsyncLoading], so retries are only worth it for failures
/// that might resolve on their own: a flaky connection, a dropped request. A response the server
/// actually sent is not one of those, and retrying it just leaves spinners and shimmers on screen
/// for the whole back-off.
///
/// That includes the 503 of a planned maintenance and the 502 of an outage: both are surfaced by
/// [ServerStatusNotifier] and shown as a [ServerOutageDisplay], and recovery is driven by
/// pull-to-refresh and by coming back to the app, not by retrying in the background.
Duration? lichessProviderRetry(int retryCount, Object error) {
  if (error is ServerException) return null;

  // Everything else keeps riverpod's own policy, which notably never retries an [Error]: those are
  // programming mistakes, and retrying one only hides it behind a spinner.
  return ProviderContainer.defaultRetry(
    retryCount,
    error,
    maxRetries: 6,
    minDelay: const Duration(milliseconds: 500),
  );
}

/// Return type of `Notifier.runBuild` since riverpod 3.3.2.
///
/// Riverpod declares this typedef as `@internal` and does not export it from
/// any public entrypoint, so we mirror it here to be able to name the return
/// type when overriding `runBuild` in a mixin. Drop this and import riverpod's
/// own `WhenComplete` if it is ever made public.
typedef WhenComplete = void Function(void Function() cb)?;

extension RefExtension on Ref {
  /// Keeps the provider alive for [duration]
  KeepAliveLink cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
    return link;
  }

  /// Delays an execution by a bit such that if a dependency changes multiple
  /// time rapidly, the rest of the code is only run once.
  Future<void> debounce(Duration duration) {
    final completer = Completer<void>();
    final timer = Timer(duration, () {
      if (!completer.isCompleted) completer.complete();
    });
    onDispose(() {
      timer.cancel();
      if (!completer.isCompleted) {
        completer.completeError(StateError('Cancelled'));
      }
    });
    return completer.future;
  }
}
