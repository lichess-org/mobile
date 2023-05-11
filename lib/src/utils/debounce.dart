import 'dart:async';

class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce(
    this.delay,
  );

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
