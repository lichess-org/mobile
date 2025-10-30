import 'dart:async';

import 'package:clock/clock.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';

const _emergencyDelay = Duration(seconds: 20);
const _tickDelay = Duration(milliseconds: 100);

typedef _EmergencyState = ({
  bool shouldTriggerEmergencyCallback,
  DateTime? nextEmergency,
});

/// A chess clock.
class ChessClock {
  ChessClock({
    required Duration whiteTime,
    required Duration blackTime,
    this.emergencyThreshold,
    this.onFlag,
    this.onEmergency,
  }) : _whiteTime = ValueNotifier(whiteTime),
       _blackTime = ValueNotifier(blackTime),
       _activeSide = Side.white;

  /// The threshold at which the clock will call [onEmergency] if provided.
  final Duration? emergencyThreshold;

  /// Callback when the clock reaches zero.
  VoidCallback? onFlag;

  /// Called when one clock timers reaches the emergency threshold.
  final void Function(Side activeSide)? onEmergency;

  Timer? _timer;
  Timer? _startDelayTimer;
  DateTime? _lastStarted;
  final _stopwatch = clock.stopwatch();
  _EmergencyState _whiteEmergencyState = (
    shouldTriggerEmergencyCallback: true,
    nextEmergency: null,
  );
  _EmergencyState _blackEmergencyState = (
    shouldTriggerEmergencyCallback: true,
    nextEmergency: null,
  );

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

  set _activeSideEmergencyState(_EmergencyState state) {
    if (_activeSide == Side.white) {
      _whiteEmergencyState = state;
    } else {
      _blackEmergencyState = state;
    }
  }

  _EmergencyState get _activeSideEmergencyState =>
      _activeSide == Side.white ? _whiteEmergencyState : _blackEmergencyState;

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

  /// Starts the clock and switch to the given side.
  ///
  /// Trying to start an already running clock on the same side is a no-op.
  ///
  /// The [delay] parameter can be used to add a delay before the clock starts counting down. This is useful for lag compensation.
  ///
  /// Returns the think time of the active side before switching or `null` if the clock is not running.
  Duration? startSide(Side side, {Duration? delay}) {
    if (isRunning && _activeSide == side) {
      return _thinkTime;
    }
    _activeSide = side;
    final thinkTime = _thinkTime;
    start(delay: delay);
    return thinkTime;
  }

  /// Starts the clock.
  ///
  /// The [delay] parameter can be used to add a delay before the clock starts counting down. This is useful for lag compensation.
  void start({Duration? delay}) {
    _lastStarted = clock.now().add(delay ?? Duration.zero);
    _startDelayTimer?.cancel();
    _startDelayTimer = Timer(delay ?? Duration.zero, _scheduleTick);
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
    _scheduleTick();
  }

  void _checkEmergency() {
    final timeLeft = _activeTime.value;
    if (emergencyThreshold != null &&
        timeLeft <= emergencyThreshold! &&
        _activeSideEmergencyState.shouldTriggerEmergencyCallback &&
        (_activeSideEmergencyState.nextEmergency == null ||
            _activeSideEmergencyState.nextEmergency!.isBefore(clock.now()))) {
      _activeSideEmergencyState = (
        shouldTriggerEmergencyCallback: false,
        nextEmergency: clock.now().add(_emergencyDelay),
      );
      onEmergency?.call(_activeSide);
    } else if (emergencyThreshold != null &&
        timeLeft > emergencyThreshold! * 1.5) {
      _activeSideEmergencyState = (
        shouldTriggerEmergencyCallback: true,
        nextEmergency: _activeSideEmergencyState.nextEmergency,
      );
    }
  }
}
