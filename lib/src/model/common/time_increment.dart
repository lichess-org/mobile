import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/model/common/speed.dart';

/// A pair of time and increment in seconds used as game clock
@immutable
class TimeIncrement implements Comparable<TimeIncrement> {
  const TimeIncrement(this.time, this.increment, {this.delay = 0})
    : assert(time >= 0 && increment >= 0 && delay >= 0);

  TimeIncrement.fromDurations(Duration time, Duration increment, {Duration delay = Duration.zero})
    : time = time.inSeconds,
      increment = increment.inSeconds,
      delay = delay.inSeconds,
      assert(time >= Duration.zero && increment >= Duration.zero && delay >= Duration.zero);

  const TimeIncrement.infinite() : time = 0, increment = 0, delay = 0;

  /// Clock initial time in seconds
  final int time;

  /// Clock increment in seconds
  final int increment;

  /// Clock simple (US) delay in seconds. Only used by the local clock tool:
  /// lichess online play does not support delay.
  final int delay;

  TimeIncrement.fromJson(Map<String, dynamic> json)
    : time = json['time'] as int,
      increment = json['increment'] as int,
      delay = json['delay'] as int? ?? 0;

  Map<String, dynamic> toJson() => {'time': time, 'increment': increment, 'delay': delay};

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

  bool get isCustom => presets.contains(this) == false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeIncrement &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          increment == other.increment &&
          delay == other.delay;

  @override
  int get hashCode => Object.hash(time, increment, delay);

  @override
  String toString() => 'TimeIncrement($time+$increment${delay > 0 ? ' d$delay' : ''})';

  @override
  int compareTo(TimeIncrement other) {
    return estimatedDuration.compareTo(other.estimatedDuration);
  }

  static const matrixPresets = [
    TimeIncrement(60, 0),
    TimeIncrement(120, 1),
    TimeIncrement(180, 0),
    TimeIncrement(180, 2),
    TimeIncrement(300, 0),
    TimeIncrement(300, 3),
    TimeIncrement(600, 0),
    TimeIncrement(600, 5),
    TimeIncrement(900, 10),
    TimeIncrement(1800, 0),
    TimeIncrement(1800, 20),
  ];

  static const presets = [
    TimeIncrement(0, 1),
    TimeIncrement(60, 0),
    TimeIncrement(60, 1),
    TimeIncrement(120, 1),
    TimeIncrement(180, 0),
    TimeIncrement(180, 2),
    TimeIncrement(300, 0),
    TimeIncrement(300, 3),
    TimeIncrement(600, 0),
    TimeIncrement(600, 5),
    TimeIncrement(900, 0),
    TimeIncrement(900, 10),
    TimeIncrement(1500, 0),
    TimeIncrement(1800, 0),
    TimeIncrement(1800, 20),
    TimeIncrement(3600, 0),
  ];
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
