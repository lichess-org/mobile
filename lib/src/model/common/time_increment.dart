import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/model/common/speed.dart';

/// A pair of time and increment in seconds used as game clock
@immutable
class TimeIncrement {
  const TimeIncrement(this.time, this.increment)
      : assert(time >= 0 && increment >= 0);

  /// Clock initial time in seconds
  final int time;

  /// Clock increment in seconds
  final int increment;

  TimeIncrement.fromJson(Map<String, dynamic> json)
      : time = json['time'] as int,
        increment = json['increment'] as int;

  Map<String, dynamic> toJson() => {
        'time': time,
        'increment': increment,
      };

  /// Returns the estimated duration of the game, with increment * 40 added to
  /// the initial time.
  Duration get estimatedDuration => Duration(seconds: time + increment * 40);

  Speed get speed => Speed.fromTimeIncrement(this);

  String get display {
    switch (time) {
      case 0:
        if (increment == 0) {
          return '∞';
        } else {
          return '0+$increment';
        }
      case 15:
        return '¼+$increment';
      case 30:
        return '½+$increment';
      case 45:
        return '¾+$increment';
      case 90:
        return '1.5+$increment';
      default:
        // General case for other times
        return '${(time / 60).floor()}+$increment';
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
}
