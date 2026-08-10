import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_activity.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';
import '../auth/fake_auth_storage.dart';
import 'mock_server_responses.dart';

void main() {
  // triggers puzzleActivityProvider to rebuild with fresh data.
  test('invalidating puzzleRecentActivityProvider re-fetches puzzle history', () async {
    int activityRequestCount = 0;
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/puzzle/activity') {
        activityRequestCount++;
        return mockResponse(mockActivityResponse, 200);
      }
      return mockResponse('', 404);
    });

    final container = await makeContainer(
      authUser: fakeAuthUser,
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith((ref) {
          return LichessClient(mockClient, ref);
        }),
      },
    );

    // Keep the provider alive (simulates the history screen being open)
    final sub = container.listen(puzzleActivityProvider, (_, _) {});
    addTearDown(sub.close);

    // First load: fetches from server
    final state = await container.read(puzzleActivityProvider.future);
    expect(state.historyByDay, isNotEmpty);
    expect(activityRequestCount, 1);

    // Invalidate the recent activity provider (this is what the fix does after
    // solving a puzzle). Since puzzleActivityProvider watches it, both rebuild.
    container.invalidate(puzzleRecentActivityProvider);

    // The provider rebuilds and re-fetches from server
    await container.read(puzzleActivityProvider.future);

    expect(
      activityRequestCount,
      2,
      reason: 'puzzle activity should be re-fetched after invalidation',
    );
  });
}
