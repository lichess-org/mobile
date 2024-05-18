import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

/// A simple countdown clock.
///
/// The clock starts only when [active] is `true`.
class CountdownClock extends ConsumerStatefulWidget {
  /// The duration left on the clock.
  final Duration duration;

  /// If [timeLeft] is less than [emergencyThreshold], the clock will change
  /// its background color to [ClockStyle.emergencyBackgroundColor] activeBackgroundColor
  final Duration? emergencyThreshold;

  /// If [active] is `true`, the clock starts counting down.
  final bool active;

  /// Callback when the clock reaches zero.
  final VoidCallback? onFlag;

  /// Callback with the remaining duration when the clock stops
  final ValueSetter<Duration>? onStop;

  /// Custom light color style
  final ClockStyle? lightColorStyle;

  /// Custom dark color style
  final ClockStyle? darkColorStyle;

  const CountdownClock({
    required this.duration,
    required this.active,
    this.emergencyThreshold,
    this.onFlag,
    this.onStop,
    this.lightColorStyle,
    this.darkColorStyle,
    super.key,
  });

  @override
  ConsumerState<CountdownClock> createState() => _CountdownClockState();
}

const _period = Duration(milliseconds: 100);
const _emergencyDelay = Duration(seconds: 20);

class _CountdownClockState extends ConsumerState<CountdownClock> {
  Timer? _timer;
  Duration timeLeft = Duration.zero;
  bool _shouldPlayEmergencyFeedback = true;
  DateTime? _nextEmergency;

  final _stopwatch = Stopwatch();

  void startClock() {
    _timer?.cancel();
    _stopwatch.reset();
    _stopwatch.start();
    _timer = Timer.periodic(_period, (timer) {
      setState(() {
        timeLeft = timeLeft - _stopwatch.elapsed;
        _stopwatch.reset();
        _playEmergencyFeedback();
        if (timeLeft <= Duration.zero) {
          widget.onFlag?.call();
          timeLeft = Duration.zero;
          stopClock();
        }
      });
    });
  }

  void stopClock() {
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
        (_nextEmergency == null || _nextEmergency!.isBefore(DateTime.now()))) {
      _shouldPlayEmergencyFeedback = false;
      _nextEmergency = DateTime.now().add(_emergencyDelay);
      ref.read(soundServiceProvider).play(Sound.lowTime);
      HapticFeedback.heavyImpact();
    } else if (widget.emergencyThreshold != null &&
        timeLeft > widget.emergencyThreshold! * 1.5) {
      _shouldPlayEmergencyFeedback = true;
    }
  }

  ClockStyle getStyle(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return widget.darkColorStyle ?? ClockStyle.darkThemeStyle;
    }

    return widget.lightColorStyle ?? ClockStyle.lightThemeStyle;
  }

  @override
  void initState() {
    super.initState();
    timeLeft = widget.duration;
    if (widget.active) {
      startClock();
    }
  }

  @override
  void didUpdateWidget(CountdownClock oldClock) {
    super.didUpdateWidget(oldClock);
    if (widget.duration != oldClock.duration) {
      timeLeft = widget.duration;
    }

    if (widget.active != oldClock.active) {
      widget.active ? startClock() : stopClock();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final hours = timeLeft.inHours;
    final mins = timeLeft.inMinutes.remainder(60);
    final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    final showTenths = timeLeft < const Duration(seconds: 10);
    final isEmergency = widget.emergencyThreshold != null &&
        timeLeft <= widget.emergencyThreshold!;
    final brightness = ref.watch(currentBrightnessProvider);
    final clockStyle = getStyle(brightness);
    final remainingHeight = estimateRemainingHeightLeftBoard(context);

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color: widget.active
              ? isEmergency
                  ? clockStyle.emergencyBackgroundColor
                  : clockStyle.activeBackgroundColor
              : clockStyle.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: kMaxClockTextScaleFactor,
            child: RichText(
              text: TextSpan(
                text: hours > 0
                    ? '$hours:${mins.toString().padLeft(2, '0')}:$secs'
                    : '$mins:$secs',
                style: TextStyle(
                  color: widget.active
                      ? isEmergency
                          ? clockStyle.emergencyTextColor
                          : clockStyle.activeTextColor
                      : clockStyle.textColor,
                  fontSize: 26,
                  height:
                      remainingHeight < kSmallRemainingHeightLeftBoardThreshold
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
                      style: const TextStyle(fontSize: 20),
                    ),
                  if (!widget.active && timeLeft < const Duration(seconds: 1))
                    TextSpan(
                      text:
                          '${timeLeft.inMilliseconds.remainder(1000) ~/ 10 % 10}',
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  final Color textColor;
  final Color activeTextColor;
  final Color emergencyTextColor;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color emergencyBackgroundColor;
}
