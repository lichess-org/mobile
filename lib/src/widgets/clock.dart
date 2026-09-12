import 'dart:async';

import 'package:clock/clock.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:material_ui/material_ui.dart';

const _kClockFontSize = 26.0;
const _kClockTenthFontSize = 20.0;
const _kClockHundredsFontSize = 18.0;

/// A stateless widget that displays the time left on the clock.
///
/// For a clock widget that automatically counts down, see [CountdownClockBuilder].
class const Clock({
  /// The time left to be displayed on the clock.
  required final Duration timeLeft,

  /// If `true`, [ClockStyle.activeBackgroundColor] will be used, otherwise [ClockStyle.backgroundColor].
  final bool active = false,

  /// Clock style to use.
  final ClockStyle? clockStyle,

  /// If [timeLeft] is less than [emergencyThreshold], the clock will set
  /// its background color to [ClockStyle.emergencyBackgroundColor].
  final Duration? emergencyThreshold,
  final ClockTenths? clockTenths,

  /// Whether to pad with a leading zero (default is `false`).
  final bool padLeft = false,

  /// Padding around the clock.
  final EdgeInsets padding = const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hours = timeLeft.inHours;
    final mins = timeLeft.inMinutes.remainder(60);
    final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    final isEmergency = emergencyThreshold != null && timeLeft <= emergencyThreshold!;

    final showTenths = switch (clockTenths) {
      ClockTenths.never => false,
      ClockTenths.lessThan10s || null => timeLeft < const Duration(seconds: 10),
      ClockTenths.always => true,
    };

    final hoursDisplay = padLeft ? hours.toString().padLeft(2, '0') : hours.toString();
    final minsDisplay = padLeft ? mins.toString().padLeft(2, '0') : mins.toString();

    final brightness = Theme.of(context).brightness;
    final colorScheme = ColorScheme.of(context);
    final effectiveClockStyle =
        clockStyle ?? ClockStyle.defaultStyle(brightness, colorScheme, context.lichessColors);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        // TODO improve this
        final fontScaleFactor = maxWidth < 90 ? 0.8 : 1.0;
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            color: timeLeft > Duration.zero
                ? active
                      ? isEmergency
                            ? effectiveClockStyle.emergencyBackgroundColor
                            : effectiveClockStyle.activeBackgroundColor
                      : effectiveClockStyle.backgroundColor
                : effectiveClockStyle.emergencyBackgroundColor,
          ),
          child: Padding(
            padding: padding,
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: kMaxClockTextScaleFactor,
              child: Text.rich(
                TextSpan(
                  text: hours > 0
                      ? '$hoursDisplay:${mins.toString().padLeft(2, '0')}:$secs'
                      : '$minsDisplay:$secs',
                  style: TextStyle(
                    color: timeLeft > Duration.zero
                        ? active
                              ? isEmergency
                                    ? effectiveClockStyle.emergencyTextColor
                                    : effectiveClockStyle.activeTextColor
                              : effectiveClockStyle.textColor
                        : effectiveClockStyle.emergencyTextColor,
                    fontSize: _kClockFontSize * fontScaleFactor,
                    height: isShortVerticalScreen(context) ? 1.0 : null,
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
class const ClockStyle({
  required final Color textColor,
  required final Color activeTextColor,
  required final Color emergencyTextColor,
  required final Color backgroundColor,
  required final Color activeBackgroundColor,
  required final Color emergencyBackgroundColor,
}) {
  factory defaultStyle(
    Brightness brightness,
    ColorScheme colorScheme,
    LichessCustomColors lichessColors,
  ) => ClockStyle(
    backgroundColor: colorScheme.surface,
    textColor: colorScheme.outline,
    activeBackgroundColor: brightness == Brightness.dark
        ? colorScheme.inverseSurface
        : colorScheme.tertiaryContainer,
    activeTextColor: brightness == Brightness.dark
        ? colorScheme.onInverseSurface
        : colorScheme.onTertiaryContainer,
    emergencyBackgroundColor: lichessColors.error.withValues(
      alpha: brightness == Brightness.dark ? 0.6 : 0.4,
    ),
    emergencyTextColor: brightness == Brightness.dark ? Colors.white60 : Colors.black87,
  );
}

typedef ClockWidgetBuilder = Widget Function(BuildContext, Duration);

/// A widget that automatically starts a countdown from [timeLeft] when [active] is `true`.
///
/// The clock will update the UI every [tickInterval], which defaults to 100ms,
/// and the [builder] will be called with the new [timeLeft] value.
///
/// The clock can be synchronized with the time at which the clock event was received from the server
/// by setting the [clockUpdatedAt] parameter.
/// If the [clockUpdatedAt] parameter is set, the clock will only update the [timeLeft] value when
/// the [clockUpdatedAt] parameter changes. This way the clock can be reset with the same [timeLeft] value.
///
/// The [delay] parameter can be used to delay the start of the clock.
///
/// The clock will stop counting down when [active] is set to `false`.
///
/// The clock will stop counting down when the time left reaches zero.
class const CountdownClockBuilder({
  /// The duration left on the clock.
  required final Duration timeLeft,

  /// If `true`, the clock starts counting down.
  required final bool active,

  /// A [ClockWidgetBuilder] that builds the clock on each tick with the new [timeLeft] value.
  required final ClockWidgetBuilder builder,

  /// The delay before the clock starts counting down.
  ///
  /// This can be used to implement lag compensation.
  final Duration? delay,

  /// The interval at which the clock updates the UI.
  final Duration tickInterval = const Duration(milliseconds: 100),

  /// The time at which the clock was updated.
  ///
  /// Use this parameter to synchronize the clock with the time at which the clock
  /// event was received from the server and to compensate for UI lag.
  final DateTime? clockUpdatedAt,
  super.key,
}) extends StatefulWidget {
  @override
  State<CountdownClockBuilder> createState() => _CountdownClockState();
}

class _CountdownClockState() extends State<CountdownClockBuilder> {
  Timer? _timer;
  Timer? _delayTimer;
  Duration timeLeft = Duration.zero;

  final _stopwatch = clock.stopwatch();

  void startClock() {
    final now = clock.now();
    final delay = widget.delay ?? Duration.zero;
    final clockUpdatedAt = widget.clockUpdatedAt ?? now;
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

    if (widget.clockUpdatedAt == null) {
      if (widget.timeLeft != oldClock.timeLeft) {
        timeLeft = widget.timeLeft;
        if (widget.active) {
          startClock();
        }
      }
    } else if (widget.clockUpdatedAt != oldClock.clockUpdatedAt) {
      timeLeft = widget.timeLeft;
      if (widget.active) {
        startClock();
      }
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
