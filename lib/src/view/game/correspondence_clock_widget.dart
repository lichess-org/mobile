import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';

class CorrespondenceClock extends ConsumerStatefulWidget {
  /// The duration left on the clock.
  final Duration duration;

  /// If [active] is `true`, the clock starts counting down.
  final bool active;

  /// Callback when the clock reaches zero.
  final VoidCallback? onFlag;

  const CorrespondenceClock({
    required this.duration,
    required this.active,
    this.onFlag,
    super.key,
  });

  @override
  ConsumerState<CorrespondenceClock> createState() =>
      _CorrespondenceClockState();
}

const _period = Duration(seconds: 1);

class _CorrespondenceClockState extends ConsumerState<CorrespondenceClock> {
  Timer? _timer;
  Duration timeLeft = Duration.zero;

  final _stopwatch = Stopwatch();

  void startClock() {
    _timer?.cancel();
    _stopwatch.reset();
    _stopwatch.start();
    _timer = Timer.periodic(_period, (timer) {
      setState(() {
        timeLeft = timeLeft - _stopwatch.elapsed;
        _stopwatch.reset();
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
  void didUpdateWidget(CorrespondenceClock oldClock) {
    super.didUpdateWidget(oldClock);
    if (widget.duration != oldClock.duration) {
      timeLeft = widget.duration;
    }
    if (widget.active) {
      startClock();
    } else {
      stopClock();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final days = timeLeft.inDays;
    final hours = timeLeft.inHours.remainder(24);
    final mins = timeLeft.inMinutes.remainder(60);
    final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    final brightness = ref.watch(currentBrightnessProvider);
    final clockStyle = brightness == Brightness.dark
        ? ClockStyle.darkThemeStyle
        : ClockStyle.lightThemeStyle;
    final remainingHeight = estimateRemainingHeightLeftBoard(context);

    final daysStr = days > 1
        ? context.l10n.nbDays(days)
        : days == 1
            ? context.l10n.oneDay
            : '';

    final hoursStr =
        days > 0 && hours > 0 ? ' ${context.l10n.nbHours(hours)}' : '';

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color: widget.active
              ? clockStyle.activeBackgroundColor
              : clockStyle.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: kMaxClockTextScaleFactor,
            child: RichText(
              textAlign: TextAlign.center,
              maxLines: 2,
              text: TextSpan(
                text: '$daysStr$hoursStr',
                style: TextStyle(
                  color: widget.active
                      ? clockStyle.activeTextColor
                      : clockStyle.textColor,
                  fontSize: 18,
                  height:
                      remainingHeight < kSmallRemainingHeightLeftBoardThreshold
                          ? 1.0
                          : null,
                  fontFeatures: days == 0
                      ? const [
                          FontFeature.tabularFigures(),
                        ]
                      : null,
                ),
                children: [
                  if (days == 0) ...[
                    TextSpan(text: hours.toString().padLeft(2, '0')),
                    TextSpan(
                      text: ':',
                      style: TextStyle(
                        color: widget.active &&
                                timeLeft.inSeconds.remainder(2) == 0
                            ? clockStyle.activeTextColor.withValues(alpha: 0.5)
                            : null,
                      ),
                    ),
                    TextSpan(text: mins.toString().padLeft(2, '0')),
                    if (hours == 0) ...[
                      const TextSpan(text: ':'),
                      TextSpan(text: secs),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
