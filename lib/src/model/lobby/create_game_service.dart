import 'dart:async';

import 'package:async/async.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_game_service.g.dart';

@Riverpod(keepAlive: true)
CreateGameService createGameService(CreateGameServiceRef ref) {
  return CreateGameService(Logger('CreateGameService'), ref: ref);
}

class CreateGameService {
  CreateGameService(this._log, {required this.ref});

  final CreateGameServiceRef ref;
  final Logger _log;

  StreamSubscription<SocketEvent>? _socketSubscription;

  Future<GameFullId> newLobbyGame(GameSeek seek) async {
    if (_socketSubscription != null) {
      throw StateError('Already creating a game.');
    }

    final socket = ref.read(authSocketProvider);
    final lobbyRepo = ref.read(lobbyRepositoryProvider);
    final (stream, readyStream) = socket.connect(Uri(path: '/lobby/socket/v5'));
    final completer = Completer<GameFullId>();

    _socketSubscription = stream.listen((event) {
      if (event.topic == 'redirect') {
        final data = event.data as Map<String, dynamic>;
        completer.complete(pick(data['id']).asGameFullIdOrThrow());
        _socketSubscription?.cancel();
        _socketSubscription = null;
      }
    });

    _log.info('Creating new online game');

    await readyStream.first;

    await Result.release(
      lobbyRepo.createSeek(
        seek,
        sri: socket.sri,
      ),
    );

    return completer.future;
  }

  Future<void> newCorrespondenceGame(GameSeek seek) async {
    final lobbyRepo = ref.read(lobbyRepositoryProvider);

    _log.info('Creating new correspondence game');

    await Result.release(
      lobbyRepo.createSeek(
        seek,
        sri: ref.read(authSocketProvider).sri,
      ),
    );
  }

  /// Cancel the current game creation.
  void cancel() {
    _socketSubscription?.cancel();
    _socketSubscription = null;
    // we need to invalidate lobbyRepositoryProvider to cancel the seek
    // (it closes client connection)
    // cf: https://lichess.org/api#tag/Board/operation/apiBoardSeek
    ref.invalidate(lobbyRepositoryProvider);
  }
}
