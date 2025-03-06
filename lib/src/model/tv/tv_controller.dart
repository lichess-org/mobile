import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
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
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_controller.freezed.dart';
part 'tv_controller.g.dart';

@riverpod
class TvController extends _$TvController {
  StreamSubscription<SocketEvent>? _socketSubscription;

  /// Last socket version received
  int? _socketEventVersion;

  @override
  Future<TvState> build(TvChannel? channel, (GameId id, Side orientation)? initialGame) {
    assert(channel != null || initialGame != null, 'Either a channel or a game must be provided');
    ref.onDispose(() {
      _socketSubscription?.cancel();
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
    } else {
      final channels = await ref.withClient((client) => TvRepository(client).channels());
      final channelGame = channels[channel!]!;
      id = channelGame.id;
      orientation = channelGame.side ?? Side.white;
    }

    final socketClient = ref
        .read(socketPoolProvider)
        .open(Uri(path: '/watch/$id/${orientation.name}/v6'), forceReconnect: true);

    _socketSubscription?.cancel();
    _socketEventVersion = null;
    _socketSubscription = socketClient.stream.listen(_handleSocketEvent);

    return socketClient.stream.firstWhere((e) => e.topic == 'full').then((event) {
      final fullEvent = GameFullEvent.fromJson(event.data as Map<String, dynamic>);

      _socketEventVersion = fullEvent.socketEventVersion;

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
    final currentEventVersion = _socketEventVersion;

    /// We don't have a version yet, let's wait for the full event
    if (currentEventVersion == null) {
      return;
    }

    if (event.version != null) {
      if (event.version! <= currentEventVersion) {
        return;
      }
      if (event.version! > currentEventVersion + 1) {
        _connectWebsocket(null);
      }
      _socketEventVersion = event.version;
    }

    _handleSocketTopic(event);
  }

  void _handleSocketTopic(SocketEvent event) {
    if (!state.hasValue) {
      assert(false, 'received a game SocketEvent while TvState is null');
      return;
    }

    switch (event.topic) {
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
        if (eventChannel == channel) {
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
