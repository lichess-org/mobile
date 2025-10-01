import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'online_friends.g.dart';

typedef OnlineFriend = ({LightUser user, bool playing});

@riverpod
class OnlineFriends extends _$OnlineFriends {
  StreamSubscription<SocketEvent>? _socketSubscription;
  StreamSubscription<void>? _socketOpenSubscription;

  late SocketClient _socketClient;

  @override
  Future<IList<OnlineFriend>> build() async {
    ref.onDispose(() {
      _socketSubscription?.cancel();
      _socketOpenSubscription?.cancel();
    });

    _socketClient = _socketPool.open(Uri(path: kDefaultSocketRoute));

    final state = _socketClient.stream
        .firstWhere((e) => e.topic == 'following_onlines')
        .then((event) => _parseFriendsList(event));

    await _socketClient.firstConnection;

    // Request the list of online friends once the socket is connected.
    _socketClient.send('following_onlines', null);

    // Start watching for online friends.
    _socketSubscription = _socketClient.stream.listen(_handleSocketTopic);

    _socketOpenSubscription?.cancel();
    // Request again the list of online friends every time the socket is reconnected.
    _socketOpenSubscription = _socketClient.connectedStream.listen((_) {
      _socketClient.send('following_onlines', null);
    });

    return state;
  }

  void startWatchingFriends() {
    _socketSubscription?.cancel();
    _socketSubscription = _socketClient.stream.listen(_handleSocketTopic);
    _socketOpenSubscription?.cancel();
    _socketOpenSubscription = _socketClient.connectedStream.listen((_) {
      _socketClient.send('following_onlines', null);
    });
    if (!_socketClient.isActive) {
      _socketClient.connect();
    } else {
      _socketClient.send('following_onlines', null);
    }
  }

  void stopWatchingFriends() {
    _socketSubscription?.cancel();
    _socketOpenSubscription?.cancel();
  }

  void _handleSocketTopic(SocketEvent event) {
    if (!state.hasValue) return;

    switch (event.topic) {
      case 'following_onlines':
        state = AsyncValue.data(_parseFriendsList(event));

      case 'following_enters':
        final patronColor = event.json?['patronColor'] as int?;
        final user = _parseFriend(event.data.toString(), patronColor);
        final playing = event.json?['playing'] as bool? ?? false;
        state = AsyncValue.data(state.requireValue.add((user: user, playing: playing)));

      case 'following_leaves':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(state.requireValue.removeWhere((v) => v.user.id == data.id));

      case 'following_playing':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(
          state.requireValue.map((v) {
            if (v.user.id == data.id) {
              return (user: v.user, playing: true);
            }
            return v;
          }).toIList(),
        );

      case 'following_stopped_playing':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(
          state.requireValue.map((v) {
            if (v.user.id == data.id) {
              return (user: v.user, playing: false);
            }
            return v;
          }).toIList(),
        );
    }
  }

  SocketPool get _socketPool => ref.read(socketPoolProvider);

  LightUser _parseFriend(String friend, [int? patronColor]) {
    final splitted = friend.split(' ');
    final name = splitted.length > 1 ? splitted[1] : splitted[0];
    final title = splitted.length > 1 ? splitted[0] : null;
    return LightUser(
      id: UserId.fromUserName(name),
      name: name,
      title: title,
      patronColor: patronColor,
    );
  }

  IList<OnlineFriend> _parseFriendsList(SocketEvent event) {
    final friends = event.data as List<dynamic>;
    final patronColors = event.json?['patronColors'] as List<dynamic>? ?? [];
    final playing = event.json?['playing'] as List<dynamic>? ?? [];
    return friends.mapIndexed((i, v) {
      final user = _parseFriend(v.toString(), patronColors[i] as int?);
      final isPlaying = playing.contains(user.id.toString());
      return (user: user, playing: isPlaying);
    }).toIList();
  }
}
