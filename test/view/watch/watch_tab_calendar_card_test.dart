import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_calendar_screen.dart';
import 'package:lichess_mobile/src/view/watch/watch_tab_screen.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/broadcast/top') {
    return mockResponse(
      '{"active":[],"past":{"currentPageResults":[],"nextPage":null}}',
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/tv/channels') {
    return mockResponse('{}', 200, headers: {'content-type': 'application/json; charset=utf-8'});
  }
  if (request.url.path == '/api/streamer/live') {
    return mockResponse('[]', 200, headers: {'content-type': 'application/json; charset=utf-8'});
  }
  return mockResponse('', 404);
});

void main() {
  group('Watch tab broadcast calendar card', () {
    testWidgets('Card opens the broadcast calendar', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const WatchTabScreen(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Broadcast calendar'), findsOneWidget);
      expect(find.text('Upcoming and past tournaments'), findsOneWidget);

      await tester.tap(find.text('Upcoming and past tournaments'));
      await tester.pumpAndSettle();

      expect(find.byType(BroadcastCalendarScreen), findsOneWidget);
    });
  });
}
