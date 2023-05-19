import 'dart:math' as math;
import 'package:lichess_mobile/src/model/puzzle/puzzle_storm.dart';
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
    required this.ctrl,
  });

  final StormCtrlProvider ctrl;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends ConsumerState<StormClockWidget>
    with SingleTickerProviderStateMixin {
  // ignore: avoid-late-keyword
  late AnimationController _controller;
  // ignore: avoid-late-keyword
  late Animation<double> animation;
  // ignore: avoid-late-keyword
  late Animation<double> fadeAnimation;
  // ignore: avoid-late-keyword
  late Animation<Offset> slideAnimation;

  // ignore: avoid-late-keyword
  late StormClock clock;

  StreamSubscription<(Duration, int?)>? streamSubscription;

  String minutes = '03';
  String seconds = '00';
  int? bonus;
  Duration time = Duration.zero;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() => setState(() {}));

    clock = ref.read(widget.ctrl.select((value) => value.clock));
    minutes = clock.timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0');
    seconds = clock.timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    animation = Tween<double>(begin: 0.0, end: 120.0).animate(_controller);
    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    slideAnimation = Tween<Offset>(
      begin: const Offset(0.7, 0.0),
      end: const Offset(0.7, -1.0),
    ).animate(_controller);

    streamSubscription = clock.timeStream.listen((data) {
      // Update the widget state with the received data
      setState(() {
        // Assign the data values to the corresponding widget properties
        minutes = data.$1.inMinutes.remainder(60).toString().padLeft(2, '0');
        seconds = data.$1.inSeconds.remainder(60).toString().padLeft(2, '0');
        time = data.$1;
        bonus = data.$2;
        isActive = clock.isActive;
        if (bonus != null) {
          _controller.forward(from: 0);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  vector.Vector3 _shake() {
    return vector.Vector3(
      math.sin(_controller.value * math.pi * 5.0) * 10,
      0.0,
      0.0,
    );
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
        color: isActive
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
          child: Stack(
            children: [
              if (bonus != null)
                Positioned.fill(
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: Text(
                        bonus.toString(),
                        style: TextStyle(
                          color: bonus! < 0 ? Colors.red : LichessColors.good,
                          fontSize: 20,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
              ClipRect(
                child: Transform(
                  transform: Matrix4.translation(_shake()),
                  child: Text(
                    '$minutes:$seconds',
                    style: TextStyle(
                      color: isActive
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
            ],
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
