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

part 'broadcast_controller.g.dart';

@riverpod
class BroadcastController extends _$BroadcastController {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  StreamSubscription<SocketEvent>? _subscription;

  late SocketClient _socketClient;

  @override
  Future<BroadcastMapGames> build(BroadcastRoundId broadcastRoundId) async {
    _socketClient = ref
        .read(socketPoolProvider)
        .open(BroadcastController.broadcastSocketUri(broadcastRoundId));

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
      // Sent when a move is played in a game
      case 'chapters':
        _handleChaptersEvent(event);
      // Sent when a game ended
      case 'addNode':
        _handleAddNodeEvent(event);
      case 'clock':
        _handleClockEvent(event);
    }
  }

  void _handleAddNodeEvent(SocketEvent event) {
    final relayPath = pick(event.data, 'p', 'relayPath').asUciPathOrThrow();
    final path = pick(event.data, 'd', 'p', 'path').asUciPathOrThrow();
    final id = pick(event.data, 'd', 'n', 'id').asUciCharPairOrThrow();

    // We check that the event we received is for the last move of the game
    if (relayPath != path + id) return;

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
