import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/socket.dart';

part 'relation_ctrl.freezed.dart';
part 'relation_ctrl.g.dart';

@riverpod
class RelationCtrl extends _$RelationCtrl {
  StreamSubscription<SocketEvent>? _socketSubscription;

  @override
  Future<RelationCtrlState> build() {
    final socket = ref.watch(authSocketProvider);
    final (stream, _) = socket.connect(Uri(path: '/lobby/socket/v5'));

    final state = stream.firstWhere((e) => e.topic == 'following_onlines').then(
      (event) {
        _socketSubscription = stream.listen(_handleSocketTopic);
        return RelationCtrlState(followingOnlines: event.data as List<dynamic>);
      },
    );

    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    return state;
  }

  void getFollowingOnlines() {
    _socket.send('following_onlines', null);
  }

  void _handleSocketTopic(SocketEvent event) {
    switch (event.topic) {
      case 'following_onlines':
        final data = event.data as List<dynamic>;
        if (state is AsyncData) {
          state = AsyncValue.data(
            (state as AsyncData<RelationCtrlState>).requireValue.copyWith(
                  followingOnlines: data,
                ),
          );
        }

      case 'following_enters':
        final data = event.data as dynamic;
        if (state is AsyncData) {
          state = AsyncValue.data(
            (state as AsyncData<RelationCtrlState>).requireValue.copyWith(
              followingOnlines: [
                ...state.requireValue.followingOnlines,
                data,
              ],
            ),
          );
        }

      case 'following_leaves':
        final data = event.data as dynamic;
        if (state is AsyncData) {
          state = AsyncValue.data(
            (state as AsyncData<RelationCtrlState>).requireValue.copyWith(
                  followingOnlines: state.requireValue.followingOnlines
                      .where((e) => e != data)
                      .toList(),
                ),
          );
        }
    }
  }

  AuthSocket get _socket => ref.read(authSocketProvider);
}

@freezed
class RelationCtrlState with _$RelationCtrlState {
  const RelationCtrlState._();

  const factory RelationCtrlState({
    required List<dynamic> followingOnlines,
  }) = _RelationCtrlState;
}
