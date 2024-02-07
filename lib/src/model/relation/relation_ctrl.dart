import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relation_ctrl.freezed.dart';
part 'relation_ctrl.g.dart';

@riverpod
class RelationCtrl extends _$RelationCtrl {
  StreamSubscription<SocketEvent>? _socketSubscription;

  @override
  Future<RelationCtrlState> build() {
    final (stream, readyStream) =
        _socket.connect(Uri(path: '/lobby/socket/v5'));

    final state = stream.firstWhere((e) => e.topic == 'following_onlines').then(
          (event) => RelationCtrlState(
            followingOnlines: _parseFriendsList(event.data as List<dynamic>),
          ),
        );

    _socketSubscription = stream.listen(_handleSocketTopic);

    readyStream.forEach((_) {
      _socket.send('following_onlines', null);
    });

    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    return state;
  }

  void startWatchingFriends() {
    final (stream, readyStream) =
        _socket.connect(Uri(path: '/lobby/socket/v5'));
    _socketSubscription?.cancel();
    _socketSubscription = stream.listen(_handleSocketTopic);
    readyStream.forEach((_) {
      _socket.send('following_onlines', null);
    });
  }

  void stopWatchingFriends() {
    _socketSubscription?.cancel();
  }

  void _handleSocketTopic(SocketEvent event) {
    if (!state.hasValue) return;

    switch (event.topic) {
      case 'following_onlines':
        state = AsyncValue.data(
          RelationCtrlState(
            followingOnlines: _parseFriendsList(event.data as List<dynamic>),
          ),
        );

      case 'following_enters':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(
          state.requireValue.copyWith(
            followingOnlines: state.requireValue.followingOnlines.add(data),
          ),
        );

      case 'following_leaves':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(
          state.requireValue.copyWith(
            followingOnlines: state.requireValue.followingOnlines
                .removeWhere((v) => v.id == data.id),
          ),
        );
    }
  }

  SocketService get _socket => ref.read(socketServiceProvider);

  LightUser _parseFriend(String friend) {
    final splitted = friend.split(' ');
    final name = splitted.length > 1 ? splitted[1] : splitted[0];
    final title = splitted.length > 1 ? splitted[0] : null;
    return LightUser(
      id: UserId.fromUserName(name),
      name: name,
      title: title,
    );
  }

  IList<LightUser> _parseFriendsList(List<dynamic> friends) {
    return friends.map((v) => _parseFriend(v.toString())).toIList();
  }
}

@freezed
class RelationCtrlState with _$RelationCtrlState {
  const RelationCtrlState._();

  const factory RelationCtrlState({
    required IList<LightUser> followingOnlines,
  }) = _RelationCtrlState;
}
