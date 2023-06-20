import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

part 'game_ctrl.freezed.dart';
part 'game_ctrl.g.dart';

@riverpod
class GameCtrl extends _$GameCtrl {
  StreamSubscription<dynamic>? _socketSubscription;

  @override
  Future<GameCtrlState> build(GameFullId gameFullId) {
    final socket = ref.watch(authSocketProvider);
    final stream = socket.connect();

    final state = stream
        .firstWhere((e) => e.type == SocketEventType.gameFull)
        .then((event) {
      final game =
          PlayableGame.fromWebSocketJson(event.data as Map<String, dynamic>);
      return GameCtrlState(game: game);
    });

    _socketSubscription = stream.listen(_handleSocketMsg);

    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    socket.switchRoute(Uri(path: '/play/$gameFullId/v6'));

    return state;
  }

  void _handleSocketMsg(SocketEvent event) {
    if (event.type == SocketEventType.pong) {
      return;
    }
  }
}

@freezed
class GameCtrlState with _$GameCtrlState {
  const GameCtrlState._();

  const factory GameCtrlState({
    required PlayableGame game,
  }) = _GameCtrlState;
}
