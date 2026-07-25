import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/widgets/server_outage_display.dart';

import '../../network/fake_http_client_factory.dart';
import '../../network/server_down_client.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Watch tab', () {
    testWidgets('shows the no internet message when the network is down', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          onlineStatusProvider: onlineStatusProvider.overrideWith((ref) => Future.value(false)),
        },
      );

      await tester.pumpWidget(app);
      await tester.pump();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Watch'));
      await tester.pumpAndSettle();

      expect(find.text('No internet connection.'), findsOneWidget);
      expect(find.byType(ServerOutageDisplay), findsNothing);
    });

    testWidgets('shows the outage screen when the server is down', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient());
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Watch'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);
    });

    testWidgets('pulling to refresh while still down keeps the outage screen', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient());
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Watch'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);

      await tester.fling(find.byType(ServerOutageDisplay), const Offset(0.0, 300.0), 1000.0);
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);
    });

    testWidgets('resuming the app once the server is back leaves the outage screen', (
      tester,
    ) async {
      var statusCode = 503;
      final client = serverDownClientWithStatus(() => statusCode);

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

      await tester.tap(find.text('Watch'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);

      // The server comes back up while the app is in the background.
      statusCode = 200;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsNothing);
    });

    testWidgets('resuming the app while still down keeps the outage screen', (tester) async {
      final app = await makeTestProviderScope(
        tester,
        child: const Application(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => serverDownClient());
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Watch'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);
    });

    testWidgets('pulling to refresh once the server is back leaves the outage screen', (
      tester,
    ) async {
      var statusCode = 503;
      final client = serverDownClientWithStatus(() => statusCode);

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

      await tester.tap(find.text('Watch'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsOneWidget);

      // The server comes back up.
      statusCode = 200;

      await tester.fling(find.byType(ServerOutageDisplay), const Offset(0.0, 300.0), 1000.0);
      await tester.pumpAndSettle();

      expect(find.byType(ServerOutageDisplay), findsNothing);
    });
  });
}
