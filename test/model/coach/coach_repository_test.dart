import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/coach/coach_filter.dart';
import 'package:lichess_mobile/src/model/coach/coach_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  Future<ProviderContainer> makeTestContainer(MockClient mockClient) {
    return makeContainer(
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith((ref) {
          return LichessClient(mockClient, ref);
        }),
      },
    );
  }

  group('CoachRepository.getCoaches', () {
    test('parses paginator response and sends filters as path segments', () async {
      const response = '''
{
  "currentPage": 2,
  "maxPerPage": 10,
  "currentPageResults": [
    {
      "coach": {
        "id": "toniaa",
        "listed": true,
        "available": true,
        "profile": {
          "headline": "Learn chess the fun way",
          "hourlyRate": "25 EUR"
        },
        "picture": "https://image.lichess1.org/display?op=thumbnail&fmt=webp&h=350&w=350&path=toniaa",
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
  "previousPage": 1,
  "nextPage": 3,
  "nbResults": 21,
  "nbPages": 3,
  "lang": "en-US",
  "order": "rating",
  "country": "all",
  "languages": ["el-GR", "en-US"],
  "countries": [{"code": "GR", "name": "Greece"}]
}
''';

      final mockClient = MockClient((request) {
        expect(request.url.path, '/coach/en-US/all/rating');
        expect(request.url.queryParameters['page'], '2');
        expect(request.headers['Accept'], 'application/json');
        return mockResponse(response, 200);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(coachRepositoryProvider);

      final result = await repo.getCoaches((
        language: 'en-US',
        country: kAllCoachesFilter,
        order: CoachOrder.rating,
      ), page: 2);

      expect(result.coaches.length, 2);
      expect(result.nextPage, 3);
      expect(result.languages, const IListConst(['el-GR', 'en-US']));
      expect(result.countries, const [CoachFilterOption(code: 'GR', name: 'Greece')].lock);

      final first = result.coaches.first;
      expect(first.user.id.value, 'toniaa');
      expect(first.user.title, 'WFM');
      expect(first.rating, 2434);
      expect(first.languages, const IListConst(['el-GR', 'en-US']));
      expect(first.nbReviews, 12);
      expect(first.available, isTrue);
      expect(first.headline, 'Learn chess the fun way');
      expect(first.hourlyRate, '25 EUR');
      expect(
        first.picture,
        'https://image.lichess1.org/display?op=thumbnail&fmt=webp&h=350&w=350&path=toniaa',
      );

      final second = result.coaches[1];
      expect(second.rating, 2200);
      expect(second.headline, isNull);
      expect(second.hourlyRate, isNull);
      expect(second.picture, isNull);
      expect(second.available, isFalse);
    });

    test('handles empty list without next page', () async {
      const response = '''
{
  "currentPage": 1,
  "maxPerPage": 10,
  "currentPageResults": [],
  "previousPage": null,
  "nextPage": null,
  "nbResults": 0,
  "nbPages": 0,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": [],
  "countries": []
}
''';

      final mockClient = MockClient((request) {
        expect(request.url.path, '/coach/all/all/login');
        return mockResponse(response, 200);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(coachRepositoryProvider);

      final result = await repo.getCoaches(defaultCoachFilters);

      expect(result.coaches, isEmpty);
      expect(result.nextPage, isNull);
    });
  });

  group('CoachRepository.getCoach', () {
    test('parses profile response', () async {
      const response = '''
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
      "teachingExperience": "10 years",
      "otherExperience": null,
      "skills": "Endgames",
      "methodology": "Step by step",
      "youtubeVideos": "https://www.youtube.com/watch?v=wEwoyYp_iw8",
      "youtubeChannel": "https://youtube.com/@toniaa",
      "publicStudies": "https://lichess.org/study/JbWtuaeK"
    },
    "picture": null,
    "nbReviews": 12,
    "user": {"rating": 2434, "seenAt": 1760000000000},
    "languages": ["el-GR", "en-US"],
    "createdAt": 1650000000000,
    "updatedAt": 1750000000000
  },
  "user": {"id": "toniaa", "name": "toniaa", "title": "WFM"}
}
''';

      final mockClient = MockClient((request) {
        expect(request.url.path, '/coach/toniaa');
        expect(request.headers['Accept'], 'application/json');
        return mockResponse(response, 200);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(coachRepositoryProvider);

      final profile = await repo.getCoach('toniaa');

      expect(profile.user.id.value, 'toniaa');
      expect(profile.rating, 2434);
      expect(profile.headline, 'Learn chess the fun way');
      expect(profile.hourlyRate, '25 EUR');
      expect(profile.description, 'I teach chess for a living');
      expect(profile.playingExperience, isNull);
      expect(profile.teachingExperience, '10 years');
      expect(
        profile.youtubeVideos,
        const IListConst(['https://www.youtube.com/watch?v=wEwoyYp_iw8']),
      );
      expect(profile.studies, const IListConst(['JbWtuaeK']));
      expect(profile.youtubeChannel, 'https://youtube.com/@toniaa');
    });
  });
}
