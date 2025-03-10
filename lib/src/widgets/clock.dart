import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

const _kClockFontSize = 26.0;
const _kClockTenthFontSize = 20.0;
const _kClockHundredsFontSize = 18.0;

const _showTenthsThreshold = Duration(seconds: 10);

/// A stateless widget that displays the time left on the clock.
///
/// For a clock widget that automatically counts down, see [CountdownClockBuilder].
class Clock extends StatelessWidget {
  const Clock({
    required this.timeLeft,
    this.active = false,
    this.clockStyle,
    this.emergencyThreshold,
    this.padLeft = false,
    this.padding = const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
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

  /// Padding around the clock.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final hours = timeLeft.inHours;
    final mins = timeLeft.inMinutes.remainder(60);
    final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    final showTenths = timeLeft < _showTenthsThreshold;
    final isEmergency = emergencyThreshold != null && timeLeft <= emergencyThreshold!;
    final remainingHeight = estimateRemainingHeightLeftBoard(context);

    final hoursDisplay = padLeft ? hours.toString().padLeft(2, '0') : hours.toString();
    final minsDisplay = padLeft ? mins.toString().padLeft(2, '0') : mins.toString();

    final brightness = Theme.of(context).brightness;
    final colorScheme = ColorScheme.of(context);
    final effectiveClockStyle = clockStyle ?? ClockStyle.defaultStyle(brightness, colorScheme);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        // TODO improve this
        final fontScaleFactor = maxWidth < 90 ? 0.8 : 1.0;
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            color:
                active
                    ? isEmergency
                        ? effectiveClockStyle.emergencyBackgroundColor
                        : effectiveClockStyle.activeBackgroundColor
                    : effectiveClockStyle.backgroundColor,
          ),
          child: Padding(
            padding: padding,
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: kMaxClockTextScaleFactor,
              child: RichText(
                text: TextSpan(
                  text:
                      hours > 0
                          ? '$hoursDisplay:${mins.toString().padLeft(2, '0')}:$secs'
                          : '$minsDisplay:$secs',
                  style: TextStyle(
                    color:
                        active
                            ? isEmergency
                                ? effectiveClockStyle.emergencyTextColor
                                : effectiveClockStyle.activeTextColor
                            : effectiveClockStyle.textColor,
                    fontSize: _kClockFontSize * fontScaleFactor,
                    height: remainingHeight < kSmallRemainingHeightLeftBoardThreshold ? 1.0 : null,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  children: [
                    if (showTenths)
                      TextSpan(
                        text: '.${timeLeft.inMilliseconds.remainder(1000) ~/ 100}',
                        style: TextStyle(fontSize: _kClockTenthFontSize * fontScaleFactor),
                      ),
                    if (!active && timeLeft < const Duration(seconds: 1))
                      TextSpan(
                        text: '${timeLeft.inMilliseconds.remainder(1000) ~/ 10 % 10}',
                        style: TextStyle(fontSize: _kClockHundredsFontSize * fontScaleFactor),
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

  factory ClockStyle.defaultStyle(Brightness brightness, ColorScheme colorScheme) => ClockStyle(
    backgroundColor: colorScheme.surface,
    textColor: colorScheme.outline,
    activeBackgroundColor:
        brightness == Brightness.dark ? colorScheme.inverseSurface : colorScheme.tertiaryContainer,
    activeTextColor:
        brightness == Brightness.dark
            ? colorScheme.onInverseSurface
            : colorScheme.onTertiaryContainer,
    emergencyBackgroundColor: colorScheme.errorContainer,
    emergencyTextColor: colorScheme.onErrorContainer,
  );
}

typedef ClockWidgetBuilder = Widget Function(BuildContext, Duration);

/// A widget that automatically starts a countdown from [timeLeft] when [active] is `true`.
///
/// The clock will update the UI every [tickInterval], which defaults to 100ms,
/// and the [builder] will be called with the new [timeLeft] value.
///
/// The clock is synchronized with the time at which the clock event was received from the server
/// by setting the [clockUpdatedAt] parameter.
///
/// This widget will only update its internal clock when the [clockUpdatedAt] parameter changes.
/// It is thus possible to update the clock with the same [timeLeft] as previously by changing the
/// [clockUpdatedAt] parameter.
///
/// The [delay] parameter can be used to delay the start of the clock.
///
/// The clock will stop counting down when [active] is set to `false`.
///
/// The clock will stop counting down when the internal time left reaches zero.
class CountdownClockBuilder extends StatefulWidget {
  const CountdownClockBuilder({
    required this.timeLeft,
    required this.clockUpdatedAt,
    required this.active,
    required this.builder,
    this.delay,
    this.tickInterval = const Duration(milliseconds: 100),
    super.key,
  });

  /// The duration left on the clock.
  final Duration timeLeft;

  /// The time at which the clock was updated.
  ///
  /// Use this parameter to synchronize the clock with the time at which the clock
  /// event was received from the server and to compensate for UI lag.
  final DateTime clockUpdatedAt;

  /// The delay before the clock starts counting down.
  ///
  /// This can be used to implement lag compensation.
  final Duration? delay;

  /// The interval at which the clock updates the UI.
  final Duration tickInterval;

  /// If `true`, the clock starts counting down.
  final bool active;

  /// A [ClockWidgetBuilder] that builds the clock on each tick with the new [timeLeft] value.
  final ClockWidgetBuilder builder;

  @override
  State<CountdownClockBuilder> createState() => _CountdownClockState();
}

class _CountdownClockState extends State<CountdownClockBuilder> {
  Timer? _timer;
  Timer? _delayTimer;
  Duration timeLeft = Duration.zero;

  final _stopwatch = clock.stopwatch();

  void startClock() {
    final now = clock.now();
    final delay = widget.delay ?? Duration.zero;
    final clockUpdatedAt = widget.clockUpdatedAt;
    // UI lag diff: the elapsed time between the time the clock should have started
    // and the time the clock is actually started
    final uiLag = now.difference(clockUpdatedAt);
    final realDelay = delay - uiLag;

    // real delay is negative, we need to adjust the timeLeft.
    if (realDelay < Duration.zero) {
      final newTimeLeft = timeLeft + realDelay;
      timeLeft = newTimeLeft > Duration.zero ? newTimeLeft : Duration.zero;
    }

    if (realDelay > Duration.zero) {
      _delayTimer?.cancel();
      _delayTimer = Timer(realDelay, _scheduleTick);
    } else {
      _scheduleTick();
    }
  }

  void _scheduleTick() {
    _timer?.cancel();
    _timer = Timer(widget.tickInterval, _tick);
    _stopwatch.reset();
    _stopwatch.start();
  }

  void _tick() {
    final newTimeLeft = timeLeft - _stopwatch.elapsed;
    setState(() {
      timeLeft = newTimeLeft;
      if (timeLeft <= Duration.zero) {
        timeLeft = Duration.zero;
      }
    });
    if (timeLeft > Duration.zero) {
      _scheduleTick();
    }
  }

  void stopClock() {
    _delayTimer?.cancel();
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
  void didUpdateWidget(CountdownClockBuilder oldClock) {
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
    _delayTimer?.cancel();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: widget.builder(context, timeLeft));
  }
}
