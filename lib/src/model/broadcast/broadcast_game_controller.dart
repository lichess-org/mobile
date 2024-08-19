import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_game_controller.g.dart';

@riverpod
class BroadcastGameController extends _$BroadcastGameController {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  StreamSubscription<SocketEvent>? _subscription;

  late SocketClient _socketClient;

  @override
  Future<String> build({
    required BroadcastRoundId broadcastRoundId,
    required BroadcastGameId broadcastGameId,
  }) async {
    _socketClient = ref
        .watch(socketPoolProvider)
        .open(BroadcastRoundController.broadcastSocketUri(broadcastRoundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final pgn = await ref.watch(
      broadcastGameProvider(
        roundId: broadcastRoundId,
        gameId: broadcastGameId,
      ).future,
    );

    return pgn;
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) return;

    switch (event.topic) {
      // Sent when a node is recevied from the broadcast
      case 'addNode':
        _handleAddNodeEvent(event);
      // Sent when a pgn tag changes
      case 'setTags':
        _handleSetTagsEvent(event);
    }
  }

  void _handleAddNodeEvent(SocketEvent event) {
    final gameId =
        pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();

    // We check that the event we received is for the game we are currently watching
    if (gameId != broadcastGameId) return;

    // The path of the last and current move of the broadcasted game
    // Its value is "!" if the path is identical to one of the node that was received
    final currentPath = pick(event.data, 'relayPath').asUciPathOrThrow();

    // We check that the event we received is for the last move of the game
    if (currentPath.value != '!') return;

    // The path for the node that was received
    final path = pick(event.data, 'p', 'path').asUciPathOrThrow();
    final nodeId = pick(event.data, 'n', 'id').asUciCharPairOrThrow();

    print(state.requireValue);

    print(path + nodeId);

    final newPgn = (Root.fromPgnGame(PgnGame.parsePgn(state.requireValue))
          ..promoteAt(path + nodeId, toMainline: true))
        .makePgn();

    print(newPgn);

    state = AsyncData(newPgn);
  }

  void _handleSetTagsEvent(SocketEvent event) {
    final gameId = pick(event.data, 'chapterId').asBroadcastGameIdOrThrow();

    // We check that the event we received is for the game we are currently watching
    if (gameId != broadcastGameId) return;

    final headers = pick(event.data, 'tags').asMapOrThrow<String, String>();

    final pgnGame = PgnGame.parsePgn(state.requireValue);

    final newPgnGame = PgnGame(
      headers: headers,
      moves: pgnGame.moves,
      comments: pgnGame.comments,
    );

    state = AsyncData(newPgnGame.makePgn());
  }
}
