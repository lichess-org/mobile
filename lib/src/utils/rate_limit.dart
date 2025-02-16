import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer(this.delay);

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class Throttler {
  final Duration delay;
  Timer? _timer;

  Throttler(this.delay);

  void call(void Function() action) {
    if (_timer?.isActive ?? false) return;

    _timer?.cancel();
    action();
    _timer = Timer(delay, () {});
  }
}
