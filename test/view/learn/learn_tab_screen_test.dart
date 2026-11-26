import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/coach/coach_list_tile.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/server_outage_display.dart';

import '../../network/fake_http_client_factory.dart';
import '../../network/server_down_client.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Learn tab', () {
    testWidgets('shows the studies when the server is up', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(
              () => MockClient((request) {
                if (request.url.path == '/study/all/hot') {
                  return mockResponse(_hotStudiesResponse, 200);
                }
                return mockResponse('', 404);
              }),
            );
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.text('Coordinate training'), findsOneWidget);
      expect(find.text('Study'), findsOneWidget);
      expect(find.text('A hot study'), findsOneWidget);
      expect(find.byType(ServerOutageDisplay), findsNothing);
    });

    testWidgets('shows five coaches that match the full coaches list', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(
              () => MockClient((request) {
                if (request.url.path == '/study/all/hot') {
                  return mockResponse(_hotStudiesResponse, 200);
                }
                if (request.url.path == '/coach/all/all/login') {
                  return mockResponse(_coachesResponse(6), 200);
                }
                return mockResponse('', 404);
              }),
            );
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.byType(CoachListTile), findsNWidgets(5));
      final previewTiles = tester.widgetList<CoachListTile>(find.byType(CoachListTile)).toList();
      expect(previewTiles.map((tile) => tile.coach.user.name), [
        'Coach 1',
        'Coach 2',
        'Coach 3',
        'Coach 4',
        'Coach 5',
      ]);
      expect(find.text('1 EUR'), findsOneWidget);
      final previewTileHeights = [
        for (var i = 0; i < previewTiles.length; i++)
          tester.getSize(find.byType(CoachListTile).at(i)).height,
      ];
      expect(previewTileHeights.toSet(), {previewTileHeights.first});

      final coachesHeader = find.ancestor(
        of: find.text('Coaches'),
        matching: find.byType(ListSectionHeader),
      );
      await tester.ensureVisible(coachesHeader);
      await tester.tap(find.descendant(of: coachesHeader, matching: find.text('More')));
      await tester.pumpAndSettle();

      expect(find.byType(CoachListTile), findsNWidgets(6));
      final fullListTiles = tester.widgetList<CoachListTile>(find.byType(CoachListTile)).toList();
      expect(
        fullListTiles.take(5).map((tile) => tile.coach.user.name).toList(),
        previewTiles.map((tile) => tile.coach.user.name).toList(),
      );
      expect([
        for (var i = 0; i < previewTiles.length; i++)
          tester.getSize(find.byType(CoachListTile).at(i)).height,
      ], previewTileHeights);
    });

    testWidgets('outage replaces the studies but keeps coordinate training', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient());
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);
      // The study section is gone...
      expect(find.text('Study'), findsNothing);
      // ...but coordinate training and practice work offline and stay available.
      expect(find.text('Coordinate training'), findsOneWidget);
      expect(find.text('Practice'), findsOneWidget);
    });

    testWidgets('offline, the studies show they are not available', (tester) async {
      final app = await makeOfflineTestProviderScope(tester, child: const Application());

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.text('Study'), findsOneWidget);
      expect(find.text('Studies are not available offline.'), findsOneWidget);
      expect(find.byType(ServerOutageDisplay), findsNothing);
      expect(find.text('Coordinate training'), findsOneWidget);
    });

    testWidgets('pulling to refresh once the server is back restores the studies', (tester) async {
      var statusCode = 502;
      final client = serverDownClientWithStatus(() => statusCode);

      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);

      // The server comes back up.
      statusCode = 200;

      await tester.fling(find.text('Coordinate training'), const Offset(0.0, 300.0), 1000.0);
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsNothing);
      expect(find.text('Coordinate training'), findsOneWidget);
    });
  });
}

const _hotStudiesResponse = '''
{
  "paginator": {
    "currentPage": 1,
    "maxPerPage": 16,
    "currentPageResults": [
      {
        "id": "g26XbGpT",
        "name": "A hot study",
        "liked": false,
        "likes": 1,
        "updatedAt": 1723817543350,
        "owner": {"name": "HeySerginho", "id": "heyserginho"},
        "chapters": ["Chapter 1"],
        "topics": [],
        "visibility": "public",
        "members": [{"user": {"name": "HeySerginho", "id": "heyserginho"}, "role": "w"}]
      }
    ],
    "previousPage": null,
    "nextPage": null,
    "nbResults": 1,
    "nbPages": 1
  }
}
''';

String _coachesResponse(int count) => jsonEncode({
  'currentPageResults': [
    for (var i = 1; i <= count; i++)
      {
        'coach': {
          'id': 'coach$i',
          'listed': true,
          'available': true,
          'profile': {
            'headline': i == 1
                ? 'An exceptionally long chess coaching headline that takes up more than one line'
                : 'Chess coach $i',
            'hourlyRate': '$i EUR',
          },
          'picture': null,
          'nbReviews': 0,
          'user': {'rating': 1800 + i},
          'languages': ['en-US'],
        },
        'user': {'id': 'coach$i', 'name': 'Coach $i'},
      },
  ],
  'nextPage': null,
  'languages': ['en-US'],
  'countries': <Object>[],
});
