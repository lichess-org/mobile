import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/network/socket.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';
import '../auth/fake_auth_storage.dart';

void main() {
  final socketUri = Uri(path: kDefaultSocketRoute);

  test('stays in loading state until the server sends the first friends list', () async {
    final container = await makeContainer(authUser: fakeAuthUser);

    final client = container.read(socketPoolProvider).currentClient;
    // keep a listener so the provider stays subscribed and processes socket events
    container.listen(onlineFriendsProvider, (_, _) {});

    // the provider waits for the server instead of exposing an empty list
    expect(container.read(onlineFriendsProvider), isA<AsyncLoading<IList<OnlineFriend>>>());

    await client.firstConnection;

    // presence changes that happen before the first snapshot are ignored: the
    // server already accounts for them in it
    sendServerSocketMessages(socketUri, ['{"t": "following_enters", "d": "Bobby"}']);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(container.read(onlineFriendsProvider), isA<AsyncLoading<IList<OnlineFriend>>>());

    sendServerSocketMessages(socketUri, [
      '{"t": "following_onlines", "d": ["doody", "GM bobby"], "patronColors": [0, 5], "playing": ["doody"]}',
    ]);

    final friends = await container.read(onlineFriendsProvider.future);

    expect(friends.length, 2);
    expect(friends[0].user.name, 'doody');
    expect(friends[0].user.title, isNull);
    expect(friends[0].user.patronColor, isNull);
    expect(friends[0].playing, isTrue);
    expect(friends[1].user.name, 'bobby');
    expect(friends[1].user.title, 'GM');
    expect(friends[1].user.patronColor, 5);
    expect(friends[1].playing, isFalse);
  });

  test('a later snapshot replaces the state, and presence changes apply', () async {
    final container = await makeContainer(authUser: fakeAuthUser);

    final client = container.read(socketPoolProvider).currentClient;
    container.listen(onlineFriendsProvider, (_, _) {});
    await client.firstConnection;

    sendServerSocketMessages(socketUri, ['{"t": "following_onlines", "d": ["doody"]}']);
    IList<OnlineFriend> friends = await container.read(onlineFriendsProvider.future);
    expect(friends.map((f) => f.user.name), ['doody']);
    expect(friends.first.playing, isFalse);

    sendServerSocketMessages(socketUri, ['{"t": "following_playing", "d": "doody"}']);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(container.read(onlineFriendsProvider).value?.first.playing, isTrue);

    sendServerSocketMessages(socketUri, ['{"t": "following_onlines", "d": ["GM bobby"]}']);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    friends = container.read(onlineFriendsProvider).requireValue;
    expect(friends.map((f) => f.user.name), ['bobby']);
    expect(friends.first.playing, isFalse);
  });

  test('anonymous user gets an empty list right away, without asking the server', () async {
    final channelFactory = ListenableFakeWebSocketChannelFactory(createDefaultFakeWebSocketChannel);
    final outgoingMessages = channelFactory.outgoingMessages(socketUri);
    final sent = <dynamic>[];
    final subscription = outgoingMessages.listen(sent.add);

    final container = await makeContainer(
      overrides: {
        webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWithValue(
          channelFactory,
        ),
      },
    );

    final state = container.read(onlineFriendsProvider);

    expect(state.hasValue, isTrue);
    expect(state.value, isEmpty);

    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(sent, isEmpty);

    subscription.cancel();
  });
}
