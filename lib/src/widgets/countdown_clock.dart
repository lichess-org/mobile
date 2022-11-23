import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

class CountdownClock extends StatefulWidget {
  final Duration duration;
  final bool active;

  const CountdownClock({required this.duration, required this.active, Key? key})
      : super(key: key);

  @override
  State<CountdownClock> createState() => _CountdownClockState();
}

class _CountdownClockState extends State<CountdownClock> {
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: widget.active ? Colors.white : Colors.black,
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: Text('$min:$secs',
              style: TextStyle(
                color: widget.active ? Colors.black : Colors.grey,
                fontSize: 30,
                fontFeatures: const [
                  FontFeature.tabularFigures(),
                ],
              ))),
    );
  }
}
