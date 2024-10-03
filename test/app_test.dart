import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/http.dart';

import 'mock_server_responses.dart';
import 'model/auth/fake_session_storage.dart';
import 'test_helpers.dart';
import 'test_provider_scope.dart';

void main() {
  testWidgets('App loads', (tester) async {
    final app = await makeTestProviderScope(
      tester,
      child: const Application(),
    );

    await tester.pumpWidget(app);

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App loads with system theme, which defaults to light',
      (tester) async {
    final app = await makeTestProviderScope(
      tester,
      child: const Application(),
    );

    await tester.pumpWidget(app);

    expect(
      Theme.of(tester.element(find.byType(MaterialApp))).brightness,
      Brightness.light,
    );
  });

  // testWidgets('App checks a stored session', (tester) async {
  //   int tokenTestRequests = 0;
  //   final mockClient = MockClient((request) {
  //     if (request.url.path == '/api/token/test') {
  //       tokenTestRequests++;
  //       return mockResponse(
  //         '''
// {
  // "${fakeSession.token}": {
  //   "scopes": "web:mobile",
  //   "userId": "${fakeSession.user.id}"
  // }
// }
  //       ''',
  //         200,
  //       );
  //     } else if (request.url.path == '/api/account') {
  //       return mockResponse(
  //         mockApiAccountResponse(fakeSession.user.name),
  //         200,
  //       );
  //     }
  //     return mockResponse('', 404);
  //   });

  //   final app = await makeTestProviderScope(
  //     tester,
  //     child: const Application(),
  //     userSession: fakeSession,
  //     overrides: [
  //       lichessClientProvider
  //           .overrideWith((ref) => LichessClient(mockClient, ref)),
  //     ],
  //   );

  //   await tester.pumpWidget(app);

  //   expect(find.byType(MaterialApp), findsOneWidget);

  //   // wait for the session check request to complete
  //   await tester.pump(const Duration(milliseconds: 100));

  //   expect(tokenTestRequests, 1);

  //   // session is still active
  //   expect(find.text('Hello testUser'), findsOneWidget);
  // });

  testWidgets('Bottom navigation', (tester) async {
    final app = await makeTestProviderScope(
      tester,
      child: const Application(),
    );

    await tester.pumpWidget(app);

    expect(find.byType(BottomNavScaffold), findsOneWidget);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      expect(find.byType(BottomNavigationBarItem), findsNWidgets(5));
    } else {
      expect(find.byType(NavigationDestination), findsNWidgets(5));
    }

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Puzzles'), findsOneWidget);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Watch'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
