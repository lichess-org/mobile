import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/coach/coach_filter.dart';
import 'package:lichess_mobile/src/model/coach/coach_list_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

String _pageResponse(String username, int? nextPage) =>
    '''
{
  "currentPage": 1,
  "maxPerPage": 10,
  "currentPageResults": [
    {
      "coach": {
        "id": "$username",
        "listed": true,
        "available": true,
        "profile": {"headline": null, "hourlyRate": null},
        "picture": null,
        "nbReviews": 3,
        "user": {"rating": 2400, "seenAt": 1760000000000},
        "languages": ["en-US"],
        "createdAt": 1650000000000,
        "updatedAt": 1750000000000
      },
      "user": {"id": "$username", "name": "$username"}
    }
  ],
  "previousPage": null,
  "nextPage": $nextPage,
  "nbResults": 1,
  "nbPages": 1,
  "lang": "all",
  "order": "login",
  "country": "all",
  "languages": ["en-US"],
  "countries": []
}
''';

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

  group('CoachListController', () {
    test('appends the next page and clears nextPage at the end', () async {
      final mockClient = MockClient((request) {
        expect(request.url.path, '/coach/all/all/login');
        final page = request.url.queryParameters['page'];
        if (page == '2') {
          return mockResponse(_pageResponse('coach2', null), 200);
        }
        return mockResponse(_pageResponse('coach1', 2), 200);
      });

      final container = await makeTestContainer(mockClient);
      final provider = coachListControllerProvider(defaultCoachFilters);

      final first = await container.read(provider.future);
      expect(first.coaches.length, 1);
      expect(first.coaches.first.user.name, 'coach1');
      expect(first.nextPage, 2);

      await container.read(provider.notifier).next();

      final combined = container.read(provider).requireValue;
      expect(combined.coaches.length, 2);
      expect(combined.coaches[1].user.name, 'coach2');
      expect(combined.nextPage, isNull);
    });

    test('does nothing when there is no next page', () async {
      var requestCount = 0;
      final mockClient = MockClient((_) {
        requestCount++;
        return mockResponse(_pageResponse('coach1', null), 200);
      });

      final container = await makeTestContainer(mockClient);
      final provider = coachListControllerProvider(defaultCoachFilters);

      await container.read(provider.future);
      await container.read(provider.notifier).next();

      expect(requestCount, 1);
      expect(container.read(provider).requireValue.coaches.length, 1);
    });
  });
}
