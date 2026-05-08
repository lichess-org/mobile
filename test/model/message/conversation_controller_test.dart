import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/message/conversation_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';

import '../../network/fake_http_client_factory.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';

const _userId = UserId('opponent');

// Minimal /inbox/{userId} response — not blocked, not a bot, postable.
const _inboxResponse = '''
{
  "me": {"name": "me", "id": "me"},
  "bot": false,
  "convo": {
    "user": {"name": "opponent", "id": "opponent"},
    "msgs": [],
    "postable": true
  }
}
''';

// /inbox response where the conversation is not postable.
// This happens when the contact has set their message preference to "Only existing conversations"
// and there is no prior conversation.
const _inboxNotPostableResponse = '''
{
  "me": {"name": "me", "id": "me"},
  "bot": false,
  "convo": {
    "user": {"name": "opponent", "id": "opponent"},
    "msgs": [],
    "postable": false
  }
}
''';

// /inbox response where the conversation is postable because a prior conversation already exists.
// When the contact has set their message preference to "Only existing conversations",
// posting is allowed if there are already messages.
const _inboxPostableWithExistingConvoResponse = '''
{
  "me": {"name": "me", "id": "me"},
  "bot": false,
  "convo": {
    "user": {"name": "opponent", "id": "opponent"},
    "msgs": [{"text": "hello", "user": "opponent", "date": 1621533013388}],
    "postable": true
  }
}
''';

// /inbox response for a bot account.
const _inboxBotResponse = '''
{
  "me": {"name": "me", "id": "me"},
  "bot": true,
  "convo": {
    "user": {"name": "opponent", "id": "opponent"},
    "msgs": [],
    "postable": false
  }
}
''';

// /api/user/{userId} response — user is not blocked.
const _userNotBlockedResponse = '''
{
  "id": "opponent",
  "username": "opponent",
  "blocking": false
}
''';

// /api/user/{userId} response — you have blocked this user.
const _userBlockedResponse = '''
{
  "id": "opponent",
  "username": "opponent",
  "blocking": true
}
''';

// /api/user/{userId} response — no blocking field (treated as not blocked).
const _userNoBlockingFieldResponse = '''
{
  "id": "opponent",
  "username": "opponent"
}
''';

Future<ProviderContainer> _makeContainer(String inboxJson, String userJson) {
  final mockClient = MockClient((request) {
    if (request.url.path == '/inbox/$_userId') {
      return mockResponse(inboxJson, 200);
    }
    if (request.url.path == '/api/user/$_userId') {
      return mockResponse(userJson, 200);
    }
    return mockResponse('', 200);
  });
  return makeContainer(
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(() => mockClient);
      }),
      webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith((ref) {
        return FakeWebSocketChannelFactory((uri) => FakeWebSocketChannel(uri));
      }),
    },
  );
}

void main() {
  group('ConversationController blocking logic', () {
    test('isBlocked is false for a normal user that is not blocked', () async {
      final container = await _makeContainer(_inboxResponse, _userNotBlockedResponse);
      container.listen(conversationControllerProvider(_userId), (_, _) {});
      final state = await container.read(conversationControllerProvider(_userId).future);
      expect(state.isBlocked, isFalse);
      expect(state.isBot, isFalse);
      expect(state.convo.postable, isTrue);
    });

    test('isBlocked is true when you have blocked the user', () async {
      final container = await _makeContainer(_inboxResponse, _userBlockedResponse);
      container.listen(conversationControllerProvider(_userId), (_, _) {});
      final state = await container.read(conversationControllerProvider(_userId).future);
      expect(state.isBlocked, isTrue);
    });

    test('isBlocked is false when blocking field is absent from user response', () async {
      final container = await _makeContainer(_inboxResponse, _userNoBlockingFieldResponse);
      container.listen(conversationControllerProvider(_userId), (_, _) {});
      final state = await container.read(conversationControllerProvider(_userId).future);
      expect(state.isBlocked, isFalse);
    });

    test('isBot is true for a bot account', () async {
      final container = await _makeContainer(_inboxBotResponse, _userNotBlockedResponse);
      container.listen(conversationControllerProvider(_userId), (_, _) {});
      final state = await container.read(conversationControllerProvider(_userId).future);
      expect(state.isBot, isTrue);
    });

    test('postable is false when contact does not accept new messages', () async {
      final container = await _makeContainer(_inboxNotPostableResponse, _userNotBlockedResponse);
      container.listen(conversationControllerProvider(_userId), (_, _) {});
      final state = await container.read(conversationControllerProvider(_userId).future);
      expect(state.convo.postable, isFalse);
      expect(state.isBlocked, isFalse);
      expect(state.isBot, isFalse);
    });

    test('postable is true when existing conversation allows further messages', () async {
      final container = await _makeContainer(
        _inboxPostableWithExistingConvoResponse,
        _userNotBlockedResponse,
      );
      container.listen(conversationControllerProvider(_userId), (_, _) {});
      final state = await container.read(conversationControllerProvider(_userId).future);
      expect(state.convo.postable, isTrue);
      expect(state.isBlocked, isFalse);
      expect(state.isBot, isFalse);
    });
  });
}
