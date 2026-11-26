import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/model/coach/youtube_channel.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/view/coach/coach_list_screen.dart';
import 'package:lichess_mobile/src/view/coach/coach_list_tile.dart';
import 'package:lichess_mobile/src/view/coach/coach_picture.dart';
import 'package:lichess_mobile/src/view/message/conversation_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

import '../../model/auth/fake_auth_storage.dart';
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

const _listPage1Response = '''
{
  "currentPage": 1,
  "maxPerPage": 1,
  "currentPageResults": [
    {
      "coach": {
        "id": "toniaa",
        "listed": true,
        "available": true,
        "profile": {"headline": "Learn chess the fun way", "hourlyRate": "25 EUR"},
        "picture": null,
        "nbReviews": 12,
        "user": {"rating": 2434, "seenAt": 1760000000000},
        "languages": ["en-US"],
        "createdAt": 1650000000000,
        "updatedAt": 1750000000000
      },
      "user": {"id": "toniaa", "name": "toniaa", "title": "WFM"}
    }
  ],
  "previousPage": null,
  "nextPage": 2,
  "nbResults": 2,
  "nbPages": 2,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": [],
  "countries": []
}
''';

const _listPage2Response = '''
{
  "currentPage": 2,
  "maxPerPage": 1,
  "currentPageResults": [
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
  "previousPage": 1,
  "nextPage": null,
  "nbResults": 2,
  "nbPages": 2,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": [],
  "countries": []
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
      "description": "I teach chess for a living\\r\\n\\r\\n",
      "playingExperience": null,
      "teachingExperience": null,
      "otherExperience": null,
      "skills": null,
      "methodology": null,
      "youtubeVideos": "https://www.youtube.com/watch?v=dQw4w9WgXcQ\\r\\nhttps://youtu.be/9bZkp7q19f0",
      "publicStudies": null
    },
    "picture": "https://example.com/toniaa.webp",
    "nbReviews": 12,
    "user": {"rating": 2434, "seenAt": 1760000000000},
    "languages": ["el-GR", "en-US"],
    "createdAt": 1650000000000,
    "updatedAt": 1750000000000
  },
  "user": {"id": "toniaa", "name": "toniaa", "title": "WFM", "patronColor": 5},
  "posts": [
    {
      "id": "1nH0b0kY",
      "title": "Chess sparring",
      "slug": "chess-sparring",
      "createdAt": 1750000000000,
      "url": "/@/toniaa/blog/chess-sparring/1nH0b0kY",
      "author": {"id": "toniaa", "name": "toniaa"}
    },
    {
      "id": "kQ2z9WpX",
      "title": "Endgame fundamentals",
      "slug": "endgame-fundamentals",
      "createdAt": 1740000000000,
      "url": "/@/toniaa/blog/endgame-fundamentals/kQ2z9WpX",
      "author": {"id": "toniaa", "name": "toniaa"},
      "image": "https://image.lichess.org/ublog/post/kQ2z9WpX.jpg"
    }
  ],
  "studies": [
    {
      "id": "ZalBgXT3",
      "name": "Rook endgames mastery",
      "liked": false,
      "likes": 12,
      "updatedAt": 1740000000000,
      "owner": {"id": "toniaa", "name": "toniaa"},
      "topics": [],
      "members": [],
      "chapters": ["Lucena position", "Philidor position"],
      "visibility": "public"
    },
    {
      "id": "qM9nVb2k",
      "name": "Opening principles",
      "liked": true,
      "likes": 34,
      "updatedAt": 1730000000000,
      "owner": {"id": "toniaa", "name": "toniaa"},
      "topics": [],
      "members": [],
      "chapters": ["Center control"],
      "flair": "lichess.bold",
      "visibility": "public"
    }
  ]
}
''';

