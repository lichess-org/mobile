import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_socket.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';

part 'game_ctrl.freezed.dart';
part 'game_ctrl.g.dart';

@riverpod
class GameCtrl extends _$GameCtrl {
  StreamSubscription<SocketEvent>? _socketSubscription;
  final _logger = Logger('GameCtrl');

  /// Last socket version received
  int _socketEventVersion = 0;

  @override
  Future<GameCtrlState> build(GameFullId gameFullId) {
    final socket = ref.watch(authSocketProvider);
    final stream = socket.connect();

    final state = stream.firstWhere((e) => e.topic == 'full').then((event) {
      final data = event.data as Map<String, dynamic>;
      final game = PlayableGame.fromWebSocketJson(data);

      _socketSubscription = stream.listen(_handleSocketEvent);

      _socketEventVersion = data['socket'] as int;

      return GameCtrlState(
        game: game,
        stepCursor: game.steps.length - 1,
      );
    });

    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    socket.switchRoute(Uri(path: '/play/$gameFullId/v6'));

    return state;
  }

  void onUserMove(Move move) {
    final curState = state.requireValue;

    final (newPos, newSan) = curState.game.lastPosition.playToSan(move);
    final newStep = GameStep(
      ply: curState.game.lastPly + 1,
      position: newPos,
      san: newSan,
      uci: move.uci,
      diff: MaterialDiff.fromBoard(newPos.board),
    );

    state = AsyncValue.data(
      curState.copyWith(
        game: curState.game.copyWith(
          steps: curState.game.steps.add(newStep),
        ),
        stepCursor: curState.stepCursor + 1,
      ),
    );

    sendMove(move);
  }

  void sendMove(Move move) {
    final socket = ref.read(authSocketProvider);
    socket.send('move', {
      'u': move.uci,
    });
  }

  /// Resync full game data with the server
  void _resyncGameData() {
    _logger.info('Resyncing game data');
    final socket = ref.read(authSocketProvider);
    socket.switchRoute(Uri(path: '/play/$gameFullId/v6'));
  }

  void _handleSocketEvent(SocketEvent event) {
    print('game socket event: $event');

    if (event.version != null) {
      if (event.version! <= _socketEventVersion) {
        _logger.fine('Already handled event ${event.version}');
        return;
      }
      if (event.version! > _socketEventVersion + 1) {
        _logger.warning(
          'Event gap detected from $_socketEventVersion to ${event.version}',
        );
        _resyncGameData();
      }
      _socketEventVersion = event.version!;
    }

    switch (event.topic) {
      /// Server asking for a reload
      case 'reload':
      case 'resync':
        _resyncGameData();

      /// Full game data, received after switching route to /play/<gameId>
      case 'full':
        final data = event.data as Map<String, dynamic>;
        final game = PlayableGame.fromWebSocketJson(data);

        _socketEventVersion = data['socket'] as int;

        state = AsyncValue.data(
          GameCtrlState(
            game: game,
            stepCursor: game.steps.length - 1,
          ),
        );

      /// Move event, received after sending a move or receiving a move from the opponent
      case 'move':
        final curState = state.requireValue;
        final data =
            SocketMoveEvent.fromJson(event.data as Map<String, dynamic>);

        GameCtrlState newState = curState;

        /// Opponent move
        if (data.ply == curState.game.lastPly + 1) {
          final lastPos = curState.game.lastPosition;
          final newPos = lastPos.playUnchecked(Move.fromUci(data.uci)!);
          final newStep = GameStep(
            ply: data.ply,
            san: data.san,
            uci: data.uci,
            position: newPos,
            diff: MaterialDiff.fromBoard(newPos.board),
          );

          newState = newState.copyWith(
            game: newState.game.copyWith(
              steps: newState.game.steps.add(newStep),
            ),
          );

          if (!curState.isReplaying) {
            newState = newState.copyWith(
              stepCursor: curState.stepCursor + 1,
            );
          }
        }

        // TODO handle lag
        if (curState.game.clock != null && data.clock != null) {
          newState = newState.copyWith.game.clock!(
            white: data.clock!.white,
            black: data.clock!.black,
          );
        }

        if (data.status != null) {
          newState = newState.copyWith.game.data(
            status: data.status!,
          );
        }

        state = AsyncValue.data(newState);

      default:
        break;
    }
  }
}

@freezed
class GameCtrlState with _$GameCtrlState {
  const GameCtrlState._();

  const factory GameCtrlState({
    required PlayableGame game,
    required int stepCursor,
  }) = _GameCtrlState;

  bool get isReplaying => stepCursor < game.steps.length - 1;
}
