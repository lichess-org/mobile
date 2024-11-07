import 'dart:async';

import 'package:clock/clock.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';

const _emergencyDelay = Duration(seconds: 20);
const _tickDelay = Duration(milliseconds: 100);

/// A chess clock.
class ChessClock {
  ChessClock({
    required Duration whiteTime,
    required Duration blackTime,
    this.emergencyThreshold,
    this.onFlag,
    this.onEmergency,
  })  : _whiteTime = ValueNotifier(whiteTime),
        _blackTime = ValueNotifier(blackTime),
        _activeSide = Side.white;

  /// The threshold at which the clock will call [onEmergency] if provided.
  final Duration? emergencyThreshold;

  /// Callback when the clock reaches zero.
  VoidCallback? onFlag;

  /// Called when the clock reaches the emergency.
  final VoidCallback? onEmergency;

  Timer? _timer;
  Timer? _startDelayTimer;
  DateTime? _lastStarted;
  final _stopwatch = clock.stopwatch();
  bool _shouldPlayEmergencyFeedback = true;
  DateTime? _nextEmergency;

  final ValueNotifier<Duration> _whiteTime;
  final ValueNotifier<Duration> _blackTime;
  Side _activeSide;

  bool get isRunning {
    return _lastStarted != null;
  }

  /// Returns the current white time.
  ValueListenable<Duration> get whiteTime => _whiteTime;

  /// Returns the current black time.
  ValueListenable<Duration> get blackTime => _blackTime;

  /// Returns the current active time.
  ValueListenable<Duration> get activeTime => _activeTime;

  /// Returns the current active side.
  Side get activeSide => _activeSide;

  /// Sets the time for either side.
  void setTimes({Duration? whiteTime, Duration? blackTime}) {
    if (whiteTime != null) {
      _whiteTime.value = whiteTime;
    }
    if (blackTime != null) {
      _blackTime.value = blackTime;
    }
  }

  /// Sets the time for the given side.
  void setTime(Side side, Duration time) {
    if (side == Side.white) {
      _whiteTime.value = time;
    } else {
      _blackTime.value = time;
    }
  }

  /// Increments the time for either side.
  void incTimes({Duration? whiteInc, Duration? blackInc}) {
    if (whiteInc != null) {
      _whiteTime.value += whiteInc;
    }
    if (blackInc != null) {
      _blackTime.value += blackInc;
    }
  }

  /// Increments the time for the given side.
  void incTime(Side side, Duration increment) {
    if (side == Side.white) {
      _whiteTime.value += increment;
    } else {
      _blackTime.value += increment;
    }
  }

  /// Starts the clock for the given side.
  ///
  /// The [delay] parameter can be used to add a delay before the clock starts counting down. This is useful for lag compensation.
  ///
  /// Returns the think time of the active side before switching or `null` if the clock is not running.
  Duration? startForSide(Side side, [Duration delay = Duration.zero]) {
    _activeSide = side;
    start(delay);
    if (isRunning) {
      return _thinkTime;
    }
    return null;
  }

  /// Starts the clock for the active side.
  ///
  /// The [delay] parameter can be used to add a delay before the clock starts counting down. This is useful for lag compensation.
  void start([Duration delay = Duration.zero]) {
    _lastStarted = clock.now().add(delay);
    _startDelayTimer?.cancel();
    _startDelayTimer = Timer(delay, _scheduleTick);
  }

  /// Pauses the clock.
  ///
  /// Returns the current think time for the active side.
  Duration stop() {
    _stopwatch.stop();
    _startDelayTimer?.cancel();
    _timer?.cancel();
    final thinkTime = _thinkTime ?? Duration.zero;
    _lastStarted = null;
    return thinkTime;
  }

  void dispose() {
    _timer?.cancel();
    _startDelayTimer?.cancel();
    _whiteTime.dispose();
    _blackTime.dispose();
  }

  /// Returns the current think time for the active side.
  Duration? get _thinkTime {
    if (_lastStarted == null) {
      return null;
    }
    return clock.now().difference(_lastStarted!);
  }

  ValueNotifier<Duration> get _activeTime {
    return activeSide == Side.white ? _whiteTime : _blackTime;
  }

  void _scheduleTick() {
    _stopwatch.reset();
    _stopwatch.start();
    _timer?.cancel();
    _timer = Timer(_tickDelay, _tick);
  }

  void _tick() {
    final newTime = _activeTime.value - _stopwatch.elapsed;
    _activeTime.value = newTime < Duration.zero ? Duration.zero : newTime;
    _checkEmergency();
    if (_activeTime.value == Duration.zero) {
      onFlag?.call();
    }
    if (_activeTime.value > Duration.zero) {
      _scheduleTick();
    }
  }

  void _checkEmergency() {
    final timeLeft = _activeTime.value;
    if (emergencyThreshold != null &&
        timeLeft <= emergencyThreshold! &&
        _shouldPlayEmergencyFeedback &&
        (_nextEmergency == null || _nextEmergency!.isBefore(clock.now()))) {
      _shouldPlayEmergencyFeedback = false;
      _nextEmergency = clock.now().add(_emergencyDelay);
      onEmergency?.call();
    } else if (emergencyThreshold != null &&
        timeLeft > emergencyThreshold! * 1.5) {
      _shouldPlayEmergencyFeedback = true;
    }
  }
}
