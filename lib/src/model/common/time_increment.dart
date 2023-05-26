import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/model/common/speed.dart';

/// A pair of time and increment in seconds used as game clock
///
/// If both time and increment are 0, the clock is infinite.
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

  Duration get duration => Duration(seconds: time + increment);

  Speed get speed => Speed.fromTimeIncrement(this);

  String get display {
    String displayTime = '';
    switch (time) {
      case 0:
        if (increment == 0) {
          displayTime = '∞';
        } else {
          displayTime = '0 + $increment';
        }
      case 45:
        displayTime = '¾ + $increment';
      case 30:
        displayTime = '½ + $increment';
      case 15:
        displayTime = '¼ + $increment';
      default:
        displayTime = '${(time / 60).floor()} + $increment';
    }
    return displayTime;
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
