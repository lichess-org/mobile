import 'dart:async';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/game_socket.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';

part 'game_ctrl.freezed.dart';
part 'game_ctrl.g.dart';

@riverpod
class GameCtrl extends _$GameCtrl {
  final _logger = Logger('GameCtrl');
  StreamSubscription<SocketEvent>? _socketSubscription;

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
      ref.invalidate(authSocketProvider);
    });

    socket.switchRoute(Uri(path: '/play/$gameFullId/v6'));

    return state;
  }

  void onUserMove(Move move) {
    final curState = state.requireValue;

    final (newPos, newSan) = curState.game.lastPosition.playToSan(move);
    final sanMove = SanMove(newSan, move);
    final newStep = GameStep(
      ply: curState.game.lastPly + 1,
      position: newPos,
      sanMove: sanMove,
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

    _sendMove(move);

    _playMoveFeedback(sanMove);
  }

  void cursorAt(int cursor) {
    if (state.hasValue) {
      state = AsyncValue.data(state.requireValue.copyWith(stepCursor: cursor));
      final san = state.requireValue.game.stepAt(cursor).sanMove?.san;
      if (san != null) {
        _playReplayMoveSound(san);
        HapticFeedback.lightImpact();
      }
    }
  }

  void cursorForward({bool hapticFeedback = true}) {
    if (state.hasValue) {
      final curState = state.requireValue;
      final newCursor = curState.stepCursor + 1;
      state = AsyncValue.data(curState.copyWith(stepCursor: newCursor));
      final san = curState.game.stepAt(newCursor).sanMove?.san;
      if (san != null) {
        _playReplayMoveSound(san);
        if (hapticFeedback) HapticFeedback.lightImpact();
      }
    }
  }

  void cursorBackward() {
    if (state.hasValue) {
      final curState = state.requireValue;
      final newCursor = curState.stepCursor - 1;
      state = AsyncValue.data(curState.copyWith(stepCursor: newCursor));
      final san = curState.game.stepAt(newCursor).sanMove?.san;
      if (san != null) {
        _playReplayMoveSound(san);
      }
    }
  }

  void abortGame() {
    _socket.send('abort', null);
  }

  void resignGame() {
    _socket.send('resign', null);
  }

  // TODO: blur, lag
  void _sendMove(Move move) {
    _socket.send(
      'move',
      {
        'u': move.uci,
      },
      ackable: true,
    );
  }

  /// Move feedback while playing
  void _playMoveFeedback(SanMove sanMove) {
    final isCheck = sanMove.san.contains('+');
    if (sanMove.san.contains('x')) {
      ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
    } else {
      ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
    }
  }

  /// Play the sound when replaying moves
  void _playReplayMoveSound(String san) {
    final soundService = ref.read(soundServiceProvider);
    if (san.contains('x')) {
      soundService.stopCurrent();
      soundService.play(Sound.capture);
    } else {
      soundService.stopCurrent();
      soundService.play(Sound.move);
    }
  }

  /// Resync full game data with the server
  void _resyncGameData() {
    _logger.info('Resyncing game data');
    _socket.switchRoute(Uri(path: '/play/$gameFullId/v6'));
  }

  void _handleSocketEvent(SocketEvent event) {
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
          final move = Move.fromUci(data.uci)!;
          final sanMove = SanMove(data.san, move);
          final newPos = lastPos.playUnchecked(move);
          final newStep = GameStep(
            ply: data.ply,
            sanMove: sanMove,
            position: newPos,
            diff: MaterialDiff.fromBoard(newPos.board),
          );

          newState = newState.copyWith(
            isThreefoldRepetition: data.threefold,
            winner: data.winner,
            whiteOfferingDraw: data.whiteOfferingDraw,
            blackOfferingDraw: data.blackOfferingDraw,
            game: newState.game.copyWith(
              steps: newState.game.steps.add(newStep),
            ),
          );

          if (!curState.isReplaying) {
            newState = newState.copyWith(
              stepCursor: newState.stepCursor + 1,
            );

            _playMoveFeedback(sanMove);
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

      case 'endData':
        final endData =
            GameEndEvent.fromJson(event.data as Map<String, dynamic>);
        final curState = state.requireValue;
        GameCtrlState newState = curState.copyWith(
          winner: endData.winner,
          game: curState.game.copyWith(
            data: curState.game.data.copyWith(
              status: endData.status,
            ),
          ),
          ratingDiff: endData.ratingDiff,
        );

        if (endData.clock != null) {
          newState = newState.copyWith.game.clock!(
            white: endData.clock!.white,
            black: endData.clock!.black,
          );
        }

        state = AsyncValue.data(newState);

      default:
        break;
    }
  }

  AuthSocket get _socket => ref.read(authSocketProvider);
}

@freezed
class GameCtrlState with _$GameCtrlState {
  const GameCtrlState._();

  const factory GameCtrlState({
    required PlayableGame game,
    required int stepCursor,
    bool? isThreefoldRepetition,
    bool? whiteOfferingDraw,
    bool? blackOfferingDraw,
    Side? winner,
    ({double white, double black})? ratingDiff,
  }) = _GameCtrlState;

  bool get playable => game.data.status.value < GameStatus.aborted.value;
  bool get abortable => playable && game.lastPosition.fullmoves <= 1;
  bool get resignable => playable && !abortable;

  bool get isReplaying => stepCursor < game.steps.length - 1;

  bool get canGoForward => stepCursor < game.steps.length - 1;
  bool get canGoBackward => stepCursor > 0;

  Side? get activeClockSide {
    if (game.clock == null) {
      return null;
    }

    if (game.data.status == GameStatus.started) {
      final pos = game.lastPosition;
      if (pos.fullmoves > 1) {
        return pos.turn;
      }
    }

    return null;
  }
}
