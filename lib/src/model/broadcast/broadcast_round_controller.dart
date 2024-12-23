import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_round_controller.g.dart';

@riverpod
class BroadcastRoundController extends _$BroadcastRoundController {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  StreamSubscription<SocketEvent>? _subscription;
  StreamSubscription<void>? _socketOpenSubscription;
  AppLifecycleListener? _appLifecycleListener;

  late SocketClient _socketClient;

  final _debouncer = Debouncer(const Duration(milliseconds: 150));

  Object? _key = Object();

  @override
  Future<BroadcastRoundWithGames> build(BroadcastRoundId broadcastRoundId) async {
    _socketClient = ref
        .watch(socketPoolProvider)
        .open(BroadcastRoundController.broadcastSocketUri(broadcastRoundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    await _socketClient.firstConnection;

    _socketOpenSubscription = _socketClient.connectedStream.listen((_) {
      if (state.valueOrNull?.round.status == RoundStatus.live) {
        _debouncer(() {
          _syncRound();
        });
      }
    });

    _appLifecycleListener = AppLifecycleListener(
      onResume: () {
        if (state.valueOrNull?.round.status == RoundStatus.live) {
          _debouncer(() {
            _syncRound();
          });
        }
      },
    );

    ref.onDispose(() {
      _key = null;
      _subscription?.cancel();
      _socketOpenSubscription?.cancel();
      _appLifecycleListener?.dispose();
      _debouncer.dispose();
    });

    return ref.withClient((client) => BroadcastRepository(client).getRound(broadcastRoundId));
  }

  Future<void> _syncRound() async {
    if (state.hasValue == false) return;
    final key = _key;
    final round = await ref.withClient(
      (client) => BroadcastRepository(client).getRound(broadcastRoundId),
    );
    // check provider is still mounted
    if (key == _key) {
      state = AsyncData(round);
    }
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) return;

    switch (event.topic) {
      // Sent when a node is recevied from the broadcast
      case 'addNode':
        _handleAddNodeEvent(event);
      // Sent when a new board is added
      case 'addChapter':
        _handleAddChapterEvent(event);
      // Sent when the state of games changes
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

    // We check that the event we received is for the last move of the game
    if (currentPath.value != '!') return;

    final broadcastGameId = pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();

    final fen = pick(event.data, 'n', 'fen').asStringOrThrow();

    final playingSide = Setup.parseFen(fen).turn;

    state = AsyncData((
      round: state.requireValue.round,
      games: state.requireValue.games.update(
        broadcastGameId,
        (broadcastGame) => broadcastGame.copyWith(
          players: IMap({
            playingSide: broadcastGame.players[playingSide]!,
            playingSide.opposite: broadcastGame.players[playingSide.opposite]!.copyWith(
              clock: pick(event.data, 'n', 'clock').asDurationFromCentiSecondsOrNull(),
            ),
          }),
          fen: fen,
          lastMove: pick(event.data, 'n', 'uci').asUciMoveOrThrow(),
          updatedClockAt: DateTime.now(),
        ),
      ),
    ));
  }

  void _handleAddChapterEvent(SocketEvent event) {
    ref.invalidateSelf();
  }

  void _handleChaptersEvent(SocketEvent event) {
    final games = pick(event.data).asListOrThrow(gameFromPick);
    state = AsyncData((round: state.requireValue.round, games: IMap.fromEntries(games)));
  }

  void _handleClockEvent(SocketEvent event) {
    final broadcastGameId = pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();
    final relayClocks = pick(event.data, 'p', 'relayClocks');

    // We check that the clocks for the broadcast game preview have been updated else we do nothing
    if (relayClocks.value == null) return;

    state = AsyncData((
      round: state.requireValue.round,
      games: state.requireValue.games.update(
        broadcastGameId,
        (broadcastsGame) => broadcastsGame.copyWith(
          players: IMap({
            Side.white: broadcastsGame.players[Side.white]!.copyWith(
              clock: relayClocks(0).asDurationFromCentiSecondsOrNull(),
            ),
            Side.black: broadcastsGame.players[Side.black]!.copyWith(
              clock: relayClocks(1).asDurationFromCentiSecondsOrNull(),
            ),
          }),
          updatedClockAt: DateTime.now(),
        ),
      ),
    ));
  }
}
