import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_round_controller.g.dart';

@riverpod
class BroadcastRoundController extends _$BroadcastRoundController {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  StreamSubscription<SocketEvent>? _subscription;

  late SocketClient _socketClient;

  @override
  Future<BroadcastRoundGames> build(BroadcastRoundId broadcastRoundId) async {
    _socketClient = ref
        .read(socketPoolProvider)
        .open(BroadcastRoundController.broadcastSocketUri(broadcastRoundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return await ref.withClient(
      (client) => BroadcastRepository(client).getRound(broadcastRoundId),
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) return;

    switch (event.topic) {
      // Sent when a node is recevied from the broadcast
      case 'addNode':
        _handleAddNodeEvent(event);
      // Sent when a game ends
      case 'chapters':
        _handleChaptersEvent(event);
      // Sent when clocks are updated from the broadcast
      case 'clock':
        _handleClockEvent(event);
    }
  }

  void _handleAddNodeEvent(SocketEvent event) {
    // The path of the last and current move of the broadcasted game
    // Its value is "!" if the path is identical to one of the node that was received
    final currentPath = pick(event.data, 'relayPath').asUciPathOrThrow();
    // The path for the node that was received
    // final path = pick(event.data, 'p', 'path').asUciPathOrThrow();
    // final nodeId = pick(event.data, 'n', 'id').asUciCharPairOrThrow();

    // We check that the event we received is for the last move of the game
    if (currentPath.value != '!') return;

    final broadcastGameId =
        pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();

    final fen = pick(event.data, 'n', 'fen').asStringOrThrow();

    final playingSide = Setup.parseFen(fen).turn.opposite;

    state = AsyncData(
      state.requireValue.update(
        broadcastGameId,
        (broadcastGameSnapshot) => broadcastGameSnapshot.copyWith(
          players: IMap(
            {
              playingSide: broadcastGameSnapshot.players[playingSide]!.copyWith(
                clock: pick(event.data, 'n', 'clock')
                    .asDurationFromCentiSecondsOrNull(),
              ),
              playingSide.opposite:
                  broadcastGameSnapshot.players[playingSide.opposite]!,
            },
          ),
          fen: fen,
          lastMove: pick(event.data, 'n', 'uci').asUciMoveOrThrow(),
          thinkTime: null,
        ),
      ),
    );
  }

  void _handleChaptersEvent(SocketEvent event) {
    final games = pick(event.data).asListOrThrow(gameFromPick);
    state = AsyncData(IMap.fromEntries(games));
  }

  void _handleClockEvent(SocketEvent event) {
    final broadcastGameId =
        pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();
    final whiteClock = pick(event.data, 'p', 'relayClocks', 0)
        .asDurationFromCentiSecondsOrNull();
    final blackClock = pick(event.data, 'p', 'relayClocks', 1)
        .asDurationFromCentiSecondsOrNull();
    state = AsyncData(
      state.requireValue.update(
        broadcastGameId,
        (broadcastGameSnapshot) => broadcastGameSnapshot.copyWith(
          players: IMap(
            {
              Side.white: broadcastGameSnapshot.players[Side.white]!.copyWith(
                clock: whiteClock,
              ),
              Side.black: broadcastGameSnapshot.players[Side.black]!.copyWith(
                clock: blackClock,
              ),
            },
          ),
        ),
      ),
    );
  }
}
