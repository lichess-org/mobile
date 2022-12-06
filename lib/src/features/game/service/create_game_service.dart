import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart' hide Tuple2;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/features/user/domain/user.dart';
import '../data/play_preferences.dart';
import '../data/challenge_repository.dart';
import '../data/game_repository.dart';
import '../domain/computer_opponent.dart';
import '../domain/game.dart';

class CreateGameService {
  const CreateGameService(this._log, {required this.ref});

  final Ref ref;
  final Logger _log;

  TaskEither<IOError, Game> aiGameTask(User account, {Side? side}) {
    final challengeRepo = ref.read(challengeRepositoryProvider);
    final opponent = ref.read(computerOpponentPrefProvider);
    final timeControl = ref.read(timeControlPrefProvider).value;
    final level = ref.read(stockfishLevelProvider);

    final createChallengeTask = opponent == ComputerOpponent.stockfish
        ? challengeRepo.challengeAI(AiChallengeRequest(
            time: Duration(minutes: timeControl.time),
            increment: Duration(seconds: timeControl.increment),
            side: side,
            level: level))
        : challengeRepo.createChallenge(
            opponent.name,
            ChallengeRequest(
                time: Duration(minutes: timeControl.time),
                side: side,
                increment: Duration(seconds: timeControl.increment)));

    return createChallengeTask.andThen(() => _waitForGameStart(account));
  }

  TaskEither<IOError, Game> _waitForGameStart(User account) {
    return TaskEither<IOError, Game>.tryCatch(
      () async {
        final gameRepo = ref.read(gameRepositoryProvider);
        final stream = gameRepo.events().timeout(const Duration(seconds: 15),
            onTimeout: (sink) => sink.close());

        await for (Map<String, dynamic> event in stream) {
          switch (event['type']) {
            case 'gameStart':
              final game = event['game'];
              if (game['compat']['board']) {
                final perf = Perf.values.firstWhere(
                    (v) => v.name == game['perf'],
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
                return Game(
                  id: GameId(value: game['gameId'] as String),
                  initialFen: game['fen'],
                  speed: Speed.values.firstWhere((v) => v.name == game['speed'],
                      orElse: () => Speed.blitz),
                  orientation: Side.values.firstWhere(
                      (v) => v.name == game['color'],
                      orElse: () => Side.white),
                  rated: game['rated'],
                  white: game['color'] == 'white' ? player : opponent,
                  black: game['color'] == 'white' ? opponent : player,
                );
              }
          }
        }
        throw Exception('Could not create game');
      },
      (error, trace) {
        _log.severe('Request error', error, trace);
        return GenericError(trace);
      },
    );
  }
}

final createGameServiceProvider = Provider<CreateGameService>((ref) {
  return CreateGameService(Logger('CreateGameService'), ref: ref);
});
