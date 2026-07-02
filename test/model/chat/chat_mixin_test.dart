import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/chat/chat_mixin.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart' show SoundTheme;
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';

import '../../network/fake_http_client_factory.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';

// A test [ChatMixinState] holding the chat state and the enabled flag.
class _FakeChatState with ChatMixinState {
  const _FakeChatState({required this.chatState, required this.chatEnabled});

  @override
  final ChatState? chatState;

  @override
  final bool chatEnabled;

  _FakeChatState copyWith({ChatState? chatState, bool? chatEnabled}) => _FakeChatState(
    chatState: chatState ?? this.chatState,
    chatEnabled: chatEnabled ?? this.chatEnabled,
  );
}

// A minimal notifier that mixes in [ChatMixin] so its logic can be exercised in
// isolation. Test helpers expose the protected members.
class _TestChatNotifier extends AsyncNotifier<_FakeChatState> with ChatMixin<_FakeChatState> {
  _TestChatNotifier({required this.initialData, required this.isPublic, required this.enabled});

  final ChatData? initialData;
  final bool isPublic;
  final bool enabled;

  @override
  StringId get chatId => const StringId('test-chat-id');

  @override
  String get chatReportResource => 'test/resource';

  @override
  bool get chatIsPublic => isPublic;

  @override
  Future<_FakeChatState> build() async {
    final chatState = await initChat(initialData);
    return _FakeChatState(chatState: chatState, chatEnabled: enabled);
  }

  @override
  void updateChatState(ChatState newState) {
    state = AsyncData(state.requireValue.copyWith(chatState: newState));
  }

  // Test-only wrappers around protected members (allowed from the subclass).
  void dispatch(SocketEvent event) => handleSocketEvent(event);
}

// Records played sounds so the unread-notification behavior can be asserted.
class _RecordingSoundService implements SoundService {
  final List<Sound> played = [];

  @override
  Future<void> play(Sound sound, {double? volume}) async {
    played.add(sound);
  }

  @override
  Future<void> playCaptureSound(dynamic variant, {double? volume}) async {}

  @override
  Future<void> changeTheme(SoundTheme theme, {bool playSound = false}) async {}

  @override
  Future<void> release() async {}
}

AsyncNotifierProvider<_TestChatNotifier, _FakeChatState> _makeProvider({
  ChatData? initialData,
  bool isPublic = false,
  bool enabled = true,
}) {
  return AsyncNotifierProvider<_TestChatNotifier, _FakeChatState>(
    () => _TestChatNotifier(initialData: initialData, isPublic: isPublic, enabled: enabled),
  );
}

ChatMessage _msg(String text, {String? username, bool troll = false, bool deleted = false}) =>
    ChatMessage(message: text, username: username, troll: troll, deleted: deleted);

// Builds the raw json of an incoming 'message' socket event payload.
Map<String, dynamic> _msgData(
  String text, {
  String? username,
  bool troll = false,
  bool deleted = false,
}) => {'t': text, 'u': username, 'r': troll, 'd': deleted};

ChatData _chatData(List<ChatMessage> lines, {bool writeable = true}) =>
    (lines: lines.toIList(), writeable: writeable);

// Warms [kidModeProvider] so that its synchronous `.value` is available (the
// socket handler reads it synchronously and bails while it is still loading).
Future<void> _warmKidMode(ProviderContainer container) async {
  container.listen(kidModeProvider, (_, _) {});
  await container.read(kidModeProvider.future);
}

