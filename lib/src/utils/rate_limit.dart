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
