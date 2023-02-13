import 'package:logging/logging.dart';
import 'package:async/async.dart';
import 'package:dartchess/dartchess.dart' hide Tuple2;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/account/account_providers.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_request.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'play_preferences.dart';
import 'board_repository.dart';
import 'api_event.dart';
import 'computer_opponent.dart';

class CreateGameService {
  const CreateGameService(this._log, {required this.ref});

  final Ref ref;
  final Logger _log;

  FutureResult<PlayableGame> aiGame({Side? side}) {
    final challengeRepo = ref.read(challengeRepositoryProvider);
    final opponent = ref.read(computerOpponentPrefProvider);
    final maiaStrength = ref.read(maiaStrengthProvider);
    final timeControl = ref.read(timeControlPrefProvider).value;
    final level = ref.read(stockfishLevelProvider);

    final challengeRequest = ChallengeRequest(
      time: Duration(minutes: timeControl.time),
      side: side,
      increment: Duration(seconds: timeControl.increment),
    );
    final createChallengeTask = opponent == ComputerOpponent.stockfish
        ? challengeRepo.challengeAI(
            AiChallengeRequest(level: level, challenge: challengeRequest),
          )
        : challengeRepo.challenge(maiaStrength.name, challengeRequest);

    return createChallengeTask.flatMap((_) => _waitForGameStart());
  }

  FutureResult<PlayableGame> _waitForGameStart() {
    return Result.capture(
      (() async {
        final boardRepo = ref.read(boardRepositoryProvider);
        final stream = boardRepo.events().timeout(
              const Duration(seconds: 15),
              onTimeout: (sink) => sink.close(),
            );

        final startEvent = await stream.firstWhere(
          (event) =>
              event.type == BoardEventLifecycle.start && event.boardCompat,
          orElse: () {
            throw Exception('Could not create game.');
          },
        );

        final account = await ref.read(accountProvider.future);

        final player = Player(
          id: account.id,
          name: account.username,
          rating: account.perfs[startEvent.perf]!.rating,
        );
        final opponent = Player(
          id: startEvent.opponent.id,
          name: startEvent.opponent.username,
          rating: startEvent.opponent.rating,
        );
        return PlayableGame(
          id: startEvent.gameId,
          initialFen: startEvent.fen,
          speed: startEvent.speed,
          orientation: startEvent.side,
          rated: startEvent.rated,
          white: startEvent.side == Side.white ? player : opponent,
          black: startEvent.side == Side.white ? opponent : player,
          variant: Variant.standard,
        );
      })(),
    ).mapError(
      (error, trace) {
        _log.severe('Request error', error, trace);
        return GenericIOException();
      },
    );
  }
}

final createGameServiceProvider = Provider<CreateGameService>((ref) {
  return CreateGameService(Logger('CreateGameService'), ref: ref);
});
