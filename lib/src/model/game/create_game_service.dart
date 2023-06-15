import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
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
    final socket = ref.read(authSocketProvider);
    final playPref = ref.read(playPreferencesProvider);
    final lobbyRepo = ref.read(lobbyRepositoryProvider);

    final completer = Completer<PlayableGame>();

    final stream = socket.connect();

    _socketSubscription = stream.listen((event) {
      debugPrint('event: $event');
      final msg = jsonDecode(event as String) as Map<String, dynamic>;
      switch (msg['t'] as String) {
        case 'redirect':
          // ignore: avoid_dynamic_calls
          final gameId = msg['d']['id'] as String;
          socket.switchRoute(Uri(path: '/play/$gameId'));

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
    ref.invalidate(authClientProvider);
    _socketSubscription?.cancel();
  }
}

PlayableGame _playableGameFromJson(Map<String, dynamic> json) =>
    _playableGameFromPick(pick(json).required());

PlayableGame _playableGameFromPick(RequiredPick pick) {
  return PlayableGame(
    id: pick('id').asGameIdOrThrow(),
    rated: pick('rated').asBoolOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    status: pick('status').asGameStatusOrThrow(),
    white: pick('players', 'white').letOrThrow(_playerFromUserGamePick),
    black: pick('players', 'black').letOrThrow(_playerFromUserGamePick),
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
