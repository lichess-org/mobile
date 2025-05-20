import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/account/account_service.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat_controller.dart';
import 'package:lichess_mobile/src/model/clock/chess_clock.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_controller.freezed.dart';
part 'game_controller.g.dart';

@riverpod
class GameController extends _$GameController {
  final _logger = Logger('GameController');

  StreamSubscription<SocketEvent>? _socketSubscription;

  /// Tracks moves that were played on the board, sent to the server, possibly
  /// acked, but without a move response from the server yet.
  /// After a delay, it will trigger a reload. This might fix bugs where the
  /// board is in a transient, dirty state, where clocks don't tick, eventually
  /// causing the player to flag.
  /// It will also help with lila-ws restarts.
  Timer? _transientMoveTimer;

  /// Callback to be called when a full reload is needed.
  VoidCallback? _onFullReload;

  final _onFlagThrottler = Throttler(const Duration(milliseconds: 500));

  static Uri socketUri(GameFullId gameFullId) => Uri(path: '/play/$gameFullId/v6');

  SocketPool get _socketPool => ref.read(socketPoolProvider);

  ChessClock? _clock;
  late SocketClient _socketClient;

  @override
  Future<GameState> build(GameFullId gameFullId) {
    _socketClient = _openSocket();

    _onFullReload = () {
      _logger.warning('full reload triggered');
      ref.invalidateSelf();
    };

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _transientMoveTimer?.cancel();
      _clock?.dispose();
      _clock = null;
      _onFlagThrottler.cancel();
      _onFullReload = null;
    });

    _socketSubscription?.cancel();
    _socketSubscription = _socketClient.stream.listen(_handleSocketEvent);

    return _socketClient.stream.firstWhere((e) => e.topic == 'full').then((event) {
      final fullEvent = GameFullEvent.fromJson(event.data as Map<String, dynamic>);
      _socketClient.version = fullEvent.socketEventVersion;

      final game = fullEvent.game;

      // Play "dong" sound when this is a new game and we're playing it (not spectating)
      final isMyGame = game.youAre != null;
      final noMovePlayed = game.steps.length == 1;
      if (isMyGame && noMovePlayed && game.status == GameStatus.started) {
        ref.read(soundServiceProvider).play(Sound.dong);
      }

      if (game.playable) {
        if (game.clock != null) {
          _clock = ChessClock(
            whiteTime: game.clock!.white,
            blackTime: game.clock!.black,
            emergencyThreshold: game.meta.clock?.emergency,
            onEmergency: onClockEmergency,
            onFlag: onFlag,
          );
          if (game.clock!.running) {
            final pos = game.lastPosition;
            if (pos.fullmoves > 1) {
              _clock!.startSide(pos.turn);
            }
          }
        }
      } else if (game.finished) {
        _onFinishedGameLoad(fullEvent.game);
      }

      return GameState(
        gameFullId: gameFullId,
        game: game,
        stepCursor: game.steps.length - 1,
        liveClock: _clock != null ? (white: _clock!.whiteTime, black: _clock!.blackTime) : null,
      );
    });
  }

  void onFocusRegained() {
    if (_socketClient.isDisposed) {
      assert(false, 'socket client should not be disposed here');
      return;
    }

    if (!state.hasValue || !state.requireValue.game.playable) {
      return;
    }

    if (_socketClient.route != socketUri(gameFullId)) {
      _socketClient = _openSocket();
    } else if (!_socketClient.isConnected) {
      _socketClient.connect();
    }
  }

  void userMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    final curState = state.requireValue;

    if (isPromotionPawnMove(curState.game.lastPosition, move)) {
      state = AsyncValue.data(curState.copyWith(promotionMove: move));
      return;
    }

    final (newPos, newSan) = curState.game.lastPosition.makeSan(move);
    final sanMove = SanMove(newSan, move);
    final newStep = GameStep(
      position: newPos,
      sanMove: sanMove,
      diff: MaterialDiff.fromBoard(newPos.board),
    );

    final shouldConfirmMove = curState.shouldConfirmMove && isPremove != true;

    state = AsyncValue.data(
      curState.copyWith(
        game: curState.game.copyWith(steps: curState.game.steps.add(newStep)),
        stepCursor: curState.stepCursor + 1,
        moveToConfirm: shouldConfirmMove ? move : null,
        promotionMove: null,
        premove: null,
      ),
    );

    _playMoveFeedback(sanMove, skipAnimationDelay: isDrop ?? false);

    if (!shouldConfirmMove) {
      _sendMoveToSocket(
        move,
        isPremove: isPremove ?? false,
        // same logic as web client
        // we want to send client lag only at the beginning of the game when the clock is not running yet
        withLag: curState.game.clock != null && curState.activeClockSide == null,
      );
    }
  }

  void onPromotionSelection(Role? role) {
    final curState = state.requireValue;
    if (role == null) {
      state = AsyncValue.data(curState.copyWith(promotionMove: null));
      return;
    }
    if (curState.promotionMove == null) {
      assert(false, 'promotionMove must not be null on promotion select');
      return;
    }

    final move = curState.promotionMove!.withPromotion(role);
    userMove(move, isDrop: true);
  }

  /// Called if the player cancels the move when confirm move preference is enabled
  void cancelMove() {
    final curState = state.requireValue;
    if (curState.game.steps.isEmpty) {
      assert(false, 'game steps cannot be empty on cancel move');
      return;
    }
    state = AsyncValue.data(
      curState.copyWith(
        game: curState.game.copyWith(steps: curState.game.steps.removeLast()),
        stepCursor: curState.stepCursor - 1,
        moveToConfirm: null,
      ),
    );
  }

  /// Called if the player confirms the move when confirm move preference is enabled
  void confirmMove() {
    final curState = state.requireValue;
    final moveToConfirm = curState.moveToConfirm;
    if (moveToConfirm == null) {
      assert(false, 'moveToConfirm must not be null on confirm move');
      return;
    }

    state = AsyncValue.data(curState.copyWith(moveToConfirm: null));
    _sendMoveToSocket(
      moveToConfirm,
      isPremove: false,
      // same logic as web client
      // we want to send client lag only at the beginning of the game when the clock is not running yet
      withLag: curState.game.clock != null && curState.activeClockSide == null,
    );
  }

  /// Set or unset a premove.
  void setPremove(NormalMove? move) {
    final curState = state.requireValue;
    state = AsyncValue.data(curState.copyWith(premove: move));
  }

  void cursorAt(int cursor) {
    if (state.hasValue) {
      state = AsyncValue.data(state.requireValue.copyWith(stepCursor: cursor, premove: null));
      final san = state.requireValue.game.stepAt(cursor).sanMove?.san;
      if (san != null) {
        _playReplayMoveSound(san);
        HapticFeedback.lightImpact();
      }
    }
  }

  void cursorForward() {
    if (state.hasValue) {
      final curState = state.requireValue;
      if (curState.stepCursor < curState.game.steps.length - 1) {
        state = AsyncValue.data(
          curState.copyWith(stepCursor: curState.stepCursor + 1, premove: null),
        );
        final san = curState.game.stepAt(curState.stepCursor + 1).sanMove?.san;
        if (san != null) {
          _playReplayMoveSound(san);
        }
      }
    }
  }

  void cursorBackward() {
    if (state.hasValue) {
      final curState = state.requireValue;
      if (curState.stepCursor > 0) {
        state = AsyncValue.data(
          curState.copyWith(stepCursor: curState.stepCursor - 1, premove: null),
        );
        final san = curState.game.stepAt(curState.stepCursor - 1).sanMove?.san;
        if (san != null) {
          _playReplayMoveSound(san);
        }
      }
    }
  }

  Future<void> toggleBookmark() async {
    if (state.hasValue) {
      final toggledBookmark = !(state.requireValue.game.bookmarked ?? false);
      await ref
          .read(accountServiceProvider)
          .setGameBookmark(gameFullId.gameId, bookmark: toggledBookmark);
      state = AsyncValue.data(
        state.requireValue.copyWith(
          game: state.requireValue.game.copyWith(bookmarked: toggledBookmark),
        ),
      );
    }
  }

  void toggleMoveConfirmation() {
    final curState = state.requireValue;
    state = AsyncValue.data(
      curState.copyWith(moveConfirmSettingOverride: !(curState.moveConfirmSettingOverride ?? true)),
    );
  }

  void toggleZenMode() {
    final curState = state.requireValue;
    state = AsyncValue.data(
      curState.copyWith(zenModeGameSetting: !(curState.zenModeGameSetting ?? false)),
    );
  }

  void toggleAutoQueen() {
    final curState = state.requireValue;
    state = AsyncValue.data(
      curState.copyWith(autoQueenSettingOverride: !(curState.autoQueenSettingOverride ?? true)),
    );
  }

  void onToggleChat(bool isChatEnabled) {
    if (isChatEnabled) {
      // if chat is enabled, we need to resync the game data to get the chat messages
      _reloadGame();
    }
  }

  /// Play a sound when the clock is about to run out
  Future<void> onClockEmergency(Side activeSide) async {
    if (activeSide != state.valueOrNull?.game.youAre) return;
    final shouldPlay = await ref.read(clockSoundProvider.future);
    if (shouldPlay) {
      ref.read(soundServiceProvider).play(Sound.lowTime);
    }
  }

  void onFlag() {
    _onFlagThrottler(() {
      if (state.hasValue) {
        _socketClient.send('flag', state.requireValue.game.sideToMove.name);
      }
    });
  }

  void moreTime() {
    _socketClient.send('moretime', null);
  }

  void berserk() {
    if (state.valueOrNull?.canBerserk == true && state.valueOrNull?.hasBerserked == false) {
      _socketClient.send('berserk', null);
    }
  }

  void abortGame() {
    _socketClient.send('abort', null);
  }

  void resignGame() {
    _socketClient.send('resign', null);
  }

  void forceResign() {
    _socketClient.send('resign-force', null);
  }

  void forceDraw() {
    _socketClient.send('draw-force', null);
  }

  void claimDraw() {
    _socketClient.send('draw-claim', null);
  }

  void offerOrAcceptDraw() {
    _socketClient.send('draw-yes', null);
  }

  void cancelOrDeclineDraw() {
    _socketClient.send('draw-no', null);
  }

  void offerTakeback() {
    _socketClient.send('takeback-yes', null);
  }

  void acceptTakeback() {
    _socketClient.send('takeback-yes', null);
    setPremove(null);
  }

  void cancelOrDeclineTakeback() {
    _socketClient.send('takeback-no', null);
  }

  void proposeOrAcceptRematch() {
    _socketClient.send('rematch-yes', null);
  }

  void declineRematch() {
    _socketClient.send('rematch-no', null);
  }

  SocketClient _openSocket() {
    return _socketPool.open(
      socketUri(gameFullId),
      forceReconnect: true,
      onEventGapFailure: () {
        _onFullReload?.call();
      },
    );
  }

  /// Update the internal clock on clock server event
  void _updateClock({
    required Duration white,
    required Duration black,
    required Side? activeSide,
    Duration? lag,
  }) {
    _clock?.setTimes(whiteTime: white, blackTime: black);
    if (activeSide != null) {
      _clock?.startSide(activeSide, delay: lag);
    } else {
      _clock?.stop();
    }
  }

  void _sendMoveToSocket(Move move, {required bool isPremove, required bool withLag}) {
    final thinkTime = _clock?.stop();
    final moveTime =
        _clock != null
            ? isPremove == true
                ? Duration.zero
                : thinkTime
            : null;
    _socketClient.send(
      'move',
      {
        'u': move.uci,
        if (moveTime != null) 's': (moveTime.inMilliseconds * 0.1).round().toRadixString(36),
      },
      ackable: true,
      withLag: _clock != null && (moveTime == null || withLag),
    );

    _transientMoveTimer = Timer(const Duration(seconds: 10), _reloadGame);
  }

  /// Move feedback while playing
  void _playMoveFeedback(SanMove sanMove, {bool skipAnimationDelay = false}) {
    final animationDuration = ref.read(boardPreferencesProvider).pieceAnimationDuration;

    final delay = animationDuration ~/ 2;

    if (skipAnimationDelay || delay <= Duration.zero) {
      _moveFeedback(sanMove);
    } else {
      Timer(delay, () {
        _moveFeedback(sanMove);
      });
    }
  }

  void _moveFeedback(SanMove sanMove) {
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

  /// Reload game
  void _reloadGame() {
    _logger.info('Reloading game data');
    _socketClient.connect();
  }

  void _handleSocketEvent(SocketEvent event, [bool hasRetried = false]) {
    if (!state.hasValue) {
      if (event.version != null) {
        _logger.warning('received $event while game state not yet available');
        // not sure whether this can happen so log it
        LichessBinding.instance.firebaseCrashlytics.recordError(
          'received $event while game state not yet available',
          null,
          reason: 'versioned socket event received before game state available',
          information: ['event.type: ${event.topic}'],
        );
      }
      return;
    }

    switch (event.topic) {
      // First message sent when the socket is reconnected
      case 'full':
        final fullEvent = GameFullEvent.fromJson(event.data as Map<String, dynamic>);
        _socketClient.version = fullEvent.socketEventVersion;

        final curState = state.requireValue;

        final newGame = fullEvent.game;
        final isOpponentOnGame =
            newGame.playerOf(newGame.youAre?.opposite ?? Side.white).onGame ?? false;
        final hasSameNumberOfSteps = newGame.steps.length == curState.game.steps.length;

        state = AsyncValue.data(
          state.requireValue.copyWith(
            game: newGame,
            stepCursor: hasSameNumberOfSteps ? curState.stepCursor : newGame.steps.length - 1,
            premove: hasSameNumberOfSteps ? curState.premove : null,
            promotionMove: hasSameNumberOfSteps ? curState.promotionMove : null,
            moveToConfirm: hasSameNumberOfSteps ? curState.moveToConfirm : null,
            opponentLeftCountdown:
                isOpponentOnGame ? null : state.requireValue.opponentLeftCountdown,
          ),
        );

        if (newGame.clock != null) {
          _updateClock(
            white: newGame.clock!.white,
            black: newGame.clock!.black,
            activeSide: state.requireValue.activeClockSide,
          );
        }

      // Server asking for a resync
      case 'resync':
        _onFullReload?.call();

      // Server asking for a reload, or in some cases the reload itself contains
      // another topic message
      case 'reload':
        if (event.data is Map<String, dynamic>) {
          final data = event.data as Map<String, dynamic>;
          if (data['t'] == null) {
            _reloadGame();
            return;
          }
          final reloadEvent = SocketEvent(topic: data['t'] as String, data: data['d']);
          _handleSocketEvent(reloadEvent);
        } else {
          _reloadGame();
        }

      // Move event, received after sending a move or receiving a move from the
      // opponent
      case 'move':
        final curState = state.requireValue;
        final data = MoveEvent.fromJson(event.data as Map<String, dynamic>);
        final playedSide = data.ply.isOdd ? Side.white : Side.black;

        GameState newState = curState.copyWith(
          game: curState.game.copyWith(
            isThreefoldRepetition: data.threefold,
            winner: data.winner,
            status: data.status ?? curState.game.status,
          ),
        );

        if (playedSide == curState.game.youAre) {
          _transientMoveTimer?.cancel();
        }

        // add opponent move
        if (data.ply == curState.game.lastPly + 1) {
          final lastPos = curState.game.lastPosition;
          final move = Move.parse(data.uci)!;
          final sanMove = SanMove(data.san, move);
          final newPos = lastPos.playUnchecked(move);
          final newStep = GameStep(
            sanMove: sanMove,
            position: newPos,
            diff: MaterialDiff.fromBoard(newPos.board),
          );

          newState = newState.copyWith(
            game: newState.game.copyWith(steps: newState.game.steps.add(newStep)),
          );

          if (!curState.isReplaying) {
            newState = newState.copyWith(stepCursor: newState.stepCursor + 1);

            _playMoveFeedback(sanMove);
          }
        }

        if (data.clock != null) {
          final lag =
              newState.game.playable && newState.game.isMyTurn
                  // my own clock doesn't need to be compensated for
                  ? Duration.zero
                  // server will send the lag only if it's more than 10ms
                  // default lag of 10ms is also used by web client
                  : data.clock?.lag ?? const Duration(milliseconds: 10);

          _updateClock(
            white: data.clock!.white,
            black: data.clock!.black,
            lag: lag,
            activeSide: newState.activeClockSide,
          );

          if (newState.game.clock != null) {
            // we don't rely on these values to display the clock, but let's keep
            // the game object in sync
            newState = newState.copyWith.game.clock!(
              white: data.clock!.white,
              black: data.clock!.black,
            );
          } else if (newState.game.correspondenceClock != null) {
            newState = newState.copyWith.game.correspondenceClock!(
              white: data.clock!.white,
              black: data.clock!.black,
            );
          }
        }

        if (newState.game.expiration != null) {
          if (newState.game.steps.length > 2) {
            newState = newState.copyWith.game(expiration: null);
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

        if (curState.game.meta.speed == Speed.correspondence) {
          ref.read(correspondenceServiceProvider).updateGame(gameFullId, newState.game);
        }

        if (!curState.isReplaying &&
            playedSide == curState.game.youAre?.opposite &&
            curState.premove != null) {
          scheduleMicrotask(() {
            final postMovePremove = state.valueOrNull?.premove;
            final postMovePosition = state.valueOrNull?.game.lastPosition;
            if (postMovePremove != null && postMovePosition?.isLegal(postMovePremove) == true) {
              userMove(postMovePremove, isPremove: true);
            }
          });
        }

        state = AsyncValue.data(newState);

      // End game event
      case 'endData':
        final endData = GameEndEvent.fromJson(event.data as Map<String, dynamic>);
        final curState = state.requireValue;
        GameState newState = curState.copyWith(
          game: curState.game.copyWith(
            status: endData.status,
            winner: endData.winner,
            boosted: endData.boosted,
            white: curState.game.white.copyWith(ratingDiff: endData.ratingDiff?.white),
            black: curState.game.black.copyWith(ratingDiff: endData.ratingDiff?.black),
          ),
          premove: null,
        );

        if (endData.clock != null) {
          newState = newState.copyWith.game.clock!(
            white: endData.clock!.white,
            black: endData.clock!.black,
          );
          _updateClock(
            white: endData.clock!.white,
            black: endData.clock!.black,
            activeSide: newState.activeClockSide,
          );
        }

        if (curState.game.lastPosition.fullmoves > 1) {
          Timer(const Duration(milliseconds: 500), () {
            ref.read(soundServiceProvider).play(Sound.dong);
          });
        }

        if (curState.game.meta.speed == Speed.correspondence) {
          ref.read(correspondenceServiceProvider).updateGame(gameFullId, newState.game);
        }

        state = AsyncValue.data(newState);

        if (!newState.game.aborted) {
          _getPostGameData()
              .then((data) {
                final game = _mergePostGameData(state.requireValue.game, data);
                state = AsyncValue.data(state.requireValue.copyWith(game: game));
                _storeGame(game);
              })
              .catchError((Object e, StackTrace s) {
                _logger.warning('Could not get post game data', e, s);
              });
        }

      case 'clockInc':
        final data = event.data as Map<String, dynamic>;
        final side = pick(data['color']).asSideOrNull();
        final newClock = pick(
          data['total'],
        ).letOrNull((it) => Duration(milliseconds: it.asIntOrThrow() * 10));
        final curState = state.requireValue;

        if (side != null && newClock != null) {
          _clock?.setTime(side, newClock);

          // sync game clock object even if it's not used to display the clock
          final newState =
              side == Side.white
                  ? curState.copyWith.game.clock!(white: newClock)
                  : curState.copyWith.game.clock!(black: newClock);
          state = AsyncValue.data(newState);
        }

      // Crowd event, sent when a player quits or joins the game
      case 'crowd':
        final data = event.data as Map<String, dynamic>;
        final whiteOnGame = data['white'] as bool?;
        final blackOnGame = data['black'] as bool?;
        final curState = state.requireValue;
        final opponent = curState.game.youAre?.opposite;
        GameState newState = curState;
        if (whiteOnGame != null) {
          newState = newState.copyWith.game(white: newState.game.white.setOnGame(whiteOnGame));
          if (opponent == Side.white && whiteOnGame == true) {
            newState = newState.copyWith(opponentLeftCountdown: null);
          }
        }
        if (blackOnGame != null) {
          newState = newState.copyWith.game(black: newState.game.black.setOnGame(blackOnGame));
          if (opponent == Side.black && blackOnGame == true) {
            newState = newState.copyWith(opponentLeftCountdown: null);
          }
        }
        state = AsyncValue.data(newState);

      // Gone event, sent when the opponent has quit the game for long enough
      // than we can claim victory
      case 'gone':
        final isGone = event.data as bool;
        GameState newState = state.requireValue;
        final youAre = newState.game.youAre;
        newState = newState.copyWith.game(
          white: youAre == Side.white ? newState.game.white : newState.game.white.setGone(isGone),
          black: youAre == Side.black ? newState.game.black : newState.game.black.setGone(isGone),
        );
        state = AsyncValue.data(newState);

      // Event sent when the opponent has quit the game, to display a countdown
      // before claiming victory is possible
      case 'goneIn':
        final timeLeft = Duration(seconds: event.data as int);
        state = AsyncValue.data(
          state.requireValue.copyWith(opponentLeftCountdown: (timeLeft, DateTime.now())),
        );

      // Event sent when a player adds or cancels a draw offer
      case 'drawOffer':
        final side = pick(event.data).asSideOrNull();
        final curState = state.requireValue;
        state = AsyncValue.data(
          curState.copyWith(
            lastDrawOfferAtPly:
                side != null && side == curState.game.youAre ? curState.game.lastPly : null,
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
              white: curState.game.white.copyWith(proposingTakeback: white ?? false),
              black: curState.game.black.copyWith(proposingTakeback: black ?? false),
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
        state = AsyncValue.data(state.requireValue.copyWith.game(rematch: nextId));

      // Event sent after a rematch is taken, to redirect to the new game
      case 'redirect':
        final data = event.data as Map<String, dynamic>;
        final fullId = pick(data['id']).asGameFullIdOrThrow();
        state = AsyncValue.data(state.requireValue.copyWith(redirectGameId: fullId));

      case 'analysisProgress':
        final data = ServerEvalEvent.fromJson(event.data as Map<String, dynamic>);
        final curState = state.requireValue;
        state = AsyncValue.data(
          curState.copyWith.game(
            white: curState.game.white.copyWith(analysis: data.analysis?.white),
            black: curState.game.black.copyWith(analysis: data.analysis?.black),
            evals: data.evals,
          ),
        );

      case 'berserk':
        ref.read(soundServiceProvider).play(Sound.berserk);

        final side = pick(event.data).asSideOrNull();
        final curState = state.requireValue;

        state = AsyncValue.data(
          curState.copyWith.game(
            white: curState.game.white.copyWith(
              berserk: side == Side.white || curState.game.white.berserk == true,
            ),
            black: curState.game.black.copyWith(
              berserk: side == Side.black || curState.game.black.berserk == true,
            ),
          ),
        );
    }
  }

  Future<void> _storeGame(PlayableGame game) async {
    if (game.finished) {
      final gameStorage = await ref.read(gameStorageProvider.future);
      final existing = await gameStorage.fetch(gameId: gameFullId.gameId);
      final finishedAt = existing?.data.lastMoveAt ?? DateTime.now();
      await gameStorage.save(game.toExportedGame(finishedAt: finishedAt));
    }
  }

  Future<ExportedGame> _getPostGameData() {
    return ref.withClient((client) => GameRepository(client).getGame(gameFullId.gameId));
  }

  Future<void> _onFinishedGameLoad(PlayableGame game) async {
    if (game.meta.speed == Speed.correspondence) {
      ref.read(correspondenceServiceProvider).updateGame(gameFullId, game);
    }

    PlayableGame gameWithPostData = game;
    try {
      final result = await _getPostGameData();
      gameWithPostData = _mergePostGameData(game, result, rewriteSteps: true);
    } catch (e, s) {
      _logger.warning('Could not get post game data', e, s);
    }

    await _storeGame(gameWithPostData);

    state = AsyncValue.data(state.requireValue.copyWith(game: gameWithPostData));
  }

  PlayableGame _mergePostGameData(
    PlayableGame game,
    ExportedGame data, {

    /// Whether to rewrite the steps with the clock data from the archived game
    ///
    /// This should not be done when the game has just finished, because we
    /// don't want to confuse the user with a changing clock.
    bool rewriteSteps = false,
  }) {
    IList<GameStep> newSteps = game.steps;
    if (rewriteSteps && game.meta.clock != null && data.clocks != null) {
      final initialTime = game.meta.clock!.initial;
      newSteps =
          game.steps.mapIndexed((index, element) {
            if (index == 0) {
              return element.copyWith(
                archivedWhiteClock: initialTime,
                archivedBlackClock: initialTime,
              );
            }
            final prevClock = index > 1 ? data.clocks![index - 2] : initialTime;
            final stepClock = data.clocks![index - 1];
            return element.copyWith(
              archivedWhiteClock: index.isOdd ? stepClock : prevClock,
              archivedBlackClock: index.isEven ? stepClock : prevClock,
            );
          }).toIList();
    }

    return game.copyWith(
      steps: newSteps,
      clocks: data.clocks,
      meta: game.meta.copyWith(opening: data.meta.opening, division: data.meta.division),
      white: game.white.copyWith(analysis: data.white.analysis),
      black: game.black.copyWith(analysis: data.black.analysis),
      evals: data.evals,
    );
  }
}

typedef LiveGameClock = ({ValueListenable<Duration> white, ValueListenable<Duration> black});

@freezed
sealed class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required GameFullId gameFullId,
    required PlayableGame game,
    required int stepCursor,
    required LiveGameClock? liveClock,
    int? lastDrawOfferAtPly,
    (Duration, DateTime)? opponentLeftCountdown,

    /// Promotion waiting to be selected (only if auto queen is disabled)
    NormalMove? promotionMove,

    /// Premove waiting to be played
    NormalMove? premove,

    /// Game only setting to override the account preference
    bool? moveConfirmSettingOverride,

    /// Game only setting to override the account preference
    bool? autoQueenSettingOverride,

    /// Zen mode setting if account preference is set to [Zen.gameAuto]
    bool? zenModeGameSetting,

    /// Set if confirm move preference is enabled and player played a move
    Move? moveToConfirm,

    /// Game full id used to redirect to the new game of the rematch
    GameFullId? redirectGameId,
  }) = _GameState;

  /// The [Position] at the current cursor.
  Position get currentPosition => game.positionAt(stepCursor);

  /// Whether the zen mode is active
  bool get isZenModeActive => game.playable ? isZenModeEnabled : game.prefs?.zenMode == Zen.yes;

  /// Whether zen mode is enabled by account preference or local game setting
  bool get isZenModeEnabled =>
      zenModeGameSetting ?? game.prefs?.zenMode == Zen.yes || game.prefs?.zenMode == Zen.gameAuto;

  bool get canPremove =>
      game.meta.speed != Speed.correspondence && (game.prefs?.enablePremove ?? true);
  bool get canAutoQueen => autoQueenSettingOverride ?? (game.prefs?.autoQueen == AutoQueen.always);
  bool get canAutoQueenOnPremove =>
      autoQueenSettingOverride ??
      (game.prefs?.autoQueen == AutoQueen.always || game.prefs?.autoQueen == AutoQueen.premove);
  bool get shouldConfirmResignAndDrawOffer => game.prefs?.confirmResign ?? true;
  bool get shouldConfirmMove => moveConfirmSettingOverride ?? game.prefs?.submitMove ?? false;

  bool get isReplaying => stepCursor < game.steps.length - 1;
  bool get canGoForward => stepCursor < game.steps.length - 1;
  bool get canGoBackward => stepCursor > 0;

  bool get canBerserk =>
      game.meta.tournament?.berserkable == true &&
      game.playable &&
      game.steps.length <= 2 &&
      game.youAre != null;
  bool get hasBerserked => game.youAre != null && game.playerOf(game.youAre!).berserk == true;

  // Only if this game is part of a tournament
  TournamentMeta? get tournament => game.meta.tournament;

  bool get canGetNewOpponent =>
      !game.playable &&
      game.meta.speed != Speed.correspondence &&
      (game.source == GameSource.lobby || game.source == GameSource.pool);

  bool get canOfferDraw => game.drawable && (lastDrawOfferAtPly ?? -99) < game.lastPly - 20;

  bool get canShowClaimWinCountdown =>
      !game.isMyTurn &&
      game.resignable &&
      (game.meta.rules == null || !game.meta.rules!.contains(GameRule.noClaimWin));

  bool get canOfferRematch =>
      game.rematch == null &&
      game.rematchable &&
      (game.finished ||
          (game.aborted &&
              (!game.meta.rated || !{GameSource.lobby, GameSource.pool}.contains(game.source)))) &&
      game.boosted != true;

  /// Time left to move for the active player if an expiration is set
  Duration? get timeToMove {
    if (!game.playable || game.expiration == null) {
      return null;
    }
    final timeLeft =
        game.expiration!.movedAt.difference(DateTime.now()) + game.expiration!.timeToMove;

    if (timeLeft.isNegative) {
      return Duration.zero;
    }
    return timeLeft;
  }

  Side? get activeClockSide {
    if (game.clock == null && game.correspondenceClock == null) {
      return null;
    }
    if (game.status == GameStatus.started) {
      final pos = game.lastPosition;
      if (pos.fullmoves > 1) {
        return moveToConfirm != null ? pos.turn.opposite : pos.turn;
      }
    }

    return null;
  }

  String get analysisPgn => game.makePgn();

  AnalysisOptions get analysisOptions =>
      game.finished
          ? AnalysisOptions(
            orientation: game.youAre ?? Side.white,
            initialMoveCursor: stepCursor,
            gameId: gameFullId.gameId,
          )
          : AnalysisOptions(
            orientation: game.youAre ?? Side.white,
            initialMoveCursor: stepCursor,
            standalone: (
              pgn: game.makePgn(),
              variant: game.meta.variant,
              isComputerAnalysisAllowed: false,
            ),
          );

  GameChatOptions? get chatOptions =>
      isZenModeActive || game.meta.tournament != null
          ? null
          : GameChatOptions(
            id: gameFullId,
            opponent: game.youAre != null ? game.playerOf(game.youAre!.opposite).user : null,
          );
}
