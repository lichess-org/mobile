import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/tv/tv_socket_events.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_controller.freezed.dart';
part 'tv_controller.g.dart';

@riverpod
class TvController extends _$TvController {
  StreamSubscription<SocketEvent>? _socketSubscription;

  VoidCallback? _onReload;

  @override
  Future<TvState> build(
    TvChannel? channel, {
    (GameId id, Side orientation)? initialGame,
    UserId? userId,
  }) {
    assert(channel != null || userId != null, 'Either a channel or a userId must be provided');

    _onReload = ref.invalidateSelf;

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _onReload = null;
    });

    return _connectWebsocket(initialGame);
  }

  SoundService get _soundService => ref.read(soundServiceProvider);

  Future<void> startWatching() async {
    final newState = await _connectWebsocket(null);
    state = AsyncValue.data(newState);
  }

  void stopWatching() {
    _socketSubscription?.cancel();
  }

  Future<TvState> _connectWebsocket((GameId id, Side orientation)? game) async {
    GameId id;
    Side orientation;

    if (game != null) {
      id = game.$1;
      orientation = game.$2;
    } else if (channel != null) {
      final channels = await ref.withClient((client) => TvRepository(client).channels());
      final channelGame = channels[channel!]!;
      id = channelGame.id;
      orientation = channelGame.side ?? Side.white;
    } else if (userId != null) {
      final game = await ref.withClient((client) => UserRepository(client).getCurrentGame(userId!));
      id = game.id;
      orientation = game.playerSideOf(userId!) ?? Side.white;
    } else {
      id = state.valueOrNull?.game.id ?? initialGame!.$1;
      orientation = state.valueOrNull?.orientation ?? initialGame!.$2;
    }

    final socketClient = ref
        .read(socketPoolProvider)
        .open(
          Uri(
            path: '/watch/$id/${orientation.name}/v6',
            queryParameters: userId != null ? {'userTv': userId.toString()} : null,
          ),
          forceReconnect: true,
          onEventGapFailure: () {
            _onReload?.call();
          },
        );

    _socketSubscription?.cancel();
    _socketSubscription = socketClient.stream.listen(_handleSocketEvent);

    return socketClient.stream.firstWhere((e) => e.topic == 'full').then((event) {
      final fullEvent = GameFullEvent.fromJson(event.data as Map<String, dynamic>);
      socketClient.version = fullEvent.socketEventVersion;

      return TvState(
        game: fullEvent.game,
        stepCursor: fullEvent.game.steps.length - 1,
        orientation: orientation,
      );
    });
  }

  Future<void> _moveToNextGame((GameId id, Side orientation) game) async {
    final newState = await _connectWebsocket(game);
    state = AsyncValue.data(newState);
  }

  bool canGoBack() => state.mapOrNull(data: (d) => d.value.stepCursor > 0) ?? false;

  bool canGoForward() =>
      state.mapOrNull(data: (d) => d.value.stepCursor < d.value.game.steps.length - 1) ?? false;

  void toggleBoard() {
    if (state.hasValue) {
      final curState = state.requireValue;
      state = AsyncValue.data(curState.copyWith(orientation: curState.orientation.opposite));
    }
  }

  void cursorForward() {
    if (state.hasValue) {
      final curState = state.requireValue;
      if (curState.stepCursor < curState.game.steps.length - 1) {
        state = AsyncValue.data(curState.copyWith(stepCursor: curState.stepCursor + 1));
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
        state = AsyncValue.data(curState.copyWith(stepCursor: curState.stepCursor - 1));
        final san = curState.game.stepAt(curState.stepCursor - 1).sanMove?.san;
        if (san != null) {
          _playReplayMoveSound(san);
        }
      }
    }
  }

  void _playReplayMoveSound(String san) {
    final soundService = ref.read(soundServiceProvider);
    if (san.contains('x')) {
      soundService.play(Sound.capture);
    } else {
      soundService.play(Sound.move);
    }
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) {
      return;
    }

    switch (event.topic) {
      case 'resync':
        _onReload?.call();
      case 'reload':
        if (event.data is Map<String, dynamic>) {
          final data = event.data as Map<String, dynamic>;
          if (data['t'] == null) {
            _onReload?.call();
            return;
          }
          final reloadEvent = SocketEvent(topic: data['t'] as String, data: data['d']);
          _handleSocketEvent(reloadEvent);
        } else {
          _onReload?.call();
        }
      case 'rematchTaken':
        _onReload?.call();
      case 'move':
        final curState = state.requireValue;
        final data = MoveEvent.fromJson(event.data as Map<String, dynamic>);
        final lastPos = curState.game.lastPosition;
        final move = Move.parse(data.uci)!;
        final sanMove = SanMove(data.san, move);
        final newPos = lastPos.playUnchecked(move);
        final newStep = GameStep(
          sanMove: sanMove,
          position: newPos,
          diff: MaterialDiff.fromBoard(newPos.board),
        );

        TvState newState = curState.copyWith(
          game: curState.game.copyWith(steps: curState.game.steps.add(newStep)),
        );

        if (newState.game.clock != null && data.clock != null) {
          newState = newState.copyWith.game.clock!(
            white: data.clock!.white,
            black: data.clock!.black,
            lag: data.clock!.lag,
            at: data.clock!.at,
          );
        }
        if (!curState.isReplaying) {
          newState = newState.copyWith(stepCursor: newState.stepCursor + 1);

          if (data.san.contains('x')) {
            _soundService.play(Sound.capture);
          } else {
            _soundService.play(Sound.move);
          }
        }

        state = AsyncData(newState);

      case 'endData':
        final endData = GameEndEvent.fromJson(event.data as Map<String, dynamic>);
        TvState newState = state.requireValue.copyWith(
          game: state.requireValue.game.copyWith(status: endData.status, winner: endData.winner),
        );
        if (endData.clock != null) {
          newState = newState.copyWith.game.clock!(
            white: endData.clock!.white,
            black: endData.clock!.black,
            at: DateTime.now(),
            lag: null,
          );
        }
        state = AsyncData(newState);

      case 'tvSelect':
        final json = event.data as Map<String, dynamic>;
        final eventChannel = pick(json, 'channel').asTvChannelOrNull();
        if (eventChannel != null && eventChannel == channel) {
          final data = TvSelectEvent.fromJson(json);
          _moveToNextGame((data.id, data.orientation));
        }
    }
  }
}

@freezed
sealed class TvState with _$TvState {
  const TvState._();

  const factory TvState({
    required PlayableGame game,
    required int stepCursor,
    required Side orientation,
  }) = _TvState;

  bool get isReplaying => stepCursor < game.steps.length - 1;

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
