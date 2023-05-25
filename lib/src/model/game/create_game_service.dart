import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/lobby_event.dart';
import 'package:lichess_mobile/src/model/game/player.dart';

part 'create_game_service.g.dart';

@Riverpod(keepAlive: true)
CreateGameService createGameService(CreateGameServiceRef ref) {
  return CreateGameService(Logger('CreateGameService'), ref: ref);
}

class CreateGameService {
  const CreateGameService(this._log, {required this.ref});

  final CreateGameServiceRef ref;
  final Logger _log;

  FutureResult<PlayableGame> _waitForGameStart() {
    return Result.capture(
      (() async {
        final gameRepo = ref.read(gameRepositoryProvider);
        final stream = gameRepo.lobbyEvents().timeout(
              const Duration(seconds: 15),
              onTimeout: (sink) => sink.close(),
            );

        final startEvent = await stream.firstWhere(
          (event) => event.type == GameEventLifecycle.start,
          orElse: () {
            throw Exception('Could not create game.');
          },
        );

        return PlayableGame(
          id: startEvent.gameId,
          fullId: startEvent.fullId,
          initialFen: startEvent.fen,
          speed: startEvent.speed,
          orientation: startEvent.side,
          rated: startEvent.rated,
          opponent: Player(
            id: startEvent.opponent.id,
            name: startEvent.opponent.username,
            rating: startEvent.opponent.rating,
          ),
          status: startEvent.status,
          perf: startEvent.perf,
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
