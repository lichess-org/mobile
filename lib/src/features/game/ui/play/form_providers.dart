import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart' hide Tuple2;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide Tuple2;
import 'package:tuple/tuple.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/features/user/domain/user.dart';
import 'package:lichess_mobile/src/features/user/data/user_repository.dart';
import '../../data/challenge_repository.dart';
import '../../data/game_repository.dart';
import '../../domain/game.dart';

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

class PlayActionNotifier extends AutoDisposeNotifier<AsyncValue<Game?>> {
  @override
  AsyncValue<Game?> build() {
    return const AsyncData(null);
  }

  Future<void> createGame({
    required User account,
    required ComputerOpponent opponent,
    required TimeInc timeControl,
    required int level,
  }) async {
    final challengeRepo = ref.read(challengeRepositoryProvider);
    final task = opponent == ComputerOpponent.stockfish
        ? challengeRepo.challengeAI(AiChallengeRequest(
            time: Duration(minutes: timeControl.time),
            increment: Duration(seconds: timeControl.increment),
            level: level))
        : challengeRepo.createChallenge(
            opponent.name,
            ChallengeRequest(
                time: Duration(minutes: timeControl.time),
                increment: Duration(seconds: timeControl.increment)));

    state = const AsyncLoading();
    state = (await (task.run())).match(
        (error) => AsyncValue.error(error.message, error.stackTrace),
        (_) => const AsyncLoading());

    await for (Map<String, dynamic> event
        in ref.read(gameRepositoryProvider).events()) {
      switch (event['type']) {
        case 'gameStart':
          if (state is AsyncLoading) {
            final game = event['game'];
            if (game['compat']['board']) {
              final perf = Perf.values.firstWhere((v) => v.name == game['perf'],
                  orElse: () => Perf.blitz);
              final player = Player(
                id: account.id,
                name: account.username,
                rating: account.perfs[perf]!.rating,
              );
              final opponent = Player(
                  id: game['opponent']['id'],
                  name: game['opponent']['username'],
                  rating: game['opponent']['rating']);
              state = AsyncValue.data(Game(
                id: game['gameId'],
                initialFen: game['fen'],
                speed: Speed.values.firstWhere((v) => v.name == game['speed'],
                    orElse: () => Speed.blitz),
                orientation: Side.values.firstWhere(
                    (v) => v.name == game['color'],
                    orElse: () => Side.white),
                rated: game['rated'],
                white: game['color'] == 'white' ? player : opponent,
                black: game['color'] == 'white' ? opponent : player,
              ));
            }
          }
      }
    }
  }
}

final playActionProvider =
    AutoDisposeNotifierProvider<PlayActionNotifier, AsyncValue<Game?>>(
        PlayActionNotifier.new);

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
  toString() => '$time + $increment';

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && hashCode == other.hashCode;
  }

  @override
  int get hashCode => Object.hash(time, increment);
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
