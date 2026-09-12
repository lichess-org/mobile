import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer(this.delay);

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}

class Throttler {
  final Duration delay;

  /// Whether a call made during the delay runs when it expires, instead of being dropped.
  ///
  /// Calls made in the same window are coalesced into a single trailing run, which uses the last
  /// action given. Use this when dropping a call for good would lose a signal — a state change
  /// that nothing will notify about again — rather than merely skip one of a repeating series.
  final bool trailing;

  Timer? _timer;
  void Function()? _trailingAction;

  Throttler(this.delay, {this.trailing = false});

  void call(void Function() action) {
    if (_timer?.isActive ?? false) {
      if (trailing) _trailingAction = action;
      return;
    }

    _timer?.cancel();
    action();
    _timer = Timer(delay, _onDelayExpired);
  }

  void _onDelayExpired() {
    final trailingAction = _trailingAction;
    if (trailingAction == null) return;
    _trailingAction = null;
    call(trailingAction);
  }

  void cancel() {
    _trailingAction = null;
    _timer?.cancel();
  }
}

/// Runs tasks one at a time, in submission order.
///
/// Unlike [Debouncer] and [Throttler] nothing is ever dropped and nothing is ever delayed on its
/// own: every task runs, it just waits for the one before it. Use it to keep independent callers
/// from hitting the same resource concurrently. Callers that want a *gap* between their own
/// requests should wait for it themselves; adding it here would leave a pending timer behind every
/// task, which widget tests report as work the test failed to settle.
class SerialTaskQueue {
  /// Completes when the last task submitted so far has released the queue. Never completes with an
  /// error, so a failing task does not break the chain.
  Future<void> _tail = Future.value();

  /// Queues [task] and returns its result.
  ///
  /// The queue is held for as long as [task]'s future takes to settle, so a task that never
  /// completes blocks the ones behind it: give tasks their own timeout.
  Future<T> run<T>(Future<T> Function() task) {
    final previous = _tail;
    final release = Completer<void>();
    // Claimed synchronously, so tasks run in the order [run] was called in.
    _tail = release.future;

    return previous.then<T>((_) async {
      try {
        return await task();
      } finally {
        release.complete();
      }
    });
  }
}
