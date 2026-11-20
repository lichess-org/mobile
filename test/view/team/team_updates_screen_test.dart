import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/team/team.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/team/team_channel_screen.dart';
import 'package:lichess_mobile/src/view/team/team_updates_screen.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/team.dart';
import 'package:material_ui/material_ui.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  const allUpdatesJson = '''
  {
    "byTeam": [
      { "last": 1785681992878, "team": { "id": "lichess-chess960", "name": "Lichess Chess960" }, "unread": 2 },
      { "last": 1785594732863, "team": { "flair": "objects.hammer-and-wrench", "id": "coders", "name": "Coders" }, "unread": 1 }
    ],
    "updates": {
      "currentPage": 1,
      "maxPerPage": 6,
      "nbPages": 1,
      "nbResults": 2,
      "nextPage": null,
      "previousPage": null,
      "currentPageResults": [
        {
          "msg": {
            "id": "msg1",
            "date": 1785681992878,
            "sender": {
              "id": "thibault",
              "name": "thibault",
              "flair": "nature.seedling"
            },
            "team": { "id": "lichess-chess960", "name": "Lichess Chess960" },
            "text": "Hello **world** from chess960"
          },
          "seen": true
        },
        {
          "msg": {
            "id": "msg2",
            "date": 1785594732863,
            "sender": {
              "id": "ornicar",
              "name": "ornicar"
            },
            "team": { "id": "coders", "name": "Coders" },
            "text": "Coders update with [link](https://lichess.org/tournament)"
          },
          "seen": false
        }
      ]
    }
  }
  ''';

  const singleTeamUpdatesJson = '''
  {
    "team": { "id": "coders", "name": "Coders", "flair": "objects.hammer-and-wrench" },
    "subscribed": true,
    "byTeam": [
      { "last": 1785594732863, "team": { "id": "coders", "name": "Coders" }, "unread": 0 }
    ],
    "updates": {
      "currentPage": 1,
      "maxPerPage": 6,
      "nbPages": 1,
      "nbResults": 1,
      "nextPage": null,
      "previousPage": null,
      "currentPageResults": [
        {
          "msg": {
            "id": "msg2",
            "date": 1785594732863,
            "sender": {
              "id": "ornicar",
              "name": "ornicar"
            },
            "team": { "id": "coders", "name": "Coders" },
            "text": "Coders dedicated update"
          },
          "seen": true
        }
      ]
    }
  }
  ''';

  group('TeamFullNameWidget', () {
    testWidgets('renders team name and flair in text span', (WidgetTester tester) async {
      const team = LightTeam(
        id: TeamId('test-team'),
        name: 'Test Team Name',
        flair: 'objects.hammer-and-wrench',
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const Scaffold(body: TeamFullNameWidget(team: team)),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textSpan, isNotNull);
      expect(textWidget.textSpan!.toPlainText(), contains('Test Team Name'));
      expect(find.byType(HttpNetworkImageWidget), findsOneWidget);
    });
  });

  group('TeamUpdatesScreen', () {
    testWidgets('displays team channels without All updates and resets unread when going back', (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/team/updates') {
          return mockResponse(allUpdatesJson, 200);
        }
        if (request.url.path == '/team/updates/coders') {
          return mockResponse(singleTeamUpdatesJson, 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TeamUpdatesScreen(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Team updates'), findsOneWidget);

      // Verify NO "All updates" channel exists
      expect(find.text('All updates'), findsNothing);

      // Channel items
      expect(find.textContaining('Lichess Chess960'), findsOneWidget);
      expect(find.textContaining('Coders'), findsOneWidget);

      // Leading flair image is rendered for Coders team in the channel tile
      expect(find.byType(HttpNetworkImageWidget), findsAtLeastNWidgets(1));

      // Tap on the Coders channel to show its messages
      await tester.tap(find.textContaining('Coders'));
      await tester.pumpAndSettle();

      // Inside the channel
      expect(find.textContaining('Coders dedicated update'), findsOneWidget);
      expect(find.byType(MarkdownBody), findsOneWidget);
      expect(find.text('ornicar'), findsOneWidget);

      // Verify username and timeago are in the same Row
      final usernameRow = find.ancestor(of: find.text('ornicar'), matching: find.byType(Row)).first;
      expect(usernameRow, findsOneWidget);

      // Go back
      final navigator = Navigator.of(tester.element(find.byType(TeamChannelScreen)));
      navigator.pop();
      await tester.pumpAndSettle();

      // Back on TeamUpdatesScreen
      expect(find.text('Team updates'), findsOneWidget);
    });

    testWidgets('paginates on scroll without duplicating requests', (WidgetTester tester) async {
      int page2Requests = 0;
      const channelPage1Json = '''
      {
        "team": { "id": "coders", "name": "Coders" },
        "subscribed": true,
        "byTeam": [],
        "updates": {
          "currentPage": 1,
          "maxPerPage": 6,
          "nbPages": 2,
          "nbResults": 7,
          "nextPage": 2,
          "previousPage": null,
          "currentPageResults": [
            { "msg": { "id": "msg1", "date": 1785594732863, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u1", "name": "user1" }, "text": "Item 1 with a lot of description text to make the card tall and ensure scrolling is required\\nLine 2\\nLine 3" }, "seen": true },
            { "msg": { "id": "msg2", "date": 1785594732862, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u2", "name": "user2" }, "text": "Item 2 with a lot of description text to make the card tall and ensure scrolling is required\\nLine 2\\nLine 3" }, "seen": true },
            { "msg": { "id": "msg3", "date": 1785594732861, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u3", "name": "user3" }, "text": "Item 3 with a lot of description text to make the card tall and ensure scrolling is required\\nLine 2\\nLine 3" }, "seen": true },
            { "msg": { "id": "msg4", "date": 1785594732860, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u4", "name": "user4" }, "text": "Item 4 with a lot of description text to make the card tall and ensure scrolling is required\\nLine 2\\nLine 3" }, "seen": true },
            { "msg": { "id": "msg5", "date": 1785594732859, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u5", "name": "user5" }, "text": "Item 5 with a lot of description text to make the card tall and ensure scrolling is required\\nLine 2\\nLine 3" }, "seen": true },
            { "msg": { "id": "msg6", "date": 1785594732858, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u6", "name": "user6" }, "text": "Item 6 with a lot of description text to make the card tall and ensure scrolling is required\\nLine 2\\nLine 3" }, "seen": true }
          ]
        }
      }
      ''';

      const channelPage2Json = '''
      {
        "team": { "id": "coders", "name": "Coders" },
        "subscribed": true,
        "byTeam": [],
        "updates": {
          "currentPage": 2,
          "maxPerPage": 6,
          "nbPages": 2,
          "nbResults": 7,
          "nextPage": null,
          "previousPage": 1,
          "currentPageResults": [
            { "msg": { "id": "msg7", "date": 1785594732850, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u7", "name": "user7" }, "text": "Item 7 (Page 2)" }, "seen": true }
          ]
        }
      }
      ''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/team/updates/coders') {
          if (request.url.queryParameters['page'] == '2') {
            page2Requests++;
            return mockResponse(channelPage2Json, 200);
          }
          return mockResponse(channelPage1Json, 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TeamChannelScreen(teamId: TeamId('coders')),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Item 1'), findsOneWidget);
      expect(find.textContaining('Item 2'), findsOneWidget);
      expect(page2Requests, 0);

      // Scroll down to trigger pagination
      await tester.drag(find.byType(ListView), const Offset(0, -250));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Page 2 should be loaded exactly once
      expect(page2Requests, 1);

      // Scroll to bring page 2 item into view
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Item 7 (Page 2)'), findsOneWidget);

      // Subsequent scrolls should not make additional requests since nextPage is null
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(page2Requests, 1);
    });

    testWidgets(
      'loads next page automatically when not enough messages to fill the screen and removes spinner',
      (WidgetTester tester) async {
        int page2Requests = 0;
        const shortPage1Json = '''
        {
          "team": { "id": "coders", "name": "Coders" },
          "subscribed": true,
          "byTeam": [],
          "updates": {
            "currentPage": 1,
            "maxPerPage": 6,
            "nbPages": 2,
            "nbResults": 2,
            "nextPage": 2,
            "previousPage": null,
            "currentPageResults": [
              { "msg": { "id": "m1", "date": 1785594732863, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u1", "name": "u1" }, "text": "Short 1" }, "seen": true }
            ]
          }
        }
        ''';

        const shortPage2Json = '''
        {
          "team": { "id": "coders", "name": "Coders" },
          "subscribed": true,
          "byTeam": [],
          "updates": {
            "currentPage": 2,
            "maxPerPage": 6,
            "nbPages": 2,
            "nbResults": 2,
            "nextPage": null,
            "previousPage": 1,
            "currentPageResults": [
              { "msg": { "id": "m2", "date": 1785594732850, "team": { "id": "coders", "name": "Coders" }, "sender": { "id": "u2", "name": "u2" }, "text": "Short 2" }, "seen": true }
            ]
          }
        }
        ''';

        final mockClient = MockClient((request) {
          if (request.url.path == '/team/updates/coders') {
            if (request.url.queryParameters['page'] == '2') {
              page2Requests++;
              return mockResponse(shortPage2Json, 200);
            }
            return mockResponse(shortPage1Json, 200);
          }
          return mockResponse('', 404);
        });

        final app = await makeTestProviderScopeApp(
          tester,
          home: const TeamChannelScreen(teamId: TeamId('coders')),
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
              return FakeHttpClientFactory(() => mockClient);
            }),
          },
        );

        await tester.pumpWidget(app);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Because Short 1 did not fill the screen, TeamUpdateNextPageTile was immediately visible
        // and triggered page 2 automatically.
        expect(page2Requests, 1);
        expect(find.text('Short 1'), findsOneWidget);
        expect(find.text('Short 2'), findsOneWidget);

        // Page 2 has nextPage: null, so TeamUpdateNextPageTile is removed (no infinite spinner).
        expect(find.byType(TeamUpdateNextPageTile), findsNothing);
      },
    );
  });
}
