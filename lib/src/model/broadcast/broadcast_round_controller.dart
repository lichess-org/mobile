import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

part 'broadcast_round_controller.freezed.dart';
part 'broadcast_round_controller.g.dart';

@riverpod
class BroadcastRoundController extends _$BroadcastRoundController {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  StreamSubscription<SocketEvent>? _subscription;
  StreamSubscription<void>? _socketOpenSubscription;
  AppLifecycleListener? _appLifecycleListener;

  late SocketClient _socketClient;

  final _syncRoundDebouncer = Debouncer(const Duration(milliseconds: 150));
  final _evalRequestDebouncer = Debouncer(const Duration(milliseconds: 200));

  Object? _key = Object();

  @override
  Future<BroadcastRoundState> build(BroadcastRoundId broadcastRoundId) async {
    ref.onDispose(() {
      _key = null;
      _subscription?.cancel();
      _socketOpenSubscription?.cancel();
      _appLifecycleListener?.dispose();
      _syncRoundDebouncer.cancel();
      _evalRequestDebouncer.cancel();
    });

    _socketClient = ref
        .watch(socketPoolProvider)
        .open(BroadcastRoundController.broadcastSocketUri(broadcastRoundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    await _socketClient.firstConnection;

    _socketOpenSubscription = _socketClient.connectedStream.listen((_) {
      if (state.valueOrNull?.round.status == RoundStatus.live) {
        _syncRoundDebouncer(() {
          _syncRound();
        });
      }
    });

    _appLifecycleListener = AppLifecycleListener(
      onResume: () {
        if (state.valueOrNull?.round.status == RoundStatus.live) {
          _syncRoundDebouncer(() {
            _syncRound();
          });
        }
      },
    );

    final round = await ref.withClient(
      (client) => BroadcastRepository(client).getRound(broadcastRoundId),
    );

    return BroadcastRoundState(round: round.round, games: round.games, observedGames: ISet());
  }

  Future<void> _syncRound() async {
    if (state.hasValue == false) return;

    final key = _key;
    final round = await ref.withClient(
      (client) => BroadcastRepository(client).getRound(broadcastRoundId),
    );
    // check provider is still mounted
    if (key == _key) {
      state = AsyncData(
        BroadcastRoundState(
          round: round.round,
          games: round.games,
          observedGames: state.requireValue.observedGames.where(round.games.containsKey).toISet(),
        ),
      );
      _sendEvalMultiGet();
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
        _handleAddBoardEvent(event);
      // Sent when the state of games changes
      case 'chapters':
        _handleGamesChangeEvent(event);
      // Sent when clocks are updated from the broadcast
      case 'clock':
        _handleClockEvent(event);
      // Sent when new evals are received for the fens to which we subscribed
      case 'evalHitMulti':
        _handleEvalMultiHit(event);
    }
  }

  void _handleAddNodeEvent(SocketEvent event) {
    // The path of the last and current move of the broadcasted game
    // Its value is "!" if the path is identical to one of the node that was received
    final currentPath = pick(event.data, 'relayPath').asUciPathOrNull();

    // We check that the event we received is for the last move of the game
    if (currentPath?.value != '!') return;

    final broadcastGameId = pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();
    final fen = pick(event.data, 'n', 'fen').asStringOrThrow();

    final playingSide = Setup.parseFen(fen).turn;

    state = AsyncData(
      state.requireValue.copyWith(
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
            cp: null,
            mate: null,
          ),
        ),
      ),
    );

    if (state.requireValue.observedGames.contains(broadcastGameId)) {
      _sendEvalMultiGet();
    }
  }

  void _handleAddBoardEvent(SocketEvent event) {
    _syncRound();
  }

  void _handleGamesChangeEvent(SocketEvent event) {
    final games = IMap.fromEntries(pick(event.data).asListOrThrow(gameFromPick));

    state = AsyncData(
      state.requireValue.copyWith(
        round: state.requireValue.round,
        games: games,
        observedGames: state.requireValue.observedGames.where(games.containsKey).toISet(),
      ),
    );

    _sendEvalMultiGet();
  }

  void _handleClockEvent(SocketEvent event) {
    final broadcastGameId = pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();
    final relayClocks = pick(event.data, 'p', 'relayClocks');

    // We check that the clocks for the broadcast game preview have been updated else we do nothing
    if (relayClocks.value == null) return;

    state = AsyncData(
      state.requireValue.copyWith(
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
      ),
    );
  }

  void _handleEvalMultiHit(SocketEvent event) {
    final multiEval = event.data as Map<String, dynamic>;

    if (multiEval.containsKey('multi')) {
      pick(event.data, 'multi').asListOrThrow(_pickFromEval);
    } else {
      pick(event.data).letOrThrow(_pickFromEval);
    }
  }

  void _pickFromEval(RequiredPick eval) {
    final fen = eval('fen').asStringOrThrow();

    final cp = eval('cp').asIntOrNull();
    final mate = eval('mate').asIntOrNull();
    assert(cp != null || mate != null);

    final round = state.requireValue;

    state = AsyncData(
      round.copyWith(
        games: round.games.updateAll(
          (id, game) => (game.fen == fen) ? game.copyWith(cp: cp, mate: mate) : game,
        ),
      ),
    );
  }

  void addObservedGame(BroadcastGameId gameId) {
    if (state.valueOrNull?.games.containsKey(gameId) != true) return;

    state = AsyncData(
      state.requireValue.copyWith(observedGames: state.requireValue.observedGames.add(gameId)),
    );

    _evalRequestDebouncer(_sendEvalMultiGet);
  }

  void removeObservedGame(BroadcastGameId gameId) {
    if (!state.hasValue) return;

    state = AsyncData(
      state.requireValue.copyWith(observedGames: state.requireValue.observedGames.remove(gameId)),
    );

    _evalRequestDebouncer(_sendEvalMultiGet);
  }

  void _sendEvalMultiGet() {
    final round = state.requireValue;

    _socketClient.send('evalGetMulti', {
      'fens': [for (final id in round.observedGames) round.games[id]!.fen],
    });
  }
}

@freezed
sealed class BroadcastRoundState with _$BroadcastRoundState {
  const factory BroadcastRoundState({
    /// The broadcast round
    required BroadcastRound round,

    /// The games of the round
    required IMap<BroadcastGameId, BroadcastGame> games,

    /// The games that are visible on the screen
    ///
    /// The controller has the responsibility to maintain [observedGames] as a subset of [games].
    required ISet<BroadcastGameId> observedGames,
  }) = _BroadcastRoundState;
}
