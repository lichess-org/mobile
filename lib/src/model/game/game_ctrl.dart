import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_socket.dart';

part 'game_ctrl.freezed.dart';
part 'game_ctrl.g.dart';

@riverpod
class GameCtrl extends _$GameCtrl {
  StreamSubscription<SocketEvent>? _socketSubscription;

  @override
  Future<GameCtrlState> build(GameFullId gameFullId) {
    final socket = ref.watch(authSocketProvider);
    final stream = socket.connect();

    final state = stream.firstWhere((e) => e.topic == 'full').then((event) {
      final data = event.data as Map<String, dynamic>;
      final game = PlayableGame.fromWebSocketJson(data);
      return GameCtrlState(
        game: game,
        stepCursor: game.steps.length - 1,
        socketVersion: data['socket'] as int,
      );
    });

    _socketSubscription = stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    socket.switchRoute(Uri(path: '/play/$gameFullId/v6'));

    return state;
  }

  void sendMove(Move move) {
    final socket = ref.read(authSocketProvider);
    socket.send('move', {
      'u': move.uci,
    });
  }

  void _handleSocketEvent(SocketEvent event) {
    switch (event.topic) {
      case 'move':
        final data =
            SocketMoveEvent.fromJson(event.data as Map<String, dynamic>);
    }
  }
}

@freezed
class GameCtrlState with _$GameCtrlState {
  const GameCtrlState._();

  const factory GameCtrlState({
    required PlayableGame game,
    required int stepCursor,
    required int socketVersion,
  }) = _GameCtrlState;
}
