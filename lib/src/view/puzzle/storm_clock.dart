import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/puzzle/storm_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/clock.dart' show ClockStyle;

const _kClockFontSize = 26.0;

class StormClockWidget extends StatefulWidget {
  const StormClockWidget({required this.clock});

  final StormClock clock;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<StormClockWidget> with SingleTickerProviderStateMixin {
  // ignore: avoid-late-keyword
  late AnimationController _controller;

  // ignore: avoid-late-keyword
  late final Animation<double> _bonusFadeAnimation = Tween<double>(
    begin: 1.0,
    end: 0.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  // ignore: avoid-late-keyword
  late final Animation<Offset> _bonusSlideAnimation = Tween<Offset>(
    begin: const Offset(0.7, 0.0),
    end: const Offset(0.7, -1.0),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  StreamSubscription<(Duration, int?)>? streamSubscription;

  int? currentBonusSeconds;
  Duration time = Duration.zero;
  bool isActive = false;

  @override
  void initState() {
    super.initState();

    // declaring as late final causes an error because the widget is being disposed
    // after the clock start
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            currentBonusSeconds = null;
          });
        }
      });

    time = widget.clock.timeLeft;

    _subscribeToStream();
  }

  @override
  void didUpdateWidget(covariant StormClockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clock != widget.clock) {
      _subscribeToStream();
    }
  }

  void _subscribeToStream() {
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
    final brightness = Theme.of(context).brightness;
    final colorScheme = ColorScheme.of(context);
    final effectiveClockStyle = ClockStyle.defaultStyle(brightness, colorScheme);

    final minutes = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = time.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        color:
            isActive
                ? effectiveClockStyle.activeBackgroundColor
                : effectiveClockStyle.backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: kMaxClockTextScaleFactor,
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
                        color:
                            currentBonusSeconds! < 0
                                ? context.lichessColors.error
                                : context.lichessColors.good,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
                  final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
                  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
                  return Text(
                    '$minutes:$seconds',
                    style: TextStyle(
                      color:
                          currentBonusSeconds! < 0
                              ? context.lichessColors.error
                              : context.lichessColors.good,
                      fontSize: _kClockFontSize,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  );
                },
              )
            else
              Text(
                '$minutes:$seconds',
                style: TextStyle(
                  color:
                      isActive
                          ? effectiveClockStyle.activeTextColor
                          : effectiveClockStyle.textColor,
                  fontSize: _kClockFontSize,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
