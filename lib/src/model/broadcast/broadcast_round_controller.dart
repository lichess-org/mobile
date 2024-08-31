import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
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
        .watch(socketPoolProvider)
        .open(BroadcastRoundController.broadcastSocketUri(broadcastRoundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final games =
        await ref.watch(broadcastRoundProvider(broadcastRoundId).future);

    return games;
  }

  Future<void> setPgn(BroadcastGameId gameId) async {
    final pgn = await ref.watch(
      broadcastGameProvider(
        roundId: broadcastRoundId,
        gameId: gameId,
      ).future,
    );
    state = AsyncData(
      state.requireValue.update(
        gameId,
        (broadcastGame) => broadcastGame.copyWith(
          pgn: pgn,
        ),
      ),
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) return;

    switch (event.topic) {
      // Sent when a node is recevied from the broadcast
      case 'addNode':
        _handleAddNodeEvent(event);
      // Sent when the state of games changes
      case 'chapters':
        _handleChaptersEvent(event);
      // Sent when clocks are updated from the broadcast
      case 'clock':
        _handleClockEvent(event);
      // Sent when a pgn tag changes
      case 'setTags':
        _handleSetTagsEvent(event);
    }
  }

  void _handleAddNodeEvent(SocketEvent event) {
    // The path of the last and current move of the broadcasted game
    // Its value is "!" if the path is identical to one of the node that was received
    final currentPath = pick(event.data, 'relayPath').asUciPathOrThrow();

    // We check that the event we received is for the last move of the game
    if (currentPath.value != '!') return;

    final broadcastGameId =
        pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();

    final fen = pick(event.data, 'n', 'fen').asStringOrThrow();

    final playingSide = Setup.parseFen(fen).turn.opposite;

    state = AsyncData(
      state.requireValue.update(
        broadcastGameId,
        (broadcastGame) => broadcastGame.copyWith(
          players: IMap(
            {
              playingSide: broadcastGame.players[playingSide]!.copyWith(
                clock: pick(event.data, 'n', 'clock')
                    .asDurationFromCentiSecondsOrNull(),
              ),
              playingSide.opposite:
                  broadcastGame.players[playingSide.opposite]!,
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
        (broadcastsGame) => broadcastsGame.copyWith(
          players: IMap(
            {
              Side.white: broadcastsGame.players[Side.white]!.copyWith(
                clock: whiteClock,
              ),
              Side.black: broadcastsGame.players[Side.black]!.copyWith(
                clock: blackClock,
              ),
            },
          ),
        ),
      ),
    );
  }

  void _handleSetTagsEvent(SocketEvent event) {
    final gameId = pick(event.data, 'chapterId').asBroadcastGameIdOrThrow();

    if (state.requireValue[gameId]?.pgn == null) return;

    final headers = pick(event.data, 'tags').asMapOrThrow<String, String>();

    final pgnGame = PgnGame.parsePgn(state.requireValue[gameId]!.pgn!);

    final newPgnGame = PgnGame(
      headers: headers,
      moves: pgnGame.moves,
      comments: pgnGame.comments,
    );

    state = AsyncData(
      state.requireValue.update(
        gameId,
        (broadcastsGame) => broadcastsGame.copyWith(
          pgn: newPgnGame.makePgn(),
        ),
      ),
    );
  }
}


// void _handleAddNodeEvent(SocketEvent event) {
//   final gameId =
//       pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();

//   // We check that the event we received is for the game we are currently watching
//   if (gameId != broadcastGameId) return;

//   // The path of the last and current move of the broadcasted game
//   // Its value is "!" if the path is identical to one of the node that was received
//   final currentPath = pick(event.data, 'relayPath').asUciPathOrThrow();

//   // We check that the event we received is for the last move of the game
//   if (currentPath.value != '!') return;

//   // The path for the node that was received
//   final path = pick(event.data, 'p', 'path').asUciPathOrThrow();
//   final nodeId = pick(event.data, 'n', 'id').asUciCharPairOrThrow();

//   final newPgn = (Root.fromPgnGame(PgnGame.parsePgn(state.requireValue))
//         ..promoteAt(path + nodeId, toMainline: true))
//       .makePgn();

//   state = AsyncData(newPgn);
// }
