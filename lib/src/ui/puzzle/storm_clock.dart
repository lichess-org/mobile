import 'dart:math' as math;
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/puzzle/storm_ctrl.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/constants.dart';

class StormClockWidget extends ConsumerStatefulWidget {
  const StormClockWidget({required this.clock});

  final StormClock clock;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends ConsumerState<StormClockWidget>
    with SingleTickerProviderStateMixin {
  // ignore: avoid-late-keyword
  late AnimationController _controller;

  // ignore: avoid-late-keyword
  late final Animation<double> _bonusFadeAnimation =
      Tween<double>(begin: 1.0, end: 0.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );
  // ignore: avoid-late-keyword
  late final Animation<Offset> _bonusSlideAnimation = Tween<Offset>(
    begin: const Offset(0.7, 0.0),
    end: const Offset(0.7, -1.0),
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );

  StreamSubscription<(Duration, int?)>? streamSubscription;

  int? currentBonusSeconds;
  Duration time = Duration.zero;
  bool isActive = false;

  @override
  void initState() {
    super.initState();

    // declaring as late final causes an error because the widget is being disposed
    // after the clock start
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            currentBonusSeconds = null;
          });
        }
      });

    time = widget.clock.timeLeft;

    streamSubscription = widget.clock.timeStream.listen((data) {
      final (newTime, bonusSeconds) = data;

      setState(() {
        time = newTime;
        isActive = widget.clock.isActive;
      });

      if (bonusSeconds != null) {
        setState(() {
          currentBonusSeconds = bonusSeconds;
        });
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext build) {
    final brightness = ref.watch(currentBrightnessProvider);
    final clockStyle = brightness == Brightness.dark
        ? _ClockStyle.darkThemeStyle
        : _ClockStyle.lightThemeStyle;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final minutes = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = time.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        color: clockStyle.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
        child: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaleFactor: math.min(
              mediaQueryData.textScaleFactor,
              kMaxClockTextScaleFactor,
            ),
          ),
          child: Stack(
            children: [
              if (currentBonusSeconds != null)
                Positioned.fill(
                  child: FadeTransition(
                    opacity: _bonusFadeAnimation,
                    child: SlideTransition(
                      position: _bonusSlideAnimation,
                      child: Text(
                        '${currentBonusSeconds! > 0 ? '+' : ''}$currentBonusSeconds',
                        style: TextStyle(
                          color: currentBonusSeconds! < 0
                              ? Colors.red
                              : LichessColors.good,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
              if (currentBonusSeconds != null)
                TweenAnimationBuilder(
                  tween: Tween<Duration>(
                    begin: time - Duration(seconds: currentBonusSeconds!),
                    end: time,
                  ),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, Duration value, _) {
                    final minutes = value.inMinutes
                        .remainder(60)
                        .toString()
                        .padLeft(2, '0');
                    final seconds = value.inSeconds
                        .remainder(60)
                        .toString()
                        .padLeft(2, '0');
                    return Text(
                      '$minutes:$seconds',
                      style: TextStyle(
                        color: currentBonusSeconds! < 0
                            ? Colors.red
                            : LichessColors.good,
                        fontSize: 30,
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    );
                  },
                )
              else
                Text(
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
            ],
          ),
        ),
      ),
    );
  }
}

enum _ClockStyle {
  darkThemeStyle(
    textColor: Colors.grey,
    activeTextColor: Colors.white,
    backgroundColor: Color(0xFF333333),
  ),
  lightThemeStyle(
    textColor: Colors.grey,
    activeTextColor: Colors.black,
    backgroundColor: Colors.white,
  );

  const _ClockStyle({
    required this.textColor,
    required this.activeTextColor,
    required this.backgroundColor,
  });

  final Color textColor;
  final Color activeTextColor;
  final Color backgroundColor;
}
