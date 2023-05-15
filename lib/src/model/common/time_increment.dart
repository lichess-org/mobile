import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/model/common/speed.dart';

/// A pair of time and increment used as game clock
@immutable
class TimeIncrement {
  const TimeIncrement(this.time, this.increment)
      : assert(time >= 0 && increment >= 0);

  /// Clock initial time in minutes
  final int time;

  /// Clock increment in seconds
  final int increment;

  static TimeIncrement? fromString(String str) {
    try {
      final nums = str.split('+').map(int.parse).toList();
      return TimeIncrement(nums.first, nums[1]);
    } catch (_) {
      return null;
    }
  }

  TimeIncrement.fromJson(Map<String, dynamic> json)
      : time = json['time'] as int,
        increment = json['increment'] as int;

  Map<String, dynamic> toJson() => {
        'time': time,
        'increment': increment,
      };

  int get totalSeconds => time * 60 + increment;

  Speed get speed => Speed.fromTimeIncrement(this);

  String get display => '$time + $increment';

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
  String toString() => '$time+$increment';
}
