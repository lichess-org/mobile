import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

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
