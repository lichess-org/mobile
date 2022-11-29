import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide Tuple2;
import 'package:tuple/tuple.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/features/user/domain/user.dart';
import 'package:lichess_mobile/src/features/user/data/user_repository.dart';

enum ComputerOpponent {
  maia1,
  maia5,
  maia9,
  stockfish,
}

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
    FutureProvider<List<Tuple2<User, UserStatus>>>((ref) async {
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
  return either.match((error) => throw error, (data) => data);
});
