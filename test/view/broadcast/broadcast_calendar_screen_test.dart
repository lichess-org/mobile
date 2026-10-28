import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_calendar_screen.dart';
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

      expect(find.text('Tour A'), findsOneWidget);
      expect(find.text('Tour B'), findsOneWidget);
    });

    testWidgets(
      'Shows a loading indicator while waiting for the month',
      variant: kPlatformVariant,
      (tester) async {
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
      },
    );

    testWidgets(
      'Disables month navigation at the supported date limits',
      variant: kPlatformVariant,
      (tester) async {
        final firstMonthApp = await makeTestProviderScopeApp(
          tester,
          home: const BroadcastCalendarScreen(initialYear: 2020, initialMonth: 1),
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
              return FakeHttpClientFactory(() => client);
            }),
          },
        );

        await tester.pumpWidget(firstMonthApp);
        final previousButton = find.ancestor(
          of: find.byIcon(Icons.chevron_left),
          matching: find.byType(IconButton),
        );
        expect(tester.widget<IconButton>(previousButton).onPressed, isNull);

        await tester.pumpWidget(const SizedBox.shrink());
        final lastMonthApp = await makeTestProviderScopeApp(
          tester,
          home: BroadcastCalendarScreen(initialYear: DateTime.now().year + 1, initialMonth: 12),
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
              return FakeHttpClientFactory(() => client);
            }),
          },
        );

        await tester.pumpWidget(lastMonthApp);
        final nextButton = find.ancestor(
          of: find.byIcon(Icons.chevron_right),
          matching: find.byType(IconButton),
        );
        expect(tester.widget<IconButton>(nextButton).onPressed, isNull);
      },
    );

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
    });

    testWidgets('Shows live marker only for ongoing rounds', variant: kPlatformVariant, (
      tester,
    ) async {
      final liveClient = MockClient((request) {
        if (request.url.path == '/api/broadcast/calendar/2026/10') {
          return mockResponse(
            liveResponse,
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
            return FakeHttpClientFactory(() => liveClient);
          }),
        },
      );

      await withClock(Clock.fixed(DateTime.utc(2026, 10, 11)), () async {
        await tester.pumpWidget(app);
        await tester.pump();
      });

      expect(find.textContaining('LIVE'), findsOneWidget);
      final liveRow = find.ancestor(of: find.text('Live Tour'), matching: find.byType(ListTile));
      expect(find.descendant(of: liveRow, matching: find.text('LIVE · Round 1')), findsOneWidget);
      final startedRow = find.ancestor(
        of: find.text('Started Tour'),
        matching: find.byType(ListTile),
      );
      expect(
        find.descendant(of: startedRow, matching: find.textContaining('Round 1 · ')),
        findsOneWidget,
      );
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
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

const calendarScreenResponse = '''
[
  {"tour":{"id":"aaaaaaa1","name":"Tour A","slug":"tour-a","image":"https://image.lichess1.org/tour-a.webp"},"round":{"id":"rrrrrrr1","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790812800000}},
  {"tour":{"id":"bbbbbbb1","name":"Tour B","slug":"tour-b"},"round":{"id":"rrrrrrr2","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790899200000}}
]
''';

const mixedResponse = '''
[
  {"tour":{"id":"aaaaaaa1","name":"Tour A","slug":"tour-a"},"round":{"id":"rrrrrrr1","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790812800000}},
  {"tour":{"id":"ccccccc1","name":"Undated Tour","slug":"undated-tour"},"round":{"id":"rrrrrrr9","name":"Round TBD","slug":"round-tbd","ongoing":false,"finished":false,"startsAfterPrevious":true}}
]
''';

const liveResponse = '''
[
  {"tour":{"id":"ddddddd1","name":"Live Tour","slug":"live-tour"},"round":{"id":"rrrrrrr3","name":"Round 1","slug":"round-1","ongoing":true,"finished":false,"startsAt":1791676800000}},
  {"tour":{"id":"eeeeeee1","name":"Started Tour","slug":"started-tour"},"round":{"id":"rrrrrrr4","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1791590400000}},
  {"tour":{"id":"fffffff1","name":"Future Tour","slug":"future-tour"},"round":{"id":"rrrrrrr5","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1793836800000}}
]
''';
