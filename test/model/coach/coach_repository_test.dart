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
    test('parses list response and sends filter query parameters', () async {
      const response = '''
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
      "rating": null,
      "languages": [],
      "nbReviews": 0,
      "available": false,
      "listed": true
    }
  ],
  "page": 1,
  "nextPage": 2,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": ["el-GR", "en-US"],
  "countries": [{"code": "GR", "name": "Greece"}]
}
''';

      final mockClient = MockClient((request) {
        expect(request.url.path, '/api/mobile/coach');
        expect(request.url.queryParameters['page'], '2');
        expect(request.url.queryParameters['lang'], 'en-US');
        expect(request.url.queryParameters['country'], 'all');
        expect(request.url.queryParameters['order'], 'rating');
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
      expect(result.nextPage, 2);
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
      expect(first.picture, 'https://example.com/toniaa.webp');

      final second = result.coaches[1];
      expect(second.rating, isNull);
      expect(second.headline, isNull);
      expect(second.hourlyRate, isNull);
      expect(second.picture, isNull);
      expect(second.available, isFalse);
    });

    test('handles empty list without next page', () async {
      const response = '''
{
  "coaches": [],
  "page": 1,
  "nextPage": null,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": [],
  "countries": []
}
''';

      final mockClient = MockClient((_) => mockResponse(response, 200));

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
  "user": {"id": "toniaa", "name": "toniaa", "title": "WFM"},
  "rating": 2434,
  "languages": ["el-GR", "en-US"],
  "nbReviews": 12,
  "available": true,
  "listed": true,
  "headline": "Learn chess the fun way",
  "hourlyRate": "25 EUR",
  "picture": "https://example.com/toniaa.webp",
  "youtubeVideos": ["https://youtube.com/watch?v=abc"],
  "studies": ["JbWtuaeK"],
  "description": "About me",
  "playingExperience": null,
  "teachingExperience": "10 years",
  "otherExperience": null,
  "skills": "Endgames",
  "methodology": "Step by step",
  "youtubeChannel": "https://youtube.com/@toniaa"
}
''';

      final mockClient = MockClient((request) {
        expect(request.url.path, '/api/mobile/coach/toniaa');
        return mockResponse(response, 200);
      });

      final container = await makeTestContainer(mockClient);
      final repo = container.read(coachRepositoryProvider);

      final profile = await repo.getCoach('toniaa');

      expect(profile.user.id.value, 'toniaa');
      expect(profile.description, 'About me');
      expect(profile.playingExperience, isNull);
      expect(profile.teachingExperience, '10 years');
      expect(profile.youtubeVideos, const IListConst(['https://youtube.com/watch?v=abc']));
      expect(profile.studies, const IListConst(['JbWtuaeK']));
      expect(profile.youtubeChannel, 'https://youtube.com/@toniaa');
    });
  });
}
