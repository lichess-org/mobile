import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:material_ui/material_ui.dart';

import '../../mock_server_responses.dart';
import '../../model/auth/fake_auth_storage.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  testWidgets('A failed load can be retried', (tester) async {
    var failing = true;
    var nbRequests = 0;
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/games/user/testuser') {
        nbRequests++;
        if (failing) {
          throw http.ClientException('Request timed out', request.url);
        }
        return mockResponse(mockUserRecentGameResponse('testUser'), 200);
      }
      return mockResponse('', 404);
    });

    final app = await makeTestProviderScopeApp(
      tester,
      home: const GameHistoryScreen(user: null, isOnline: true),
      authUser: fakeAuthUser,
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
          (ref) => FakeHttpClientFactory(() => mockClient),
        ),
      },
    );
    await tester.pumpWidget(app);

    // Let riverpod's automatic retries run out.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 10));
    }

    expect(find.byType(FullScreenRetryRequest), findsOneWidget);
    final nbFailedRequests = nbRequests;

    failing = false;
    await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
    await tester.pumpAndSettle();

    expect(nbRequests, nbFailedRequests + 1);
    expect(find.byType(FullScreenRetryRequest), findsNothing);
    expect(find.textContaining('MightyNanook'), findsOneWidget);
  });
}
