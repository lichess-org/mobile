import 'package:meta/meta.dart';

import 'package:lichess_mobile/src/common/models.dart';

@immutable
class TimeInc {
  const TimeInc(this.time, this.increment);

  /// Clock initial time in minutes
  final int time;

  /// Clock increment in seconds
  final int increment;

  static TimeInc? fromString(String str) {
    try {
      final nums = str.split('+').map(int.parse).toList();
      return TimeInc(nums[0], nums[1]);
    } catch (_) {
      return null;
    }
  }

  String get display => '$time + $increment';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeInc &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          increment == other.increment;

  @override
  int get hashCode => Object.hash(time, increment);

  @override
  String toString() => '$time+$increment';
}

enum TimeControl {
  blitz1(TimeInc(3, 0), Perf.blitz),
  blitz2(TimeInc(3, 2), Perf.blitz),
  blitz3(TimeInc(5, 0), Perf.blitz),
  blitz4(TimeInc(5, 3), Perf.blitz),
  rapid1(TimeInc(10, 0), Perf.rapid),
  rapid2(TimeInc(10, 5), Perf.rapid),
  rapid3(TimeInc(15, 10), Perf.rapid),
  classical1(TimeInc(30, 0), Perf.classical),
  classical2(TimeInc(30, 20), Perf.classical);

  const TimeControl(this.value, this.perf);
  final TimeInc value;
  final Perf perf;
}
