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
  Timer? _opponentLeftCountdownTimer;

  /// Last socket version received
  int _socketEventVersion = 0;

  @override
  Future<GameCtrlState> build(GameFullId gameFullId) {
    final socket = ref.watch(authSocketProvider);
    final stream = socket.connect();

    final state = stream.firstWhere((e) => e.topic == 'full').then((event) {
      final fullEvent =
          GameFullEvent.fromJson(event.data as Map<String, dynamic>);

      _socketSubscription = stream.listen(_handleSocketEvent);

      _socketEventVersion = fullEvent.socketEventVersion;

      return GameCtrlState(
        game: fullEvent.game,
        stepCursor: fullEvent.game.steps.length - 1,
      );
    });

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _opponentLeftCountdownTimer?.cancel();
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

  void forceResign() {
    _socket.send('resign-force', null);
  }

  void forceDraw() {
    _socket.send('draw-force', null);
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
      // Server asking for a reload
      case 'reload':
      case 'resync':
        _resyncGameData();

      // Full game data, received after switching route to /play/<gameId>
      case 'full':
        final fullEvent =
            GameFullEvent.fromJson(event.data as Map<String, dynamic>);

        _socketEventVersion = fullEvent.socketEventVersion;

        state = AsyncValue.data(
          GameCtrlState(
            game: fullEvent.game,
            stepCursor: fullEvent.game.steps.length - 1,
          ),
        );

      // Move event, received after sending a move or receiving a move from the opponent
      case 'move':
        final curState = state.requireValue;
        final data = MoveEvent.fromJson(event.data as Map<String, dynamic>);

        GameCtrlState newState = curState.copyWith(
          game: curState.game.copyWith(
            isThreefoldRepetition: data.threefold,
            winner: data.winner,
          ),
          // whiteOfferingDraw: data.whiteOfferingDraw,
          // blackOfferingDraw: data.blackOfferingDraw,
        );

        // add opponent move
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
            game: newState.game.copyWith(
              steps: newState.game.steps.add(newStep),
            ),
          );

          if (!curState.isReplaying) {
            newState = newState.copyWith(
              stepCursor: newState.stepCursor + 1,
            );

            // TODO adjust with animation duration pref
            Timer(const Duration(milliseconds: 50), () {
              _playMoveFeedback(sanMove);
            });
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
          newState = newState.copyWith.game(
            status: data.status!,
          );
        }

        if (newState.game.expiration != null) {
          if (newState.game.steps.length > 2) {
            newState = newState.copyWith.game(
              expiration: null,
            );
          } else {
            newState = curState.copyWith.game(
              expiration: (
                idle: curState.game.expiration!.idle,
                timeToMove: curState.game.expiration!.timeToMove,
                movedAt: DateTime.now(),
              ),
            );
          }
        }

        state = AsyncValue.data(newState);

      // End game event
      case 'endData':
        final endData =
            GameEndEvent.fromJson(event.data as Map<String, dynamic>);
        final curState = state.requireValue;
        GameCtrlState newState = curState.copyWith(
          game: curState.game.copyWith(
            status: endData.status,
            winner: endData.winner,
            boosted: endData.boosted,
            white: curState.game.white.copyWith(
              ratingDiff: endData.ratingDiff?.white,
            ),
            black: curState.game.black.copyWith(
              ratingDiff: endData.ratingDiff?.black,
            ),
          ),
        );

        if (endData.clock != null) {
          newState = newState.copyWith.game.clock!(
            white: endData.clock!.white,
            black: endData.clock!.black,
          );
        }

        if (curState.game.lastPosition.fullmoves > 1) {
          ref.read(soundServiceProvider).play(Sound.dong);
        }

        state = AsyncValue.data(newState);

      // Crowd event, sent when a player quits or joins the game
      case 'crowd':
        final data = event.data as Map<String, dynamic>;
        final whiteOnGame = data['white'] as bool?;
        final blackOnGame = data['black'] as bool?;
        final curState = state.requireValue;
        final opponent = curState.game.youAre?.opposite;
        GameCtrlState newState = curState;
        if (whiteOnGame != null) {
          newState = newState.copyWith.game(
            white: newState.game.white.setOnGame(whiteOnGame),
          );
          if (opponent == Side.white && whiteOnGame == true) {
            _opponentLeftCountdownTimer?.cancel();
            newState = newState.copyWith(
              opponentLeftCountdown: null,
            );
          }
        }
        if (blackOnGame != null) {
          newState = newState.copyWith.game(
            black: newState.game.black.setOnGame(blackOnGame),
          );
          if (opponent == Side.black && blackOnGame == true) {
            _opponentLeftCountdownTimer?.cancel();
            newState = newState.copyWith(
              opponentLeftCountdown: null,
            );
          }
        }
        state = AsyncValue.data(newState);

      // Gone event, sent when the opponent has quit the game for long enough
      // than we can claim victory
      case 'gone':
        final isGone = event.data as bool;
        _opponentLeftCountdownTimer?.cancel();
        GameCtrlState newState = state.requireValue;
        final youAre = newState.game.youAre;
        newState = newState.copyWith.game(
          white: youAre == Side.white
              ? newState.game.white
              : newState.game.white.setGone(isGone),
          black: youAre == Side.black
              ? newState.game.black
              : newState.game.black.setGone(isGone),
        );
        state = AsyncValue.data(newState);

      // Event sent when the opponent has quit the game, to display a countdown
      // before claiming victory is possible
      case 'goneIn':
        final timeLeft = Duration(seconds: event.data as int);
        state = AsyncValue.data(
          state.requireValue.copyWith(
            opponentLeftCountdown: timeLeft,
          ),
        );
        _opponentLeftCountdownTimer?.cancel();
        _opponentLeftCountdownTimer = Timer.periodic(
          const Duration(seconds: 1),
          (_) {
            final curState = state.requireValue;
            final opponentLeftCountdown = curState.opponentLeftCountdown;
            if (opponentLeftCountdown == null) {
              _opponentLeftCountdownTimer?.cancel();
            } else if (!curState.canShowClaimWinCountdown) {
              _opponentLeftCountdownTimer?.cancel();
              state = AsyncValue.data(
                curState.copyWith(
                  opponentLeftCountdown: null,
                ),
              );
            } else {
              final newTime =
                  opponentLeftCountdown - const Duration(seconds: 1);
              if (newTime <= Duration.zero) {
                _opponentLeftCountdownTimer?.cancel();
              }
              state = AsyncValue.data(
                curState.copyWith(opponentLeftCountdown: newTime),
              );
            }
          },
        );

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
    bool? playerOfferingDraw,
    bool? opponentOfferingDraw,
    int? lastDrawOfferAtPly,
    Duration? opponentLeftCountdown,
  }) = _GameCtrlState;

  bool get isReplaying => stepCursor < game.steps.length - 1;
  bool get canGoForward => stepCursor < game.steps.length - 1;
  bool get canGoBackward => stepCursor > 0;

  bool get canGetNewOpponent =>
      !game.playable &&
      (game.meta.source == GameSource.lobby ||
          game.meta.source == GameSource.pool);

  bool get canOfferDraw =>
      game.drawable &&
      (playerOfferingDraw == null || playerOfferingDraw == false) &&
      (lastDrawOfferAtPly ?? -99) < game.lastPly - 20;

  bool get canShowClaimWinCountdown =>
      !game.isPlayerTurn &&
      game.resignable &&
      (game.meta.rules == null ||
          !game.meta.rules!.contains(GameRule.noClaimWin));

  /// Time left to move for the active player if an expiration is set
  Duration? get timeToMove {
    if (!game.playable || game.expiration == null) {
      return null;
    }
    final timeLeft = game.expiration!.movedAt.difference(DateTime.now()) +
        game.expiration!.timeToMove;

    if (timeLeft.isNegative) {
      return Duration.zero;
    }
    return timeLeft;
  }

  Side? get activeClockSide {
    if (game.clock == null) {
      return null;
    }

    if (game.status == GameStatus.started) {
      final pos = game.lastPosition;
      if (pos.fullmoves > 1) {
        return pos.turn;
      }
    }

    return null;
  }
}
