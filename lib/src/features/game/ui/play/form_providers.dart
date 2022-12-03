import 'package:meta/meta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide Tuple2;
import 'package:tuple/tuple.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/features/user/domain/user.dart';
import 'package:lichess_mobile/src/features/user/data/user_repository.dart';

final computerOpponentPrefProvider = createPrefProvider(
  prefKey: 'play.computerOpponent',
  defaultValue: ComputerOpponent.maia1,
  mapFrom: (v) => ComputerOpponent.values.firstWhere((e) => e.toString() == v,
      orElse: () => ComputerOpponent.maia1),
  mapTo: (v) => v.toString(),
);

final stockfishLevelProvider = createPrefProvider(
  prefKey: 'play.stockfishLevel',
  defaultValue: 1,
);

final maiaBotsProvider =
    FutureProvider.autoDispose<List<Tuple2<User, UserStatus>>>((ref) async {
  final userRepo = ref.watch(userRepositoryProvider);
  final maiaBotsTask = TaskEither.sequenceList([
    userRepo.getUser('maia1'),
    userRepo.getUser('maia5'),
    userRepo.getUser('maia9'),
  ]);
  final maiaStatusesTask = userRepo.getUsersStatus(['maia1', 'maia5', 'maia9']);
  final task = maiaBotsTask.flatMap((bots) => maiaStatusesTask.map(
        (statuses) => bots
            .map((bot) => Tuple2<User, UserStatus>(
                bot, statuses.firstWhere((s) => s.id == bot.id)))
            .toList(),
      ));
  final either = await task.run();
  // retry on error, cache indefinitely on success
  return either.match((error) => throw error, (data) {
    ref.keepAlive();
    return data;
  });
});

final timeControlPrefProvider = createPrefProvider(
  prefKey: 'play.TimeInc',
  defaultValue: TimeControl.blitz4,
  mapFrom: (v) => TimeControl.values.firstWhere(
      (e) => v != null ? e.value == TimeInc.fromString(v) : false,
      orElse: () => TimeControl.blitz4),
  mapTo: (v) => v.value.toString(),
);

// --

enum ComputerOpponent {
  maia1,
  maia5,
  maia9,
  stockfish,
}

@immutable
class TimeInc {
  const TimeInc(this.time, this.increment);

  /// Clock initial time in minutes
  final int time;

  /// Clock increment in seconds
  final int increment;

  static TimeInc? fromString(String str) {
    try {
      final nums = str.split(' + ').map(int.parse).toList();
      return TimeInc(nums[0], nums[1]);
    } catch (_) {
      return null;
    }
  }

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
  toString() => '$time + $increment';
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
