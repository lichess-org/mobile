import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

/// A countdown clock.
///
/// The clock starts only when [active] is `true`.
class CountdownClock extends ConsumerStatefulWidget {
  const CountdownClock({
    required this.timeLeft,
    this.delay,
    this.clockEventTime,
    required this.active,
    this.emergencyThreshold,
    this.emergencySoundEnabled = true,
    this.onFlag,
    this.onStop,
    this.clockStyle,
    this.padLeft = false,
    super.key,
  });

  /// The duration left on the clock.
  final Duration timeLeft;

  /// The delay before the clock starts counting down.
  ///
  /// This can be used to implement lag compensation.
  final Duration? delay;

  /// The time the time left was received at.
  ///
  /// Use this parameter to synchronize the clock with the time at which the clock
  /// event was received from the server.
  final DateTime? clockEventTime;

  /// If [timeLeft] is less than [emergencyThreshold], the clock will change
  /// its background color to [ClockStyle.emergencyBackgroundColor] activeBackgroundColor
  /// If [emergencySoundEnabled] is `true`, the clock will also play a sound.
  final Duration? emergencyThreshold;

  /// Whether to play an emergency sound when the clock reaches the emergency
  final bool emergencySoundEnabled;

  /// If [active] is `true`, the clock starts counting down.
  final bool active;

  /// Callback when the clock reaches zero.
  final VoidCallback? onFlag;

  /// Callback with the remaining duration when the clock stops
  final ValueSetter<Duration>? onStop;

  /// Custom color style
  final ClockStyle? clockStyle;

  /// Whether to pad with a leading zero (default is `false`).
  final bool padLeft;

  @override
  ConsumerState<CountdownClock> createState() => _CountdownClockState();
}

const _emergencyDelay = Duration(seconds: 20);
const _showTenthsThreshold = Duration(seconds: 10);

class _CountdownClockState extends ConsumerState<CountdownClock> {
  Timer? _timer;
  Duration timeLeft = Duration.zero;
  bool _shouldPlayEmergencyFeedback = true;
  DateTime? _nextEmergency;

  final _stopwatch = clock.stopwatch();

  void startClock() {
    final now = clock.now();
    final delay = widget.delay ?? Duration.zero;
    final clockEventTime = widget.clockEventTime ?? now;
    // UI lag diff: the elapsed time between the time we received the clock event
    // and the time the clock is actually started
    final uiLag = now.difference(clockEventTime);
    // The clock should have started at `clockEventTime`, but it started at `now`.
    // so we need to adjust the delay.
    final realDelay = delay - uiLag;

    // real delay is negative, so we need to adjust the timeLeft.
    if (realDelay < Duration.zero) {
      timeLeft = timeLeft + realDelay;
    }

    _scheduleTick(realDelay);
  }

  void _scheduleTick(Duration extraDelay) {
    _timer?.cancel();
    final delay = Duration(
      milliseconds: (timeLeft < _showTenthsThreshold
              ? timeLeft.inMilliseconds % 100
              : timeLeft.inMilliseconds % 500) +
          1,
    );
    _timer = Timer(delay + extraDelay, _tick);
    _stopwatch.reset();
    _stopwatch.start();
  }

  void _tick() {
    setState(() {
      timeLeft = timeLeft - _stopwatch.elapsed;
      _playEmergencyFeedback();
      if (timeLeft <= Duration.zero) {
        widget.onFlag?.call();
        timeLeft = Duration.zero;
      }
    });
    if (timeLeft > Duration.zero) {
      _scheduleTick(Duration.zero);
    }
  }

  void stopClock({bool countElapsedTime = true}) {
    if (countElapsedTime) {
      setState(() {
        timeLeft = timeLeft - _stopwatch.elapsed;
        if (timeLeft < Duration.zero) {
          timeLeft = Duration.zero;
        }
      });
    }
    _timer?.cancel();
    _stopwatch.stop();
    scheduleMicrotask(() {
      widget.onStop?.call(timeLeft);
    });
  }

  void _playEmergencyFeedback() {
    if (widget.emergencyThreshold != null &&
        timeLeft <= widget.emergencyThreshold! &&
        _shouldPlayEmergencyFeedback &&
        (_nextEmergency == null || _nextEmergency!.isBefore(clock.now()))) {
      _shouldPlayEmergencyFeedback = false;
      _nextEmergency = clock.now().add(_emergencyDelay);
      if (widget.emergencySoundEnabled) {
        ref.read(soundServiceProvider).play(Sound.lowTime);
      }
      HapticFeedback.heavyImpact();
    } else if (widget.emergencyThreshold != null &&
        timeLeft > widget.emergencyThreshold! * 1.5) {
      _shouldPlayEmergencyFeedback = true;
    }
  }

  @override
  void initState() {
    super.initState();
    timeLeft = widget.timeLeft;
    if (widget.active) {
      startClock();
    }
  }

