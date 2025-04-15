import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/model/common/speed.dart';

/// A pair of time and increment in seconds used as game clock
@immutable
class TimeIncrement implements Comparable<TimeIncrement> {
  const TimeIncrement(this.time, this.increment) : assert(time >= 0 && increment >= 0);

  TimeIncrement.fromDurations(Duration time, Duration increment)
    : time = time.inSeconds,
      increment = increment.inSeconds,
      assert(time >= Duration.zero && increment >= Duration.zero);

  /// Clock initial time in seconds
  final int time;

  /// Clock increment in seconds
  final int increment;

  TimeIncrement.fromJson(Map<String, dynamic> json)
    : time = json['time'] as int,
      increment = json['increment'] as int;

  Map<String, dynamic> toJson() => {'time': time, 'increment': increment};

  /// Returns the estimated duration of the game, with increment * 40 added to
  /// the initial time.
  Duration get estimatedDuration => Duration(seconds: time + increment * 40);

  Speed get speed => Speed.fromTimeIncrement(this);

  bool get isInfinite => time == 0 && increment == 0;

  String get display {
    if (isInfinite) {
      return '∞';
    } else {
      return '${clockLabelInMinutes(time)}+$increment';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeIncrement &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          increment == other.increment;

  @override
  int get hashCode => Object.hash(time, increment);

  @override
  String toString() => 'TimeIncrement($time+$increment)';

  @override
  int compareTo(TimeIncrement other) {
    return estimatedDuration.compareTo(other.estimatedDuration);
  }
}

/// Displays a chess clock time in minutes from an amount of seconds
String clockLabelInMinutes(num seconds) {
  switch (seconds) {
    case 0:
      return '0';
    case 45:
      return '¾';
    case 30:
      return '½';
    case 15:
      return '¼';
    default:
      return (seconds / 60).toString().replaceAll('.0', '');
  }
}
