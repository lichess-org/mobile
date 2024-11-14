import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

/// A countdown clock.
///
/// The clock starts only when [active] is `true`.
class CountdownClock extends StatefulWidget {
  const CountdownClock({
    required this.timeLeft,
    this.clockUpdatedAt,
    required this.active,
    this.clockStyle,
    this.padLeft = false,
    super.key,
  });

  /// The duration left on the clock.
  final Duration timeLeft;

  /// The time at which the clock was updated.
  ///
  /// Use this parameter to synchronize the clock with the time at which the clock
  /// event was received from the server and to compensate for UI lag.
  final DateTime? clockUpdatedAt;

  /// If [active] is `true`, the clock starts counting down.
  final bool active;

  /// Custom color style
  final ClockStyle? clockStyle;

  /// Whether to pad with a leading zero (default is `false`).
  final bool padLeft;

  @override
  State<CountdownClock> createState() => _CountdownClockState();
}

const _tickDelay = Duration(milliseconds: 100);
const _showTenthsThreshold = Duration(seconds: 10);

class _CountdownClockState extends State<CountdownClock> {
  Timer? _timer;
  Duration timeLeft = Duration.zero;

  final _stopwatch = clock.stopwatch();

  void startClock() {
    final now = clock.now();
    final clockUpdatedAt = widget.clockUpdatedAt ?? now;
    // UI lag diff: the elapsed time between the time the clock should have started
    // and the time the clock is actually started
    final uiLag = now.difference(clockUpdatedAt);

    timeLeft = timeLeft - uiLag;

    _scheduleTick();
  }

  void _scheduleTick() {
    _timer?.cancel();
    _timer = Timer(_tickDelay, _tick);
    _stopwatch.reset();
    _stopwatch.start();
  }

  void _tick() {
    setState(() {
      timeLeft = timeLeft - _stopwatch.elapsed;
      if (timeLeft <= Duration.zero) {
        timeLeft = Duration.zero;
      }
    });
    if (timeLeft > Duration.zero) {
      _scheduleTick();
    }
  }

  void stopClock() {
    _timer?.cancel();
    _stopwatch.stop();
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

    if (widget.clockUpdatedAt != oldClock.clockUpdatedAt) {
      timeLeft = widget.timeLeft;
    }

    if (widget.active != oldClock.active) {
      if (widget.active) {
        startClock();
      } else {
        stopClock();
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
