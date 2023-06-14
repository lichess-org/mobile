import 'dart:async';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/game/game.dart';
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
    final socket = ref.read(authSocketProvider);
    final playPref = ref.read(playPreferencesProvider);
    final lobbyRepo = ref.read(lobbyRepositoryProvider);

    final completer = Completer<PlayableGame>();

    final stream = socket.connect();
    _socketSubscription = stream.listen((event) {
      print('event: $event');
    });
    socket.sink?.add('null');

    socket.switchRoute(Uri(path: '/lobby/socket'));

    // await Result.release(
    //   lobbyRepo.createSeek(
    //     GameSeek(
    //       time: Duration(seconds: playPref.timeIncrement.time),
    //       increment: Duration(seconds: playPref.timeIncrement.increment),
    //       // TODO add rated choice
    //       rated: true,
    //     ),
    //   ),
    // );

    return completer.future;
  }

  void dispose() {
    _socketSubscription?.cancel();
  }
}
