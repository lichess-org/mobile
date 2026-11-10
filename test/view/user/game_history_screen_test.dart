import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/view/account/game_bookmarks_screen.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:material_ui/material_ui.dart';

import '../../mock_server_responses.dart';
import '../../model/auth/fake_auth_storage.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  testWidgets('The menu of my games links to my bookmarks', (tester) async {
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/account') {
        return mockResponse(
          mockApiAccountResponse('testUser').replaceFirst(
            '"perfs": {',
            '"count": {"all": 20, "win": 10, "draw": 2, "loss": 8, "bookmark": 13}, "perfs": {',
          ),
          200,
        );
      }
      if (request.url.path == '/api/games/user/testuser') {
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
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('13 bookmarks'));
    await tester.pumpAndSettle();

    expect(find.byType(GameBookmarksScreen), findsOneWidget);
  });

  testWidgets('Games are grouped by day, with their time and rating change', (tester) async {
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/games/user/testuser') {
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
    await tester.pumpAndSettle();

    // One game on January 14 2023, two on January 12 2023.
    expect(find.byType(ListSectionHeader), findsNWidgets(2));
    expect(find.byType(ListSectionRow), findsNWidgets(3));

    String timeOf(int millis) => formatTimeOfDay(
      tester.element(find.byType(ListSectionRow).first),
      DateTime.fromMillisecondsSinceEpoch(millis),
    );
    expect(find.textContaining(timeOf(1673553626465)), findsOneWidget);
    expect(find.textContaining('+5'), findsOneWidget);
    expect(find.textContaining('-5'), findsOneWidget);
  });

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
