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
  "coaches": [
    {
      "user": {"id": "toniaa", "name": "toniaa", "title": "WFM"},
      "rating": 2434,
      "languages": ["el-GR", "en-US"],
      "nbReviews": 12,
      "available": true,
      "listed": true,
      "headline": "Learn chess the fun way",
      "hourlyRate": "25 EUR",
      "picture": "https://example.com/toniaa.webp"
    },
    {
      "user": {"id": "coach2", "name": "coach2"},
      "rating": 2200,
      "languages": ["en-US"],
      "nbReviews": 0,
      "available": false,
      "listed": true
    }
  ],
  "page": 1,
  "nextPage": null,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": ["el-GR", "en-US"],
  "countries": [{"code": "GR", "name": "Greece"}]
}
''';

const _profileResponse = '''
{
  "user": {"id": "toniaa", "name": "toniaa", "title": "WFM"},
  "rating": 2434,
  "languages": ["el-GR", "en-US"],
  "nbReviews": 12,
  "available": true,
  "listed": true,
  "headline": "Learn chess the fun way",
  "hourlyRate": "25 EUR",
  "picture": "https://example.com/toniaa.webp",
  "youtubeVideos": [],
  "studies": [],
  "description": "I teach chess for a living",
  "playingExperience": null,
  "teachingExperience": null,
  "otherExperience": null,
  "skills": null,
  "methodology": null,
  "youtubeChannel": null
}
''';

void main() {
  group('CoachListScreen', () {
    testWidgets('shows coaches with a 1:1 picture on the left side', (tester) async {
      final client = MockClient((request) async {
        if (request.url.path == '/api/mobile/coach') {
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
        if (request.url.path == '/api/mobile/coach') {
          return http.Response(_listResponse, 200);
        }
        if (request.url.path == '/api/mobile/coach/toniaa') {
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
        if (request.url.path == '/api/mobile/coach') {
          requestedOrders.add(request.url.queryParameters['order']);
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
