import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/network/http.dart';
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
