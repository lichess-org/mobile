import 'dart:async';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';

part 'create_game_service.g.dart';

@Riverpod(keepAlive: true)
CreateGameService createGameService(CreateGameServiceRef ref) {
  return CreateGameService(Logger('CreateGameService'), ref: ref);
}

class CreateGameService {
  CreateGameService(this._log, {required this.ref});

  final CreateGameServiceRef ref;
  final Logger _log;

  StreamSubscription<dynamic>? _socketSubscription;

  Future<PlayableGame> newOnlineGame() async {
    if (_socketSubscription != null) {
      throw Exception('Already creating a game');
    }

    final socket = ref.read(authSocketProvider);
    final playPref = ref.read(playPreferencesProvider);
    final lobbyRepo = ref.read(lobbyRepositoryProvider);

    final completer = Completer<PlayableGame>();

    final stream = socket.connect();

    _socketSubscription = stream.listen((msg) {
      switch (msg['t'] as String) {
        case 'redirect':
          // ignore: avoid_dynamic_calls
          final gameId = msg['d']['id'] as String;
          socket.switchRoute(Uri(path: '/play/$gameId/v6'));

        case 'full':
          final game =
              // ignore: avoid_dynamic_calls
              _playableGameFromJson(msg['d']['game'] as Map<String, dynamic>);
          completer.complete(game);
      }
    });

    socket.switchRoute(Uri(path: '/lobby/socket/v5'));

    _log.info('Creating new online game');

    await Result.release(
      lobbyRepo.createSeek(
        GameSeek(
          time: Duration(seconds: playPref.timeIncrement.time),
          increment: Duration(seconds: playPref.timeIncrement.increment),
          // TODO add rated choice
          rated: true,
        ),
        sri: socket.sri!,
      ),
    );

    return completer.future;
  }

  void dispose() {
    // close client connection to cancel seek
    // cf: https://lichess.org/api#tag/Board/operation/apiBoardSeek
    ref.invalidate(httpClientProvider);
    _socketSubscription?.cancel();
    _socketSubscription = null;
  }
}

PlayableGame _playableGameFromJson(Map<String, dynamic> json) =>
    _playableGameFromPick(pick(json).required());

PlayableGame _playableGameFromPick(RequiredPick pick) {
  final data = _playableGameDataFromPick(pick);

  return PlayableGame(
    data: data,
    steps: pick('pgn').letOrThrow((it) {
      final moves = it.asStringOrThrow().split(' ');
      // assume lichess always send initialFen with fromPosition and chess960
      Position position = (data.variant == Variant.fromPosition ||
              data.variant == Variant.chess960)
          ? Chess.fromSetup(Setup.parseFen(data.initialFen!))
          : data.variant.initialPosition;
      int ply = 0;
      final List<GameStep> steps = [GameStep(ply: ply, position: position)];
      for (final san in moves) {
        ply++;
        final move = position.parseSan(san);
        // assume lichess only sends correct moves
        position = position.playUnchecked(move!);
        steps.add(
          GameStep(
            ply: ply,
            san: san,
            uci: move.uci,
            position: position,
            diff: MaterialDiff.fromBoard(position.board),
          ),
        );
      }
      return IList(steps);
    }),
  );
}

PlayableGameData _playableGameDataFromPick(RequiredPick pick) {
  return PlayableGameData(
    id: pick('id').asGameIdOrThrow(),
    rated: pick('rated').asBoolOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    status: pick('status').asGameStatusOrThrow(),
    white: pick('white').letOrThrow(_playerFromUserGamePick),
    black: pick('black').letOrThrow(_playerFromUserGamePick),
    variant: pick('variant').asVariantOrThrow(),
    initialFen: pick('initialFen').asStringOrNull(),
  );
}

Player _playerFromUserGamePick(RequiredPick pick) {
  return Player(
    id: pick('user', 'id').asUserIdOrNull(),
    name: pick('user', 'name').asStringOrNull() ?? 'Stockfish',
    patron: pick('user', 'patron').asBoolOrNull(),
    title: pick('user', 'title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    aiLevel: pick('aiLevel').asIntOrNull(),
  );
}
