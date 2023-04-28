import 'package:flutter/widgets.dart';

import 'perf.dart';

/// A pair of time and increment used as game clock
@immutable
class TimeIncrement {
  const TimeIncrement(this.time, this.increment);

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

/// Default game clock choice of lichess
enum DefaultGameClock {
  blitz3_0(TimeIncrement(3, 0), Perf.blitz),
  blitz3_2(TimeIncrement(3, 2), Perf.blitz),
  blitz5_0(TimeIncrement(5, 0), Perf.blitz),
  blitz5_3(TimeIncrement(5, 3), Perf.blitz),
  rapid10_0(TimeIncrement(10, 0), Perf.rapid),
  rapid10_5(TimeIncrement(10, 5), Perf.rapid),
  rapid15_10(TimeIncrement(15, 10), Perf.rapid),
  classical30_0(TimeIncrement(30, 0), Perf.classical),
  classical30_20(TimeIncrement(30, 20), Perf.classical);

  const DefaultGameClock(this.value, this.perf);
  final TimeIncrement value;
  final Perf perf;
}
