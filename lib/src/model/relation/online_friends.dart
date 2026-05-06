import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';

typedef OnlineFriend = ({LightUser user, bool playing});

final onlineFriendsProvider = AsyncNotifierProvider.autoDispose<OnlineFriends, IList<OnlineFriend>>(
  OnlineFriends.new,
  name: 'OnlineFriendsProvider',
);

class OnlineFriends extends AsyncNotifier<IList<OnlineFriend>> {
  StreamSubscription<SocketEvent>? _socketSubscription;
  StreamSubscription<void>? _socketOpenSubscription;

  late SocketClient _socketClient;

  @override
  FutureOr<IList<OnlineFriend>> build() {
    _socketClient = ref.read(socketPoolProvider).open(Uri(path: kDefaultSocketRoute));

    _socketSubscription?.cancel();
    _socketSubscription = _socketClient.stream.listen(_handleSocketTopic);

    _socketOpenSubscription?.cancel();
    _socketOpenSubscription = _socketClient.connectedStream.listen((_) {
      if (!ref.mounted) return;
      _socketClient.send('following_onlines', null);
    });

    ref.onDispose(() {
      _socketSubscription?.cancel();
      _socketOpenSubscription?.cancel();
    });

    // Ask for the list immediately if the socket is already active
    if (_socketClient.isActive) {
      _socketClient.send('following_onlines', null);
    } else {
      _socketClient.connect();
    }

    // Return an empty list immediately
    return const IListConst([]);
  }

  void startWatchingFriends() {
    if (!_socketClient.isActive) {
      _socketClient.connect();
    } else {
      _socketClient.send('following_onlines', null);
    }
    _socketSubscription?.resume();
  }

  void stopWatchingFriends() {
    _socketSubscription?.pause();
  }

  void _handleSocketTopic(SocketEvent event) {
    if (!ref.mounted) return;

    final currentList = state.value ?? const IListConst([]);

    switch (event.topic) {
      case 'following_onlines':
        state = AsyncValue.data(_parseFriendsList(event));

      case 'following_enters':
        final patronColor = event.json?['patronColor'] as int?;
        final user = _parseFriend(event.data.toString(), patronColor);
        final playing = event.json?['playing'] as bool? ?? false;
        
        // Prevent duplicate entries
        if (!currentList.any((v) => v.user.id == user.id)) {
          state = AsyncValue.data(currentList.add((user: user, playing: playing)));
        }

      case 'following_leaves':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(currentList.removeWhere((v) => v.user.id == data.id));

      case 'following_playing':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(
          currentList.map((v) {
            return v.user.id == data.id ? (user: v.user, playing: true) : v;
          }).toIList(),
        );

      case 'following_stopped_playing':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(
          currentList.map((v) {
            return v.user.id == data.id ? (user: v.user, playing: false) : v;
          }).toIList(),
        );
    }
  }

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
      final patronColor = friends.length == patronColors.length ? patronColors[i] as int? : null;
      final user = _parseFriend(
        v.toString(),
        patronColor != null && patronColor > 0 ? patronColor : null,
      );
      final isPlaying = playing.contains(user.id.toString());
      return (user: user, playing: isPlaying);
    }).toIList();
  }
}
