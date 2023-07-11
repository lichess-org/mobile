import 'dart:async';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:logging/logging.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';

part 'game_ctrl.freezed.dart';
part 'game_ctrl.g.dart';

@riverpod
class GameCtrl extends _$GameCtrl {
  final _logger = Logger('GameCtrl');
  StreamSubscription<SocketEvent>? _socketSubscription;
  Timer? _opponentLeftCountdownTimer;

  final _onFlagThrottler = Throttler(const Duration(milliseconds: 500));

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

  void onFlag() {
    _onFlagThrottler(() {
      if (state.hasValue) {
        _socket.send('flag', state.requireValue.game.youAre?.name);
      }
    });
  }

  void moreTime() {
    _socket.send('moretime', null);
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

  void claimDraw() {
    _socket.send('draw-claim', null);
  }

  void offerOrAcceptDraw() {
    _socket.send('draw-yes', null);
  }

  void cancelOrDeclineDraw() {
    _socket.send('draw-no', null);
  }

  void offerOrAcceptTakeback() {
    _socket.send('takeback-yes', null);
  }

  void cancelOrDeclineTakeback() {
    _socket.send('takeback-no', null);
  }

  void proposeOrAcceptRematch() {
    _socket.send('rematch-yes', null);
  }

  void declineRematch() {
    _socket.send('rematch-no', null);
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
      soundService.play(Sound.capture);
    } else {
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

    _handleSocketTopic(event);
  }

  void _handleSocketTopic(SocketEvent event) {
    if (!state.hasValue) {
      assert(false, 'received a game SocketEvent while GameCtrlState is null');
      return;
    }

    switch (event.topic) {
      // Server asking for a resync
      case 'resync':
        _resyncGameData();

      // Server asking for a reload, or in some cases the reload itself contains
      // another topic message
      case 'reload':
        if (event.data is Map<String, dynamic>) {
          final data = event.data as Map<String, dynamic>;
          if (data['t'] == null) {
            _resyncGameData();
            return;
          }
          final reloadEvent = SocketEvent(
            topic: data['t'] as String,
            data: data['d'],
          );
          _handleSocketTopic(reloadEvent);
        } else {
          _resyncGameData();
        }

      // Full game data, received after switching route to /play/<gameId>
      case 'full':
        final fullEvent =
            GameFullEvent.fromJson(event.data as Map<String, dynamic>);

        if (fullEvent.socketEventVersion < _socketEventVersion) {
          return;
        }
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
            status: data.status ?? curState.game.status,
          ),
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
        if (newState.game.clock != null && data.clock != null) {
          newState = newState.copyWith.game.clock!(
            white: data.clock!.white,
            black: data.clock!.black,
          );
        }

        if (newState.game.expiration != null) {
          if (newState.game.steps.length > 2) {
            newState = newState.copyWith.game(
              expiration: null,
            );
          } else {
            newState = newState.copyWith.game(
              expiration: (
                idle: newState.game.expiration!.idle,
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

      case 'clockInc':
        final data = event.data as Map<String, dynamic>;
        final side = pick(data['color']).asSideOrNull();
        final newClock = pick(data['total'])
            .letOrNull((it) => Duration(milliseconds: it.asIntOrThrow() * 10));
        final curState = state.requireValue;
        if (side != null && newClock != null) {
          final newState = side == Side.white
              ? curState.copyWith.game.clock!(
                  white: newClock,
                )
              : curState.copyWith.game.clock!(
                  black: newClock,
                );
          state = AsyncValue.data(newState);
        }

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
                state = AsyncValue.data(
                  curState.copyWith(opponentLeftCountdown: null),
                );
              }
              state = AsyncValue.data(
                curState.copyWith(opponentLeftCountdown: newTime),
              );
            }
          },
        );

      // Event sent when a player adds or cancels a draw offer
      case 'drawOffer':
        final side = pick(event.data).asSideOrNull();
        final curState = state.requireValue;
        state = AsyncValue.data(
          curState.copyWith(
            lastDrawOfferAtPly: side != null && side == curState.game.youAre
                ? curState.game.lastPly
                : null,
            game: curState.game.copyWith(
              white: curState.game.white.copyWith(
                offeringDraw: side == null ? null : side == Side.white,
              ),
              black: curState.game.black.copyWith(
                offeringDraw: side == null ? null : side == Side.black,
              ),
            ),
          ),
        );

      // Event sent when a player adds or cancels a takeback offer
      case 'takebackOffers':
        final data = event.data as Map<String, dynamic>;
        final white = pick(data['white']).asBoolOrNull();
        final black = pick(data['black']).asBoolOrNull();
        final curState = state.requireValue;
        state = AsyncValue.data(
          curState.copyWith(
            game: curState.game.copyWith(
              white: curState.game.white.copyWith(
                proposingTakeback: white ?? false,
              ),
              black: curState.game.black.copyWith(
                proposingTakeback: black ?? false,
              ),
            ),
          ),
        );

      // Event sent when a player adds or cancels a rematch offer
      case 'rematchOffer':
        final side = pick(event.data).asSideOrNull();
        final curState = state.requireValue;
        state = AsyncValue.data(
          curState.copyWith(
            game: curState.game.copyWith(
              white: curState.game.white.copyWith(
                offeringRematch: side == null ? null : side == Side.white,
              ),
              black: curState.game.black.copyWith(
                offeringRematch: side == null ? null : side == Side.black,
              ),
            ),
          ),
        );

      // Event sent when a rematch is taken. Not used for now, except to prevent
      // sending another rematch offer, which should not happen
      case 'rematchTaken':
        final nextId = pick(event.data).asGameIdOrThrow();
        state = AsyncValue.data(
          state.requireValue.copyWith.game(
            rematch: nextId,
          ),
        );

      // Event sent after a rematch is taken, to redirect to the new game
      case 'redirect':
        final data = event.data as Map<String, dynamic>;
        final fullId = pick(data['id']).asGameFullIdOrThrow();
        state = AsyncValue.data(
          state.requireValue.copyWith(
            redirectGameId: fullId,
          ),
        );
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
    int? lastDrawOfferAtPly,
    Duration? opponentLeftCountdown,

    /// Game full id used to redirect to the new game of the rematch
    GameFullId? redirectGameId,
  }) = _GameCtrlState;

  bool get isReplaying => stepCursor < game.steps.length - 1;
  bool get canGoForward => stepCursor < game.steps.length - 1;
  bool get canGoBackward => stepCursor > 0;

  bool get canGetNewOpponent =>
      !game.playable &&
      (game.meta.source == GameSource.lobby ||
          game.meta.source == GameSource.pool);

  bool get canOfferDraw =>
      game.drawable && (lastDrawOfferAtPly ?? -99) < game.lastPly - 20;

  bool get canShowClaimWinCountdown =>
      !game.isPlayerTurn &&
      game.resignable &&
      (game.meta.rules == null ||
          !game.meta.rules!.contains(GameRule.noClaimWin));

  bool get canOfferRematch =>
      game.rematch == null &&
      game.rematchable &&
      (game.finished ||
          (game.aborted &&
              (!game.meta.rated ||
                  !{GameSource.lobby, GameSource.pool}
                      .contains(game.meta.source)))) &&
      game.boosted != true;

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
