import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_list_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Tournament list screen', () {
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/tournament') {
        return mockResponse(kTournamentApiResponse, 200);
      }
      return mockResponse('', 404);
    });

    testWidgets('Displays tournament list', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentListScreen(),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
      );
      await tester.pumpWidget(app);

      // Wait for tournament list to load
      await tester.pump();

      // Should display ongoing tournaments by default
      expect(find.text('<=2000 SuperBlitz Arena'), findsOneWidget);

      // Should not display unsupported variants
      expect(find.text('Hourly Crazyhouse Arena'), findsNothing);

      await tester.tap(find.text('Completed'));
      // Wait for tab switch animation
      await tester.pumpAndSettle();
      expect(find.text('Hourly Bullet Arena'), findsOneWidget);

      await tester.tap(find.text('Upcoming'));
      // Wait for tab switch animation
      await tester.pumpAndSettle();
      expect(find.text('Hourly UltraBullet Arena'), findsOneWidget);
    });
  });
}

// curl -X GET 'https://lichess.org/api/tournament' -H "Accept: application/json" 2> /dev/null | jq | sed 's/≤/<=/g'
const kTournamentApiResponse = '''
{
  "created": [
    {
      "id": "xpUhjARA",
      "createdBy": "lichess",
      "system": "arena",
      "minutes": 27,
      "clock": {
        "limit": 15,
        "increment": 0
      },
      "rated": true,
      "fullName": "Hourly UltraBullet Arena",
      "nbPlayers": 1,
      "variant": {
        "key": "standard",
        "short": "Std",
        "name": "Standard"
      },
      "startsAt": 1741595400000,
      "finishesAt": 1741597020000,
      "status": 10,
      "perf": {
        "key": "ultraBullet",
        "name": "UltraBullet",
        "position": 4,
        "icon": "{"
      },
      "secondsToStart": 1075,
      "schedule": {
        "freq": "hourly",
        "speed": "ultraBullet"
      }
    }
  ],
  "started": [
    {
      "id": "JX6S5Xjz",
      "createdBy": "lichess",
      "system": "arena",
      "minutes": 57,
      "clock": {
        "limit": 180,
        "increment": 0
      },
      "rated": true,
      "fullName": "<=2000 SuperBlitz Arena",
      "nbPlayers": 252,
      "variant": {
        "key": "standard",
        "short": "Std",
        "name": "Standard"
      },
      "startsAt": 1741593600000,
      "finishesAt": 1741597020000,
      "status": 20,
      "perf": {
        "key": "blitz",
        "name": "Blitz",
        "position": 1,
        "icon": ")"
      },
      "hasMaxRating": true,
      "maxRating": {
        "rating": 2000
      },
      "minRatedGames": {
        "nb": 20
      },
      "schedule": {
        "freq": "hourly",
        "speed": "superBlitz"
      }
    },
    {
      "id": "agTCjeIk",
      "createdBy": "lichess",
      "system": "arena",
      "minutes": 27,
      "clock": {
        "limit": 60,
        "increment": 0
      },
      "rated": true,
      "fullName": "Hourly Crazyhouse Arena",
      "nbPlayers": 34,
      "variant": {
        "key": "crazyhouse",
        "short": "Crazy",
        "name": "Crazyhouse"
      },
      "startsAt": 1741593602500,
      "finishesAt": 1741595222500,
      "status": 20,
      "perf": {
        "key": "crazyhouse",
        "name": "Crazyhouse",
        "position": 5
      },
      "schedule": {
        "freq": "hourly",
        "speed": "bullet"
      }
    }
  ],
  "finished": [
    {
      "id": "cQMTzBpL",
      "createdBy": "lichess",
      "system": "arena",
      "minutes": 27,
      "clock": {
        "limit": 60,
        "increment": 0
      },
      "rated": true,
      "fullName": "Hourly Bullet Arena",
      "nbPlayers": 216,
      "variant": {
        "key": "standard",
        "short": "Std",
        "name": "Standard"
      },
      "startsAt": 1741591820000,
      "finishesAt": 1741593440000,
      "status": 30,
      "perf": {
        "key": "bullet",
        "name": "Bullet",
        "position": 0,
        "icon": "T"
      },
      "minRatedGames": {
        "nb": 20
      },
      "schedule": {
        "freq": "hourly",
        "speed": "bullet"
      },
      "winner": {
        "name": "Kurald_Galain",
        "patron": true,
        "id": "kurald_galain"
      }
    }
  ]
}
''';
