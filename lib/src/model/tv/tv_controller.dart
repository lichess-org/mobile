import 'dart:async';
import 'package:async/async.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_socket_events.dart';

part 'tv_controller.freezed.dart';
part 'tv_controller.g.dart';

@riverpod
class TvController extends _$TvController {
  StreamSubscription<SocketEvent>? _socketSubscription;

  /// Last socket version received
  int _socketEventVersion = 0;

  @override
  Future<TvState> build(
    TvChannel channel,
    (GameId id, Side orientation)? initialGame,
  ) async {
    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    return _connectWebsocket(initialGame);
  }

  AuthSocket get _socket => ref.read(authSocketProvider);
  TvRepository get _tvRepository => ref.read(tvRepositoryProvider);
  SoundService get _soundService => ref.read(soundServiceProvider);

  Future<void> startWatching() async {
    final newState = await _connectWebsocket(null);
    state = AsyncValue.data(newState);
  }

  void stopWatching() {
    _socketSubscription?.cancel();
  }

  Future<TvState> _connectWebsocket(
    (GameId id, Side orientation)? game,
  ) async {
    GameId id;
    Side orientation;

    if (game != null) {
      id = game.$1;
      orientation = game.$2;
    } else {
      final channels = await Result.release(_tvRepository.channels());
      final channelGame = channels[channel]!;
      id = channelGame.id;
      orientation = channelGame.side ?? Side.white;
    }

    final (stream, _) = _socket.connect(
      Uri(
        path: '/watch/$id/${orientation.name}/v6',
      ),
      forceReconnect: true,
    );

    _socketSubscription?.cancel();

    return stream.firstWhere((e) => e.topic == 'full').then((event) {
      final fullEvent =
          GameFullEvent.fromJson(event.data as Map<String, dynamic>);

      _socketSubscription = stream.listen(_handleSocketEvent);

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

  void _handleSocketEvent(SocketEvent event) {
    if (event.version != null) {
      if (event.version! <= _socketEventVersion) {
        return;
      }
      if (event.version! > _socketEventVersion + 1) {
        _connectWebsocket(null);
      }
      _socketEventVersion = event.version!;
    }

    _handleSocketTopic(event);
  }

  void _handleSocketTopic(SocketEvent event) {
    if (!state.hasValue) {
      assert(
        false,
        'received a game SocketEvent while TvState is null',
      );
      return;
    }

    switch (event.topic) {
      case 'move':
        final curState = state.requireValue;
        final data = MoveEvent.fromJson(event.data as Map<String, dynamic>);
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

        TvState newState = curState.copyWith(
          game: curState.game.copyWith(
            steps: curState.game.steps.add(newStep),
          ),
          stepCursor: curState.stepCursor + 1,
        );

        if (newState.game.clock != null && data.clock != null) {
          newState = newState.copyWith.game.clock!(
            white: data.clock!.white,
            black: data.clock!.black,
          );
        }

        state = AsyncData(newState);

        if (data.san.contains('x')) {
          _soundService.play(Sound.capture);
        } else {
          _soundService.play(Sound.move);
        }

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
class TvState with _$TvState {
  const TvState._();

  const factory TvState({
    required PlayableGame game,
    required int stepCursor,
    required Side orientation,
  }) = _TvState;

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
