import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
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

  (http.Client, StreamSubscription<SocketEvent>)? _pendingGameConnection;

  Future<GameFullId> newLobbyGame(GameSeek seek) async {
    if (_pendingGameConnection != null) {
      throw StateError('Already creating a game.');
    }

    final socket = ref.read(socketServiceProvider);
    final (stream, readyStream) = socket.connect(Uri(path: '/lobby/socket/v5'));

    // ensure the pending game connection is closed in any case
    final completer = Completer<GameFullId>()..future.whenComplete(_close);

    _pendingGameConnection = (
      ref.read(lichessClientFactoryProvider)(),
      stream.listen((event) {
        if (event.topic == 'redirect') {
          final data = event.data as Map<String, dynamic>;
          completer.complete(pick(data['id']).asGameFullIdOrThrow());
        }
      })
    );

    final lobbyRepo = LobbyRepository(_pendingGameConnection!.$1);

    _log.info('Creating new online game');

    // wait for the socket to be ready
    await readyStream.first;

    GameSeek actualSeek = seek;

    // if we have a rating delta, we need to get the account to get the rating
    // and set the rating range
    if (seek.ratingDelta != null) {
      final account = await ref.read(accountProvider.future);
      if (account != null) {
        actualSeek = actualSeek.withRatingRangeOf(account);
      }
    }

    try {
      await lobbyRepo.createSeek(actualSeek, sri: socket.sri);
    } catch (e) {
      _log.warning('Failed to create seek', e);
      // if the completer is not yet completed, complete it with an error
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  Future<void> newCorrespondenceGame(GameSeek seek) async {
    _log.info('Creating new correspondence game');

    await ref.withClient(
      (client) => LobbyRepository(client).createSeek(
        seek,
        sri: ref.read(socketServiceProvider).sri,
      ),
    );
  }

  /// Cancel the current game creation.
  void cancel() {
    _log.info('Cancelling game creation');
    _close();
  }

  void _close() {
    // close the http client
    _pendingGameConnection?.$1.close();
    // cancel the socket subscription
    _pendingGameConnection?.$2.cancel();
    _pendingGameConnection = null;
  }
}
