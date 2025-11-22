import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_list_tile.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_search_screen.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/broadcast/search') {
    return switch (request.url.queryParameters['q']) {
      'world championship' => mockResponse(
        nonEmptyResponse,
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
      'azerty' => mockResponse(emptyResponse, 200),
      _ => throw 'Not implemented',
    };
  }
  return mockResponse('', 404);
});

void main() {
  group('BroadcastSearchScreen', () {
    testWidgets('should see search results', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastSearchScreen(),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      final textFieldFinder = find.byType(SearchBar);

      await tester.enterText(textFieldFinder, 'world championship');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.byType(BroadcastListTile), findsAtLeast(1));
    });

    testWidgets('should see "no result" when search finds nothing', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastSearchScreen(),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(client, ref),
          ),
        },
      );

      await tester.pumpWidget(app);

      final textFieldFinder = find.byType(SearchBar);

      await tester.enterText(textFieldFinder, 'azerty');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.text('No results'), findsOneWidget);
    });
  });
}

const nonEmptyResponse = '''
{
  "currentPage": 1,
  "maxPerPage": 24,
  "currentPageResults": [
    {
      "tour": {
        "id": "238ze7J9",
        "name": "FIDE Women’s World Chess Championship 2025",
        "slug": "fide-womens-world-chess-championship-2025",
        "info": {
          "format": "12-game Match",
          "website": "https://womenworldchampionship2025.fide.com/",
          "players": "Ju Wenjun vs Tan Zhongyi",
          "location": "Shanghai & Chongqing, China",
          "tc": "90 min / 40 moves + 30 min + 30 sec / move",
          "fideTc": "standard",
          "timeZone": "Asia/Shanghai"
        },
        "createdAt": 1742172004819,
        "url": "https://lichess.org/broadcast/fide-womens-world-chess-championship-2025/238ze7J9",
        "tier": 5,
        "dates": [
          1743663600000,
          1744786800000
        ],
        "image": "https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:238ze7J9:2ahE51BP.webp&w=800&sig=016685102f88a4e401c9ee983bae246eb17b2d8f"
      },
      "round": {
        "id": "pDPC5ZRh",
        "name": "Chongqing | Game 9",
        "slug": "chongqing--game-9",
        "createdAt": 1742173874118,
        "finishedAt": 1744794350164,
        "finished": true,
        "startsAt": 1744786800000,
        "url": "https://lichess.org/broadcast/fide-womens-world-chess-championship-2025/chongqing--game-9/pDPC5ZRh"
      }
    }
  ],
  "previousPage": null,
  "nextPage": null
}
''';

const emptyResponse = '''
{
  "currentPage": 1,
  "maxPerPage": 24,
  "currentPageResults": [],
  "previousPage": null,
  "nextPage": null
}
''';
