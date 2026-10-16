import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../network/fake_http_client_factory.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _userId = UserId('opponent');
const _opponent = LightUser(id: _userId, name: 'opponent');

// One message carrying a link, which is what makes the bubble build a recognizer.
const _inboxWithLink = '''
{
  "me": {"name": "me", "id": "me"},
  "bot": false,
  "convo": {
    "user": {"name": "opponent", "id": "opponent"},
    "msgs": [
      {"text": "see https://example.com now", "user": "opponent", "date": 1621533013388}
    ],
    "postable": true
  }
}
''';

const _userResponse = '{"id":"opponent","username":"opponent","blocking":false}';

/// The recognizer of every tappable span under [span], paired with that span's text.
List<(String, GestureRecognizer)> _linksUnder(InlineSpan span) {
  final links = <(String, GestureRecognizer)>[];
  if (span is! TextSpan) return links;
  final recognizer = span.recognizer;
  if (recognizer != null) links.add((span.text ?? '', recognizer));
  for (final child in span.children ?? const <InlineSpan>[]) {
    links.addAll(_linksUnder(child));
  }
  return links;
}

/// The recognizer currently attached to the `example.com` link of the message bubble.
GestureRecognizer exampleLinkRecognizer(WidgetTester tester) {
  final links = <(String, GestureRecognizer)>[];
  for (final richText in tester.widgetList<RichText>(find.byType(RichText))) {
    links.addAll(_linksUnder(richText.text));
  }
  final link = links.where((entry) => entry.$1.contains('example.com'));
  expect(link, hasLength(1), reason: 'expected exactly one example.com link, got $links');
  return link.single.$2;
}

Future<Widget> _conversationApp(WidgetTester tester) {
  final mockClient = MockClient((request) {
    if (request.url.path == '/inbox/$_userId') {
      return mockResponse(_inboxWithLink, 200);
    }
    if (request.url.path == '/api/user/$_userId') {
      return mockResponse(_userResponse, 200);
    }
    return mockResponse('', 200);
  });

  return makeTestProviderScopeApp(
    tester,
    home: const ConversationScreen(user: _opponent),
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
  group('ConversationScreen message bubble', () {
    testWidgets('reuses the link recognizer when the contact starts typing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(await _conversationApp(tester));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      final before = exampleLinkRecognizer(tester);

      // The bubble does rebuild: the typing indicator changes the conversation state the whole
      // body watches. Only its text is unchanged, so the link must not be parsed again.
      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), ['{"t":"msgType","d":"opponent"}']);
      await tester.pump();
      await tester.pump();

      // Guards that the rebuild this test relies on actually happened.
      expect(find.text('opponent is typing...'), findsOneWidget);
      expect(exampleLinkRecognizer(tester), same(before));
    });
  });
}
