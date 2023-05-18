import 'dart:math' as math;
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:ui';

import 'package:lichess_mobile/src/model/settings/brightness.dart';

const _kMaxClockTextScaleFactor = 1.94;

/// A simple countdown clock.
///
/// The clock starts only when [active] is `true`.
class CountdownClock extends ConsumerStatefulWidget {
  final Duration duration;
  final bool active;

  const CountdownClock({
    required this.duration,
    required this.active,
    super.key,
  });

  @override
  ConsumerState<CountdownClock> createState() => _CountdownClockState();
}

class _CountdownClockState extends ConsumerState<CountdownClock> {
  static const _period = Duration(milliseconds: 100);
  Timer? _timer;
  Duration timeLeft = Duration.zero;

  Timer startTimer() {
    return Timer.periodic(_period, (timer) {
      setState(() {
        timeLeft = timeLeft - _period;
        if (timeLeft <= Duration.zero) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    timeLeft = widget.duration;
    if (widget.active) {
      _timer = startTimer();
    }
  }

  @override
  void didUpdateWidget(CountdownClock oldClock) {
    super.didUpdateWidget(oldClock);
    _timer?.cancel();
    timeLeft = widget.duration;
    if (widget.active) {
      _timer = startTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final min = timeLeft.inMinutes.remainder(60);
    final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    final brightness = ref.watch(currentBrightnessProvider);
    final clockStyle = brightness == Brightness.dark
        ? ClockStyle.darkThemeStyle
        : ClockStyle.lightThemeStyle;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        color: widget.active
            ? clockStyle.activeBackgroundColor
            : clockStyle.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
        child: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaleFactor: math.min(
              mediaQueryData.textScaleFactor,
              _kMaxClockTextScaleFactor,
            ),
          ),
          child: Text(
            '$min:$secs',
            style: TextStyle(
              color: widget.active
                  ? clockStyle.activeTextColor
                  : clockStyle.textColor,
              fontSize: 30,
              fontFeatures: const [
                FontFeature.tabularFigures(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StormClockWidget extends ConsumerStatefulWidget {
  const StormClockWidget({
    required this.minutes,
    required this.seconds,
    required this.time,
    required this.bonus,
    required this.isActive,
  });

  final String minutes;
  final String seconds;
  final Duration time;
  final bool isActive;
  final int? bonus;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends ConsumerState<StormClockWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // ignore: avoid-late-keyword
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(begin: 0.0, end: 120.0).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant StormClockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bonus == null && widget.bonus != null && widget.bonus! < 0) {
      _controller.forward(from: 0);
    }
  }

  vector.Vector3 _shake() {
    return vector.Vector3(
      math.sin(_controller.value * math.pi * 5.0) * 10,
      0.0,
      0.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext build) {
    final brightness = ref.watch(currentBrightnessProvider);
    final clockStyle = brightness == Brightness.dark
        ? ClockStyle.darkThemeStyle
        : ClockStyle.lightThemeStyle;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        color: widget.isActive
            ? clockStyle.activeBackgroundColor
            : clockStyle.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
        child: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaleFactor: math.min(
              mediaQueryData.textScaleFactor,
              _kMaxClockTextScaleFactor,
            ),
          ),
          child: ClipRect(
            child: Transform(
              transform: Matrix4.translation(_shake()),
              child: Text(
                '${widget.minutes}:${widget.seconds}',
                style: TextStyle(
                  color: widget.isActive
                      ? (widget.bonus != null)
                          ? (widget.bonus! > 0)
                              ? LichessColors.good
                              : Colors.red
                          : clockStyle.activeTextColor
                      : clockStyle.textColor,
                  fontSize: 30,
                  fontFeatures: const [
                    FontFeature.tabularFigures(),
                  ],
                ),
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
    required this.backgroundColor,
    required this.activeBackgroundColor,
  });

  static const darkThemeStyle = ClockStyle(
    textColor: Colors.grey,
    activeTextColor: Colors.black,
    backgroundColor: Colors.black,
    activeBackgroundColor: Colors.white,
  );

  static const lightThemeStyle = ClockStyle(
    textColor: Colors.grey,
    activeTextColor: Colors.black,
    backgroundColor: Colors.white,
    activeBackgroundColor: Color(0xFFD0E0BD),
  );

  final Color textColor;
  final Color activeTextColor;
  final Color backgroundColor;
  final Color activeBackgroundColor;
}
