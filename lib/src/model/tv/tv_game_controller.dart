import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/chat/chat_mixin.dart';
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
import 'package:lichess_mobile/src/model/tv/tv_controller.dart';
import 'package:lichess_mobile/src/model/tv/tv_socket_events.dart';
import 'package:lichess_mobile/src/network/socket.dart';

part 'tv_game_controller.freezed.dart';

/// Identifies a single game watched on the TV screen.
///
/// [source] is the parameters of the [TvController] that produced this game,
/// and lets the game controller route channel switches back to it.
typedef TvGameControllerParams = ({GameId gameId, Side orientation, TvControllerParams source});

final tvGameControllerProvider = AsyncNotifierProvider.autoDispose
    .family<TvGameController, TvGameState, TvGameControllerParams>(
      TvGameController.new,
      name: 'TvGameControllerProvider',
    );

/// Watches a single TV game: connects to its socket, exposes its state and,
/// when chat is enabled, its chat.
///
/// Chat is only enabled when watching a single game or a user's TV, not when
/// watching a TV channel.
class TvGameController extends AsyncNotifier<TvGameState> with ChatMixin<TvGameState> {
  TvGameController(this.params);

  final TvGameControllerParams params;

  StreamSubscription<SocketEvent>? _socketSubscription;

  VoidCallback? _onReload;

  bool get _chatEnabled => params.source.channel == null;

  @override
  @protected
  StringId get chatId => params.gameId;

  @override
  @protected
  String get chatReportResource => 'game/$chatId';

  @override
  @protected
  bool get chatIsPublic => true;

  @override
  Future<TvGameState> build() {
    _onReload = ref.invalidateSelf;

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _onReload = null;
    });

    return _connectWebsocket();
  }

  SoundService get _soundService => ref.read(soundServiceProvider);

  @override
  Future<void> onFocusRegained() async {
    state = AsyncValue.data(await _connectWebsocket());
  }

  @override
  void onForegroundLost() {
    _socketSubscription?.cancel();
  }

  Future<TvGameState> _connectWebsocket() async {
    final socketClient = ref
        .read(socketPoolProvider)
        .open(
          Uri(
            path: '/watch/${params.gameId}/${params.orientation.name}/v6',
            queryParameters: params.source.userId != null
                ? {'userTv': params.source.userId.toString()}
                : null,
          ),
          forceReconnect: true,
          onEventGapFailure: () {
            _onReload?.call();
          },
        );

    _socketSubscription?.cancel();
    _socketSubscription = socketClient.stream.listen(handleSocketEvent);

    final rawFullEvent = await socketClient.stream.firstWhere((e) => e.topic == 'full');
    final fullEvent = GameFullEvent.fromJson(rawFullEvent.data as Map<String, dynamic>);
    socketClient.version = fullEvent.socketEventVersion;

    return TvGameState(
      game: fullEvent.game,
      stepCursor: fullEvent.game.steps.length - 1,
      orientation: params.orientation,
      chatState: _chatEnabled ? await initChat(fullEvent.game.chat) : null,
    );
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

  void goToMove(int index) {
    if (state.hasValue) {
      final curState = state.requireValue;
      if (index >= 0 && index < curState.game.steps.length) {
        state = AsyncValue.data(curState.copyWith(stepCursor: index));
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

  @protected
  @override
  void updateChatState(ChatState newState) {
    state = AsyncValue.data(state.requireValue.copyWith(chatState: newState));
  }

  Future<void> _onResyncOrRematchTaken() async {
    if (!ref.mounted) return;
    if (params.source.userId != null) {
      await ref.read(tvControllerProvider(params.source).notifier).resolveCurrentGame();
    } else {
      _onReload?.call();
    }
  }

  @protected
  @override
  void handleSocketEvent(SocketEvent event) {
    super.handleSocketEvent(event);

    if (event.topic == 'resync' || event.topic == 'rematchTaken') {
      unawaited(
        _onResyncOrRematchTaken().catchError((_) {
          _onReload?.call();
        }),
      );
      return;
    }

    if (!state.hasValue) {
      return;
    }

    switch (event.topic) {
      case 'reload':
        if (event.data is Map<String, dynamic>) {
          final data = event.data as Map<String, dynamic>;
          if (data['t'] == null) {
            _onReload?.call();
            return;
          }
          final reloadEvent = SocketEvent(topic: data['t'] as String, data: data['d']);
          handleSocketEvent(reloadEvent);
        } else {
          _onReload?.call();
        }
      case 'crowd':
        final data = event.data as Map<String, dynamic>;
        final watcherData = data['watchers'];
        if (watcherData != null && watcherData is Map<String, dynamic>) {
          final nb = watcherData['nb'] as int? ?? 0;
          final users =
              (watcherData['users'] as List<dynamic>?)?.map((e) => e.toString()).toIList() ??
              const IList.empty();
          state = AsyncData(state.requireValue.copyWith(nbWatchers: nb, watcherNames: users));
        }
      case 'move' || 'drop':
        final curState = state.requireValue;
        final data = MoveEvent.fromJson(event.data as Map<String, dynamic>);
        final lastPos = curState.game.lastPosition;
        final move = Move.parse(data.uci)!;
        final sanMove = SanMove(data.san, move);
        final newPos = lastPos.playUnchecked(move);
        final newStep = GameStep(
          sanMove: sanMove,
          position: newPos,
          diff: MaterialDiff.fromPosition(newPos),
        );

        TvGameState newState = curState.copyWith(
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
        TvGameState newState = state.requireValue.copyWith(
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
        if (eventChannel != null && eventChannel == params.source.channel) {
          final data = TvSelectEvent.fromJson(json);
          ref.read(tvControllerProvider(params.source).notifier).moveToNextGame((
            data.id,
            data.orientation,
          ));
        }
    }
  }
}

@freezed
sealed class TvGameState with _$TvGameState, ChatMixinState {
  const TvGameState._();

  const factory TvGameState({
    required PlayableGame game,
    required int stepCursor,
    required Side orientation,
    ChatState? chatState,
    @Default(0) int nbWatchers,
    @Default(IList<String>.empty()) IList<String> watcherNames,
  }) = _TvGameState;

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

  @override
  bool get chatEnabled => chatState != null;
}