const _profileChannelOnlyResponse = '''
{
  "coach": {
    "id": "toniaa",
    "listed": true,
    "available": true,
    "profile": {
      "headline": "Learn chess the fun way",
      "hourlyRate": "25 EUR",
      "youtubeChannel": "https://efour-davorrogic.hr/"
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

const _profileWithChannelResponse = '''
{
  "coach": {
    "id": "toniaa",
    "listed": true,
    "available": true,
    "profile": {
      "headline": "Learn chess the fun way",
      "hourlyRate": "25 EUR",
      "youtubeVideos": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "youtubeChannel": "https://www.youtube.com/@cleverqueen",
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

const _channelPageResponse = r'''
<html><head><title>Chess Sparring Academy - YouTube</title></head><body>
<script>ytInitialData = {"channelMetadataRenderer":{"title":"Chess Sparring Academy"},"header":{"c4TabbedHeaderRenderer":{"avatar":{"thumbnails":[{"url":"https:\/\/yt3.example.com\/avatar.jpg=s900"}]}}},"metadataParts":[{"text":{"content":"1.2K subscribers"},"accessibilityLabel":"1.2K subscribers"},{"text":{"content":"438 videos"}}],"delimiter":"\u2022"};</script>
</body></html>
''';

const _userResponse = '''
{
  "id": "toniaa",
  "username": "toniaa",
  "seenAt": 1760000000000,
  "perfs": {
    "bullet": {"games": 100, "rating": 2014, "rd": 58, "prog": 0},
    "blitz": {"games": 200, "rating": 2288, "rd": 86, "prog": 85},
    "rapid": {"games": 56, "rating": 2615, "rd": 233, "prog": 223, "prov": true}
  },
  "profile": {"fideRating": 2281, "location": "Bruxelles", "flag": "GR"}
}
''';

String _stressPageResponse(int page) {
  final nextPage = page < 20 ? page + 1 : null;
  return '''
{
  "currentPage": $page,
  "maxPerPage": 1,
  "currentPageResults": [
    {
      "coach": {
        "id": "coach$page",
        "listed": true,
        "available": true,
        "profile": {"headline": null, "hourlyRate": null},
        "picture": null,
        "nbReviews": 0,
        "user": {"rating": 2400, "seenAt": 1760000000000},
        "languages": ["en-US"],
        "createdAt": 1650000000000,
        "updatedAt": 1750000000000
      },
      "user": {"id": "coach$page", "name": "coach$page"}
    }
  ],
  "previousPage": null,
  "nextPage": $nextPage,
  "nbResults": 20,
  "nbPages": 20,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": [],
  "countries": []
}
''';
}

Future<void> closeFilterSheet(WidgetTester tester) async {
  Navigator.of(tester.element(find.byType(CoachListScreen)), rootNavigator: true).pop();
  await tester.pumpAndSettle();
}

void main() {
  group('CoachListScreen', () {
    testWidgets('rapid pagination never shows a coach twice', (tester) async {
      final requestedPages = <String?>[];
      final client = MockClient((request) async {
        if (request.url.path != '/coach/all/all/login') return http.Response('', 404);
        final page = request.url.queryParameters['page'];
        requestedPages.add(page);
        await Future<void>.delayed(const Duration(milliseconds: 5));
        return http.Response(_stressPageResponse(int.parse(page ?? '1')), 200);
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
      for (var i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        if (i % 10 == 0 && find.byType(CoachListTile).evaluate().isNotEmpty) {
          await tester.drag(find.byType(ListView).last, const Offset(0, -400));
        }
      }
      await tester.pumpAndSettle();

      final names = tester
          .widgetList<CoachListTile>(find.byType(CoachListTile))
          .map((tile) => tile.coach.user.name)
          .toList();
      expect(
        names.length,
        names.toSet().length,
        reason: 'duplicate rows: ${requestedPages.join(',')}',
      );
    });

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
      expect(tileRect.height, 100.0);
      expect(pictureRect.left, tileRect.left + 16.0);
      expect(pictureRect.width, 84.0);
      expect(pictureRect.height, 84.0);
      expect(pictureRect.center.dx, lessThan(tileRect.center.dx));
      expect(
        tester.getRect(find.byType(UserFullNameWidget).first).top,
        closeTo(pictureRect.top, 1.0),
      );
      expect(
        tester.getRect(find.text('Hourly rate: ').first).bottom,
        closeTo(pictureRect.bottom, 1.0),
      );
      expect(
        tester.widget<UserFullNameWidget>(find.byType(UserFullNameWidget).first).style,
        Styles.sectionTitle,
      );
    });

    testWidgets('full list shows location, languages, ratings and rate on separate lines', (
      tester,
    ) async {
      final client = MockClient((request) async {
        if (request.url.path == '/coach/all/all/login') {
          return http.Response(_listResponse, 200);
        }
        if (request.url.path == '/api/user/toniaa') {
          return http.Response(_userResponse, 200);
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

      final tile = find.byType(CoachListTile).first;
      expect(find.descendant(of: tile, matching: find.text('Bruxelles')), findsOneWidget);
      expect(find.descendant(of: tile, matching: find.text('Greece')), findsOneWidget);
      expect(find.descendant(of: tile, matching: find.text('el-GR, en-US')), findsOneWidget);
      expect(find.descendant(of: tile, matching: find.text('2434')), findsOneWidget);
      expect(find.textContaining('FIDE:'), findsNothing);
      expect(find.text('Rating: '), findsNothing);
      expect(find.descendant(of: tile, matching: find.text('25 EUR')), findsOneWidget);

      final locationTop = tester
          .getTopLeft(find.descendant(of: tile, matching: find.text('Location: ')))
          .dy;
      final languagesTop = tester
          .getTopLeft(find.descendant(of: tile, matching: find.text('Languages: ')))
          .dy;
      final rateTop = tester
          .getTopLeft(find.descendant(of: tile, matching: find.text('Hourly rate: ')))
          .dy;
      expect(locationTop, lessThan(languagesTop));
      expect(languagesTop, lessThan(rateTop));
    });

    testWidgets('coach list trims empty headline and hourly rate', (tester) async {
      final emptyDetailsResponse = _listResponse
          .replaceFirst('"headline": "Learn chess the fun way"', '"headline": ""')
          .replaceFirst('"hourlyRate": "25 EUR"', '"hourlyRate": ""');
      final client = MockClient((request) async {
        if (request.url.path == '/coach/all/all/login') {
          return http.Response(emptyDetailsResponse, 200);
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

      expect(find.text('el-GR, en-US'), findsOneWidget);
      expect(find.textContaining(' • '), findsNothing);
    });

    testWidgets('automatically loads the next page when the list does not fill the screen', (
      tester,
    ) async {
      final client = MockClient((request) async {
        if (request.url.path == '/coach/all/all/login') {
          return http.Response(
            request.url.queryParameters['page'] == '2' ? _listPage2Response : _listPage1Response,
            200,
          );
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
      expect(tester.widget<Text>(find.text('Learn chess the fun way')).textAlign, TextAlign.center);
    });

    testWidgets('profile with an empty headline has no blank line above the buttons', (
      tester,
    ) async {
      final emptyHeadlineResponse = _profileResponse.replaceFirst(
        '"headline": "Learn chess the fun way"',
        '"headline": ""',
      );
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(emptyHeadlineResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      expect(find.text(''), findsNothing);
      expect(find.byType(OutlinedButton), findsNWidgets(2));
    });

    testWidgets('profile shows youtube thumbnails instead of video links', (tester) async {
      final pngBytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
      );
      final client = MockClient((request) async {
        if (request.url.host == 'i.ytimg.com') {
          return http.Response.bytes(pngBytes, 200, headers: {'content-type': 'image/png'});
        }
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      await tester.drag(find.byType(ListView).last, const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('YouTube videos'), findsOneWidget);
      expect(find.textContaining('youtube.com'), findsNothing);
      expect(find.textContaining('youtu.be'), findsNothing);
      final thumbnails = tester
          .widgetList<HttpNetworkImageWidget>(find.byType(HttpNetworkImageWidget))
          .where((widget) => widget.url.contains('i.ytimg.com'));
      expect(thumbnails, hasLength(2));
    });

    testWidgets('profile shows youtube video titles over the thumbnails', (tester) async {
      final client = MockClient((request) async {
        if (request.url.host == 'www.youtube.com' && request.url.path == '/oembed') {
          return http.Response(
            '{"title":"${request.url.queryParameters['url']!.contains('dQw4w9WgXcQ') ? 'First video title' : 'Second video title'}"}',
            200,
          );
        }
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      await tester.drag(find.byType(ListView).last, const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('First video title'), findsOneWidget);
      expect(find.text('Second video title'), findsOneWidget);
    });

    testWidgets('profile app bar shows the coach title and patron icon', (tester) async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      expect(find.text('WFM'), findsOneWidget);
      expect(find.byType(PatronIcon), findsOneWidget);
      expect(
        tester.widget<PlatformAppBar>(find.byType(PlatformAppBar)).title,
        isA<UserFullNameWidget>(),
      );
    });

    testWidgets('profile shows the youtube channel tile under the videos section', (tester) async {
      final pngBytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
      );
      final client = MockClient((request) async {
        if (request.url.host == 'i.ytimg.com') {
          return http.Response.bytes(pngBytes, 200, headers: {'content-type': 'image/png'});
        }
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileWithChannelResponse, 200);
          default:
            return http.Response('', 404);
        }
      });
      final scrapeClient = MockClient((request) async {
        if (request.url.host == 'www.youtube.com' && request.url.path == '/@cleverqueen') {
          return http.Response(_channelPageResponse, 200);
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
          youtubeScrapeClientProvider: youtubeScrapeClientProvider.overrideWith(
            (ref) => scrapeClient,
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CoachListTile).first);
      await tester.pumpAndSettle();

      expect(find.text('Chess Sparring Academy'), findsOneWidget);
      expect(find.text('1.2K subscribers • 438 videos'), findsOneWidget);
      expect(
        tester.getRect(find.text('Chess Sparring Academy')).top,
        lessThan(tester.getRect(find.byType(HttpNetworkImageWidget).last).top),
      );
    });

    testWidgets('profile buttons open the lichess profile and a direct message', (tester) async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          case '/api/user/toniaa':
            return http.Response(_userResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      expect(find.byType(OutlinedButton), findsNWidgets(2));
      expect(find.text('Lichess profile'), findsOneWidget);
      expect(find.text('Send a private message'), findsNothing);
      expect(find.text('Message'), findsOneWidget);
      expect(find.byIcon(Icons.person_outlined), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(
        tester.getRect(find.byType(OutlinedButton).first).bottom,
        lessThan(tester.getRect(find.text('Languages')).top),
      );

      await tester.tap(find.byType(OutlinedButton).first);
      await tester.pumpAndSettle();

      expect(find.byType(UserScreen), findsOneWidget);
    });

    testWidgets('profile message button opens a conversation', (tester) async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          case '/inbox/toniaa':
            return http.Response(
              '{"me":{"name":"me","id":"me"},"bot":false,"convo":{"user":{"name":"toniaa","id":"toniaa"},"msgs":[],"postable":true}}',
              200,
            );
          case '/api/user/toniaa':
            return http.Response(_userResponse, 200);
          default:
            return http.Response('', 404);
        }
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const CoachListScreen(),
        authUser: fakeAuthUser,
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

      await tester.tap(find.byType(OutlinedButton).last);
      await tester.pumpAndSettle();

      expect(find.byType(ConversationScreen), findsOneWidget);
    });

    testWidgets('profile message button asks to sign in when logged out', (tester) async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      await tester.tap(find.byType(OutlinedButton).last);
      await tester.pumpAndSettle();

      expect(find.text('Sign in with the browser'), findsOneWidget);
      expect(find.byType(ConversationScreen), findsNothing);
    });

    testWidgets('youtube channel tile shows a shimmer while loading', (tester) async {
      final pngBytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
      );
      final completer = Completer<http.Response>();
      final client = MockClient((request) async {
        if (request.url.host == 'i.ytimg.com') {
          return http.Response.bytes(pngBytes, 200, headers: {'content-type': 'image/png'});
        }
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileWithChannelResponse, 200);
          default:
            return http.Response('', 404);
        }
      });
      final scrapeClient = MockClient((request) => completer.future);

      final app = await makeTestProviderScopeApp(
        tester,
        home: const CoachListScreen(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
          youtubeScrapeClientProvider: youtubeScrapeClientProvider.overrideWith(
            (ref) => scrapeClient,
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CoachListTile).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(Shimmer), findsWidgets);
      expect(find.text('Chess Sparring Academy'), findsNothing);

      completer.complete(http.Response(_channelPageResponse, 200));
      await tester.pumpAndSettle();

      expect(find.byType(Shimmer), findsNothing);
      expect(find.text('Chess Sparring Academy'), findsOneWidget);
    });

    testWidgets('profile shows the latest blog posts', (tester) async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      expect(find.text('Latest blog posts'), findsOneWidget);
      expect(find.text('Chess sparring'), findsOneWidget);
      expect(find.text('Endgame fundamentals'), findsOneWidget);
      expect(find.textContaining('/@/toniaa/blog'), findsNothing);
      expect(find.byIcon(Icons.article_outlined), findsNWidgets(2));
    });

    testWidgets('profile shows public studies with their names', (tester) async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      await tester.dragUntilVisible(
        find.text('Rook endgames mastery'),
        find.byType(ListView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(find.text('Public studies'), findsOneWidget);
      expect(find.text('Rook endgames mastery'), findsOneWidget);
      expect(find.text('Opening principles'), findsOneWidget);
      expect(find.textContaining('ZalBgXT3'), findsNothing);
      expect(find.byIcon(LichessIcons.study), findsNWidgets(2));
    });

    testWidgets('profile hides youtube section when there are no videos', (tester) async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileChannelOnlyResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      expect(find.text('YouTube videos'), findsNothing);
    });

    testWidgets('profile shows user API data in the overview card', (tester) async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/coach/all/all/login':
            return http.Response(_listResponse, 200);
          case '/coach/toniaa':
            return http.Response(_profileResponse, 200);
          case '/api/user/toniaa':
            return http.Response(_userResponse, 200);
          default:
            return http.Response('', 404);
        }
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

      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Bruxelles'), findsOneWidget);
      expect(find.text('Greece'), findsOneWidget);
      expect(find.text('Ελληνικά, English (US)'), findsOneWidget);
      expect(find.textContaining('el-GR'), findsNothing);
      expect(find.text('FIDE: 2281'), findsOneWidget);
      expect(find.text('Bullet 2014'), findsOneWidget);
      expect(find.text('Blitz 2288'), findsOneWidget);
      expect(find.text('Rapid 2615'), findsNothing);
      expect(find.textContaining('Lichess rating'), findsNothing);
      expect(find.text('2434'), findsNothing);
      expect(find.text('Hourly rate'), findsOneWidget);
      expect(find.text('25 EUR'), findsOneWidget);
      expect(find.text('Accepting students'), findsOneWidget);
      expect(find.textContaining('Active'), findsOneWidget);
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
      await closeFilterSheet(tester);

      expect(requestedOrders, ['login', 'rating']);
    });

    testWidgets('changing the language filter refetches with the new language', (tester) async {
      final requestedPaths = <String>[];
      final client = MockClient((request) async {
        if (request.url.path.startsWith('/coach/')) {
          requestedPaths.add(request.url.path);
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

      await tester.tap(find.text('English (US)'));
      await tester.pumpAndSettle();
      await closeFilterSheet(tester);

      expect(requestedPaths, ['/coach/all/all/login', '/coach/en-US/all/login']);
    });

    testWidgets('country filter asks to sign in when logged out', (tester) async {
      final requestedPaths = <String>[];
      final client = MockClient((request) async {
        if (request.url.path.startsWith('/coach/')) {
          requestedPaths.add(request.url.path);
        }
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

      await tester.tap(findByTooltip('Filters'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Greece'));
      await tester.pumpAndSettle();
      await closeFilterSheet(tester);

      expect(requestedPaths, ['/coach/all/all/login']);
      expect(find.text('Sign in with the browser'), findsOneWidget);
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

    testWidgets('filter sheet can be closed', (tester) async {
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

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      await closeFilterSheet(tester);

      expect(find.byType(BottomSheet), findsNothing);
      expect(find.byType(CoachListTile), findsNWidgets(2));
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
