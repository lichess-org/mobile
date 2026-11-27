import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';

typedef OnlineFriend = ({LightUser user, bool playing});

final onlineFriendsProvider = AsyncNotifierProvider.autoDispose<OnlineFriends, IList<OnlineFriend>>(
  OnlineFriends.new,
  name: 'OnlineFriendsProvider',
);

class OnlineFriends() extends AsyncNotifier<IList<OnlineFriend>> {
  StreamSubscription<SocketEvent>? _socketSubscription;
  StreamSubscription<void>? _socketOpenSubscription;

  /// Completes with the first friends list the server sends, while the provider
  /// is still in the loading state.
  Completer<IList<OnlineFriend>>? _initialListCompleter;

  late SocketClient _socketClient;

  @override
  FutureOr<IList<OnlineFriend>> build() {
    ref.onDispose(() {
      _socketSubscription?.cancel();
      _socketOpenSubscription?.cancel();
    });

    // Keep the last known list around for a little while, so that a friends
    // screen opened right after another one was left displays it immediately
    // instead of reloading from scratch.
    ref.cacheFor(const Duration(minutes: 1));

    // Friends belong to the account: watch auth to reload on sign in and out.
    final authUser = ref.watch(authControllerProvider);

    // Pauses friend event processing while no screen is watching, and picks it
    // back up when one does. The last known list is kept meanwhile.
    ref.onCancel(() {
      _socketSubscription?.cancel();
      _socketOpenSubscription?.cancel();
      _socketSubscription = null;
      _socketOpenSubscription = null;
    });
    ref.onResume(_subscribeAndRequest);

    _socketClient = _socketPool.open(Uri(path: kDefaultSocketRoute));

    // The server never answers the list request for an anonymous user: expose an
    // empty list right away instead of staying in the loading state forever.
    if (authUser == null) {
      return const IListConst([]);
    }

    _subscribeAndRequest();

    // Wait for the first server snapshot before exposing data. Returning an
    // empty list here would have screens briefly display "0 friends online";
    // they already know how to render the loading state instead.
    final completer = Completer<IList<OnlineFriend>>();
    _initialListCompleter = completer;
    return completer.future;
  }

  void _handleSocketTopic(SocketEvent event) {
    if (!ref.mounted) return;

    if (event.topic == 'following_onlines') {
      final friends = _parseFriendsList(event);
      final completer = _initialListCompleter;
      if (completer != null) {
        // Riverpod sets the state from the build future once it resolves.
        completer.complete(friends);
        _initialListCompleter = null;
      } else {
        state = AsyncValue.data(friends);
      }
      return;
    }

    // Presence changes are ignored until the first snapshot arrives: the server
    // already accounts for them in it.
    if (_initialListCompleter != null) return;

    final currentList = state.value ?? const IListConst([]);

    switch (event.topic) {
      case 'following_enters':
        final patronColor = event.json?['patronColor'] as int?;
        final user = _parseFriend(event.data.toString(), patronColor);
        final playing = event.json?['playing'] as bool? ?? false;
        state = AsyncValue.data(currentList.add((user: user, playing: playing)));

      case 'following_leaves':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(currentList.removeWhere((v) => v.user.id == data.id));

      case 'following_playing':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(
          currentList
              .map((v) => v.user.id == data.id ? (user: v.user, playing: true) : v)
              .toIList(),
        );

      case 'following_stopped_playing':
        final data = _parseFriend(event.data.toString());
        state = AsyncValue.data(
          currentList
              .map((v) => v.user.id == data.id ? (user: v.user, playing: false) : v)
              .toIList(),
        );
    }
  }

  /// (Re)subscribes to friend events and asks the server for a fresh list.
  void _subscribeAndRequest() {
    // The pool disposes clients that nobody listens to, so the one captured when
    // the provider built may be gone.
    if (_socketClient.isDisposed) {
      _socketClient = _socketPool.open(Uri(path: kDefaultSocketRoute));
    }

    _socketSubscription ??= _socketClient.stream.listen(_handleSocketTopic);
    _socketOpenSubscription ??= _socketClient.connectedStream.listen((_) {
      if (!ref.mounted) return;
      _socketClient.send('following_onlines', null);
    });

    if (!_socketClient.isActive) {
      // (Re)connecting fires the connected stream listener above, which asks
      // for the list.
      _socketClient.connect();
    } else if (_initialListCompleter == null) {
      // The build already asked for the initial list.
      _socketClient.send('following_onlines', null);
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
      final patronColor = friends.length == patronColors.length ? patronColors[i] as int? : null;
      final user = _parseFriend(
        v.toString(),
        // patron colors here being sent as 0 when the user is not a patron
        patronColor != null && patronColor > 0 ? patronColor : null,
      );
      final isPlaying = playing.contains(user.id.toString());
      return (user: user, playing: isPlaying);
    }).toIList();
  }
}