  @override
  void didUpdateWidget(CountdownClock oldClock) {
    super.didUpdateWidget(oldClock);
    final isSameTimeConfig = widget.timeLeft == oldClock.timeLeft;
    if (!isSameTimeConfig) {
      timeLeft = widget.timeLeft;
    }

    if (widget.active != oldClock.active) {
      if (widget.active) {
        startClock();
      } else {
        // If the timeLeft was changed at the same time as the clock is stopped
        // we don't want to count the elapsed time because the new time takes precedence.
        stopClock(countElapsedTime: isSameTimeConfig);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Clock(
        padLeft: widget.padLeft,
        timeLeft: timeLeft,
        active: widget.active,
        emergencyThreshold: widget.emergencyThreshold,
        clockStyle: widget.clockStyle,
      ),
    );
  }
}

const _kClockFontSize = 26.0;
const _kClockTenthFontSize = 20.0;
const _kClockHundredsFontSize = 18.0;

/// A stateless widget that displays the time left on the clock.
///
/// For a clock widget that automatically counts down, see [CountdownClock].
class Clock extends StatelessWidget {
  const Clock({
    required this.timeLeft,
    required this.active,
    this.clockStyle,
    this.emergencyThreshold,
    this.padLeft = false,
    super.key,
  });

  /// The time left to be displayed on the clock.
  final Duration timeLeft;

  /// If `true`, [ClockStyle.activeBackgroundColor] will be used, otherwise [ClockStyle.backgroundColor].
  final bool active;

  /// If [timeLeft] is less than [emergencyThreshold], the clock will set
  /// its background color to [ClockStyle.emergencyBackgroundColor].
  final Duration? emergencyThreshold;

  /// Clock style to use.
  final ClockStyle? clockStyle;

  /// Whether to pad with a leading zero (default is `false`).
  final bool padLeft;

  @override
  Widget build(BuildContext context) {
    final hours = timeLeft.inHours;
    final mins = timeLeft.inMinutes.remainder(60);
    final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    final showTenths = timeLeft < _showTenthsThreshold;
    final isEmergency =
        emergencyThreshold != null && timeLeft <= emergencyThreshold!;
    final remainingHeight = estimateRemainingHeightLeftBoard(context);

    final hoursDisplay =
        padLeft ? hours.toString().padLeft(2, '0') : hours.toString();
    final minsDisplay =
        padLeft ? mins.toString().padLeft(2, '0') : mins.toString();

    final brightness = Theme.of(context).brightness;
    final activeClockStyle = clockStyle ??
        (brightness == Brightness.dark
            ? ClockStyle.darkThemeStyle
            : ClockStyle.lightThemeStyle);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        // TODO improve this
        final fontScaleFactor = maxWidth < 90 ? 0.8 : 1.0;
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            color: active
                ? isEmergency
                    ? activeClockStyle.emergencyBackgroundColor
                    : activeClockStyle.activeBackgroundColor
                : activeClockStyle.backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: kMaxClockTextScaleFactor,
              child: RichText(
                text: TextSpan(
                  text: hours > 0
                      ? '$hoursDisplay:${mins.toString().padLeft(2, '0')}:$secs'
                      : '$minsDisplay:$secs',
                  style: TextStyle(
                    color: active
                        ? isEmergency
                            ? activeClockStyle.emergencyTextColor
                            : activeClockStyle.activeTextColor
                        : activeClockStyle.textColor,
                    fontSize: _kClockFontSize * fontScaleFactor,
                    height: remainingHeight <
                            kSmallRemainingHeightLeftBoardThreshold
                        ? 1.0
                        : null,
                    fontFeatures: const [
                      FontFeature.tabularFigures(),
                    ],
                  ),
                  children: [
                    if (showTenths)
                      TextSpan(
                        text:
                            '.${timeLeft.inMilliseconds.remainder(1000) ~/ 100}',
                        style: TextStyle(
                          fontSize: _kClockTenthFontSize * fontScaleFactor,
                        ),
                      ),
                    if (!active && timeLeft < const Duration(seconds: 1))
                      TextSpan(
                        text:
                            '${timeLeft.inMilliseconds.remainder(1000) ~/ 10 % 10}',
                        style: TextStyle(
                          fontSize: _kClockHundredsFontSize * fontScaleFactor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

@immutable
class ClockStyle {
  const ClockStyle({
    required this.textColor,
    required this.activeTextColor,
    required this.emergencyTextColor,
    required this.backgroundColor,
    required this.activeBackgroundColor,
    required this.emergencyBackgroundColor,
  });

  final Color textColor;
  final Color activeTextColor;
  final Color emergencyTextColor;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color emergencyBackgroundColor;

  static const darkThemeStyle = ClockStyle(
    textColor: Colors.grey,
    activeTextColor: Colors.black,
    emergencyTextColor: Colors.white,
    backgroundColor: Colors.black,
    activeBackgroundColor: Color(0xFFDDDDDD),
    emergencyBackgroundColor: Color(0xFF673431),
  );

  static const lightThemeStyle = ClockStyle(
    textColor: Colors.grey,
    activeTextColor: Colors.black,
    emergencyTextColor: Colors.black,
    backgroundColor: Colors.white,
    activeBackgroundColor: Color(0xFFD0E0BD),
    emergencyBackgroundColor: Color(0xFFF2CCCC),
  );
}