void main() {
  group('ChatMixin.initChat', () {
    test('returns null when there is no initial chat data', () async {
      final container = await makeContainer();
      final provider = _makeProvider();
      final state = await container.read(provider.future);
      expect(state.chatState, isNull);
    });

    test('keeps normal messages and computes unread count from scratch', () async {
      final container = await makeContainer();
      final provider = _makeProvider(
        initialData: _chatData([_msg('hello', username: 'alice'), _msg('hi', username: 'bob')]),
      );
      final state = await container.read(provider.future);
      expect(state.chatState!.messages.length, 2);
      expect(state.chatState!.unreadMessages, 2);
    });

    test('filters out deleted, spam and troll (from others) messages', () async {
      final container = await makeContainer();
      final provider = _makeProvider(
        initialData: _chatData([
          _msg('legit', username: 'alice'),
          _msg('removed', username: 'bob', deleted: true),
          _msg('troll talk', username: 'eve', troll: true),
          _msg('join my team please', username: 'spammer'),
        ]),
      );
      final state = await container.read(provider.future);
      expect(state.chatState!.messages.map((m) => m.message), ['legit']);
      expect(state.chatState!.unreadMessages, 1);
    });

    test('keeps troll messages authored by the current user', () async {
      final container = await makeContainer(
        authUser: const AuthUser(
          token: 'token',
          user: LightUser(id: UserId('myname'), name: 'MyName'),
        ),
      );
      final provider = _makeProvider(
        initialData: _chatData([
          _msg('my own troll msg', username: 'MyName', troll: true),
          _msg('other troll', username: 'eve', troll: true),
        ]),
      );
      final state = await container.read(provider.future);
      expect(state.chatState!.messages.map((m) => m.message), ['my own troll msg']);
    });
  });

  group('ChatMixin.handleSocketEvent', () {
    test('appends an incoming message and increments the unread count', () async {
      final container = await makeContainer();
      await _warmKidMode(container);
      final provider = _makeProvider(initialData: _chatData([_msg('hello', username: 'alice')]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.dispatch(
        SocketEvent(
          topic: 'message',
          data: _msgData('hi there', username: 'bob'),
        ),
      );

      final state = container.read(provider).requireValue;
      expect(state.chatState!.messages.map((m) => m.message), ['hello', 'hi there']);
      expect(state.chatState!.unreadMessages, 2);
    });

    test('plays a notification sound for private chats on a new message', () async {
      final sound = _RecordingSoundService();
      final container = await makeContainer(
        overrides: {soundServiceProvider: soundServiceProvider.overrideWithValue(sound)},
      );
      await _warmKidMode(container);
      final provider = _makeProvider(initialData: _chatData([]), isPublic: false);
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.dispatch(
        SocketEvent(
          topic: 'message',
          data: _msgData('gg', username: 'bob'),
        ),
      );

      expect(sound.played, [Sound.confirmation]);
    });

    test('does not play a notification sound for public chats', () async {
      final sound = _RecordingSoundService();
      final container = await makeContainer(
        overrides: {soundServiceProvider: soundServiceProvider.overrideWithValue(sound)},
      );
      await _warmKidMode(container);
      final provider = _makeProvider(initialData: _chatData([]), isPublic: true);
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.dispatch(
        SocketEvent(
          topic: 'message',
          data: _msgData('gg', username: 'bob'),
        ),
      );

      expect(sound.played, isEmpty);
    });

    test('does not increment unread for a filtered (deleted) incoming message', () async {
      final container = await makeContainer();
      await _warmKidMode(container);
      final provider = _makeProvider(initialData: _chatData([_msg('hello', username: 'alice')]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.dispatch(
        SocketEvent(
          topic: 'message',
          data: _msgData('spam', username: 'eve', deleted: true),
        ),
      );

      final state = container.read(provider).requireValue;
      expect(state.chatState!.messages.length, 1);
      expect(state.chatState!.unreadMessages, 1);
    });

    test('ignores the event when chat is not initialized (null chat state)', () async {
      final container = await makeContainer();
      await _warmKidMode(container);
      final provider = _makeProvider();
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      // Must not throw even though chatState is null.
      notifier.dispatch(
        SocketEvent(
          topic: 'message',
          data: _msgData('hi', username: 'bob'),
        ),
      );

      expect(container.read(provider).requireValue.chatState, isNull);
    });

    test('ignores the event when chat is disabled', () async {
      final container = await makeContainer();
      await _warmKidMode(container);
      final provider = _makeProvider(initialData: _chatData([]), enabled: false);
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.dispatch(
        SocketEvent(
          topic: 'message',
          data: _msgData('hi', username: 'bob'),
        ),
      );

      expect(container.read(provider).requireValue.chatState!.messages, isEmpty);
    });

    test('ignores the event in kid mode', () async {
      final container = await makeContainer(
        overrides: {kidModeProvider: kidModeProvider.overrideWith((ref) => true)},
      );
      await _warmKidMode(container);
      final provider = _makeProvider(initialData: _chatData([]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.dispatch(
        SocketEvent(
          topic: 'message',
          data: _msgData('hi', username: 'bob'),
        ),
      );

      expect(container.read(provider).requireValue.chatState!.messages, isEmpty);
    });

    test('ignores non-message topics', () async {
      final container = await makeContainer();
      await _warmKidMode(container);
      final provider = _makeProvider(initialData: _chatData([]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.dispatch(const SocketEvent(topic: 'crowd', data: {'foo': 'bar'}));

      expect(container.read(provider).requireValue.chatState!.messages, isEmpty);
    });
  });

  group('ChatMixin.markMessagesAsRead', () {
    test('resets the unread count to zero', () async {
      final container = await makeContainer();
      final provider = _makeProvider(
        initialData: _chatData([_msg('a', username: 'alice'), _msg('b', username: 'bob')]),
      );
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);
      expect(container.read(provider).requireValue.chatState!.unreadMessages, 2);

      await notifier.markMessagesAsRead();

      expect(container.read(provider).requireValue.chatState!.unreadMessages, 0);
    });

    test('persists the read count so a fresh state starts with no unread', () async {
      final container = await makeContainer();
      final provider = _makeProvider(initialData: _chatData([_msg('a', username: 'alice')]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);
      await notifier.markMessagesAsRead();

      // A brand new notifier reading the same chat id should see no unread.
      final freshProvider = _makeProvider(initialData: _chatData([_msg('a', username: 'alice')]));
      final freshState = await container.read(freshProvider.future);
      expect(freshState.chatState!.unreadMessages, 0);
    });

    test('is a no-op when chat is not initialized', () async {
      final container = await makeContainer();
      final provider = _makeProvider();
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      // Must not throw.
      await notifier.markMessagesAsRead();

      expect(container.read(provider).requireValue.chatState, isNull);
    });
  });

  group('ChatMixin.setInputText', () {
    test('updates the input text', () async {
      final container = await makeContainer();
      final provider = _makeProvider(initialData: _chatData([]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.setInputText('draw?');

      expect(container.read(provider).requireValue.chatState!.inputText, 'draw?');
    });

    test('is a no-op when chat is not initialized', () async {
      final container = await makeContainer();
      final provider = _makeProvider();
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      notifier.setInputText('draw?');

      expect(container.read(provider).requireValue.chatState, isNull);
    });
  });

  group('ChatMixin.postMessage', () {
    test('sends a talk message over the current socket', () async {
      final fakeChannel = FakeWebSocketChannel(Uri(path: kDefaultSocketRoute));
      final container = await makeContainer(
        overrides: {
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeChannel);
          }),
        },
      );
      final client = container.read(socketPoolProvider).open(Uri(path: kDefaultSocketRoute));
      await client.connect();

      final provider = _makeProvider(initialData: _chatData([]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      final sent = expectLater(
        fakeChannel.sentMessagesExceptPing,
        emitsThrough('{"t":"talk","d":"good game"}'),
      );
      notifier.postMessage('good game');
      await sent;
    });
  });

  group('ChatMixin.reportMessage', () {
    test('posts a flag report with the message details', () async {
      http.Request? captured;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(
              () => MockClient((request) async {
                captured = request;
                return http.Response('', 200);
              }),
            );
          }),
        },
      );
      final provider = _makeProvider(initialData: _chatData([]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      await notifier.reportMessage(_msg('bad words', username: 'eve'));

      expect(captured, isNotNull);
      expect(captured!.url.path, '/report/flag');
      expect(captured!.bodyFields['username'], 'eve');
      expect(captured!.bodyFields['resource'], 'test/resource');
      expect(captured!.bodyFields['text'], 'bad words');
    });

    test('throws when reporting a message without a username', () async {
      final container = await makeContainer();
      final provider = _makeProvider(initialData: _chatData([]));
      final notifier = container.read(provider.notifier);
      await container.read(provider.future);

      expect(notifier.reportMessage(_msg('anon')), throwsArgumentError);
    });
  });
}
