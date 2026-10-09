import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_calendar_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_list_tile.dart';
import 'package:material_ui/material_ui.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/api/broadcast/calendar/2026/10') {
    return mockResponse(
      calendarScreenResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  return mockResponse('', 404);
});

void main() {
  group('BroadcastCalendarScreen', () {
    testWidgets('Displays grouped broadcasts for the month', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastCalendarScreen(initialYear: 2026, initialMonth: 10),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.byType(BroadcastListTile), findsNWidgets(2));
      expect(find.byType(DropdownButton<int>), findsNWidgets(2));
    });

    testWidgets('Loading state stays refreshable', variant: kPlatformVariant, (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastCalendarScreen(initialYear: 2026, initialMonth: 10),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => client);
          }),
        },
      );

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('Shows empty state when month has no broadcasts', variant: kPlatformVariant, (
      tester,
    ) async {
      final emptyClient = MockClient((request) => mockResponse('[]', 200));
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastCalendarScreen(initialYear: 2026, initialMonth: 11),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => emptyClient);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.text('No broadcasts this month'), findsOneWidget);
    });

    testWidgets('Shows undated broadcasts under To be announced', variant: kPlatformVariant, (
      tester,
    ) async {
      final mixedClient = MockClient((request) {
        if (request.url.path == '/api/broadcast/calendar/2026/10') {
          return mockResponse(
            mixedResponse,
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return mockResponse('', 404);
      });
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastCalendarScreen(initialYear: 2026, initialMonth: 10),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mixedClient);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.text(DateFormat.yMMMMd().format(DateTime(2026, 10, 1))), findsOneWidget);
      expect(find.text('To be announced'), findsOneWidget);
      expect(find.byType(BroadcastListTile), findsNWidgets(2));
    });

    testWidgets('Shows retry on error', variant: kPlatformVariant, (tester) async {
      final errorClient = MockClient((request) => mockResponse('', 404));
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastCalendarScreen(initialYear: 2026, initialMonth: 10),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => errorClient);
          }),
        },
      );

      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.text('Cannot load broadcast calendar'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

const calendarScreenResponse = '''
[
  {"tour":{"id":"aaaaaaa1","name":"Tour A","slug":"tour-a"},"round":{"id":"rrrrrrr1","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790812800000}},
  {"tour":{"id":"bbbbbbb1","name":"Tour B","slug":"tour-b"},"round":{"id":"rrrrrrr2","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790899200000}}
]
''';

const mixedResponse = '''
[
  {"tour":{"id":"aaaaaaa1","name":"Tour A","slug":"tour-a"},"round":{"id":"rrrrrrr1","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790812800000}},
  {"tour":{"id":"ccccccc1","name":"Undated Tour","slug":"undated-tour"},"round":{"id":"rrrrrrr9","name":"Round TBD","slug":"round-tbd","ongoing":false,"finished":false,"startsAfterPrevious":true}}
]
''';
