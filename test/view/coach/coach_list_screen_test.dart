import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/coach/coach_list_screen.dart';
import 'package:lichess_mobile/src/view/coach/coach_list_tile.dart';
import 'package:lichess_mobile/src/view/coach/coach_picture.dart';
import 'package:material_ui/material_ui.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _listResponse = '''
{
  "currentPage": 1,
  "maxPerPage": 10,
  "currentPageResults": [
    {
      "coach": {
        "id": "toniaa",
        "listed": true,
        "available": true,
        "profile": {"headline": "Learn chess the fun way", "hourlyRate": "25 EUR"},
        "picture": "https://example.com/toniaa.webp",
        "nbReviews": 12,
        "user": {"rating": 2434, "seenAt": 1760000000000},
        "languages": ["el-GR", "en-US"],
        "createdAt": 1650000000000,
        "updatedAt": 1750000000000
      },
      "user": {"id": "toniaa", "name": "toniaa", "title": "WFM"}
    },
    {
      "coach": {
        "id": "coach2",
        "listed": true,
        "available": false,
        "profile": {"headline": null, "hourlyRate": null},
        "picture": null,
        "nbReviews": 0,
        "user": {"rating": 2200, "seenAt": 1760000000000},
        "languages": ["en-US"],
        "createdAt": 1650000000000,
        "updatedAt": 1750000000000
      },
      "user": {"id": "coach2", "name": "coach2"}
    }
  ],
  "previousPage": null,
  "nextPage": null,
  "nbResults": 2,
  "nbPages": 1,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": ["el-GR", "en-US"],
  "countries": [{"code": "GR", "name": "Greece"}]
}
''';

const _profileResponse = '''
{
  "coach": {
    "id": "toniaa",
    "listed": true,
    "available": true,
    "profile": {
      "headline": "Learn chess the fun way",
      "hourlyRate": "25 EUR",
      "description": "I teach chess for a living",
      "playingExperience": null,
      "teachingExperience": null,
      "otherExperience": null,
      "skills": null,
      "methodology": null,
      "youtubeVideos": null,
      "youtubeChannel": null,
      "publicStudies": null
    },
    "picture": "https://example.com/toniaa.webp",
    "nbReviews": 12,
    "user": {"rating": 2434, "seenAt": 1760000000000},
    "languages": ["el-GR", "en-US"],
    "createdAt": 1650000000000,
    "updatedAt": 1750000000000
  },
  "user": {"id": "toniaa", "name": "toniaa", "title": "WFM"}
}
''';

void main() {
  group('CoachListScreen', () {
    testWidgets('shows coaches with a 1:1 picture on the left side', (tester) async {
      final client = MockClient((request) async {
        if (request.url.path == '/coach/all/all/login') {
          return http.Response(_listResponse, 200);
        }
        return http.Response('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const CoachListScreen(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(CoachListTile), findsNWidgets(2));

      final aspectRatios = tester.widgetList<AspectRatio>(
        find.descendant(of: find.byType(CoachPicture), matching: find.byType(AspectRatio)),
      );
      expect(aspectRatios, hasLength(2));
      expect(aspectRatios.every((ratio) => ratio.aspectRatio == 1.0), isTrue);

      final tileRect = tester.getRect(find.byType(CoachListTile).first);
      final pictureRect = tester.getRect(find.byType(CoachPicture).first);
      expect(pictureRect.left, tileRect.left + 16.0);
      expect(pictureRect.width, pictureRect.height);
      expect(pictureRect.center.dx, lessThan(tileRect.center.dx));
    });

    testWidgets('tapping a coach opens the profile', (tester) async {
      final client = MockClient((request) async {
        if (request.url.path == '/coach/all/all/login') {
          return http.Response(_listResponse, 200);
        }
        if (request.url.path == '/coach/toniaa') {
          return http.Response(_profileResponse, 200);
        }
        return http.Response('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const CoachListScreen(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CoachListTile).first);
      await tester.pumpAndSettle();

      expect(find.text('About me'), findsOneWidget);
      expect(find.text('I teach chess for a living'), findsOneWidget);
      expect(find.text('Learn chess the fun way'), findsOneWidget);
    });

    testWidgets('changing the sort filter refetches with the new order', (tester) async {
      final requestedOrders = <String?>[];
      final client = MockClient((request) async {
        if (request.url.path.startsWith('/coach/')) {
          requestedOrders.add(request.url.pathSegments[3]);
          return http.Response(_listResponse, 200);
        }
        return http.Response('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const CoachListScreen(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(findByTooltip('Filters'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lichess rating'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(requestedOrders, ['login', 'rating']);
    });

    testWidgets('failed load shows a blue refresh icon next to retry', (tester) async {
      var requestCount = 0;
      final client = MockClient((request) async {
        requestCount++;
        return http.Response('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const CoachListScreen(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.refresh));
      expect(icon.color, ColorScheme.of(tester.element(find.byIcon(Icons.refresh))).primary);
      expect(
        tester.getCenter(find.byIcon(Icons.refresh)).dx,
        lessThan(tester.getCenter(find.text('Retry')).dx),
      );

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(requestCount, greaterThanOrEqualTo(2));
    });

    testWidgets('learn tab shows a Coaches entry', (tester) async {
      final client = MockClient((request) async {
        return http.Response('', 404);
      });

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

      expect(find.text('Coaches'), findsOneWidget);
    });
  });
}
