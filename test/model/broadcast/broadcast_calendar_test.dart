import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';

Future<ProviderContainer> calendarContainer(http.Client client) => makeContainer(
  overrides: {
    httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
      return FakeHttpClientFactory(() => client);
    }),
  },
);

void main() {
  group('BroadcastCalendar', () {
    test('getCalendar requests month path and parses broadcasts', () async {
      var requestedPath = '';
      final mockClient = MockClient((request) {
        requestedPath = request.url.path;
        if (request.url.path == '/api/broadcast/calendar/2026/10') {
          return mockResponse(
            calendarResponse,
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return mockResponse('', 404);
      });

      final container = await calendarContainer(mockClient);
      final repo = container.read(broadcastRepositoryProvider);

      final response = await repo.getCalendar(year: 2026, month: 10);

      expect(requestedPath, '/api/broadcast/calendar/2026/10');
      expect(response.length, 3);
      expect(response[0].title, 'Tour A');
    });

    test('calendar provider groups by day and sorts', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/broadcast/calendar/2026/10') {
          return mockResponse(
            calendarResponse,
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return mockResponse('', 404);
      });

      final container = await calendarContainer(mockClient);
      final days = await container.read(broadcastCalendarProvider((year: 2026, month: 10)).future);

      expect(days.length, 2);
      expect(days[0].broadcasts.length, 2);
      expect(days[1].broadcasts.length, 1);
      expect(
        days[0].broadcasts[0].round.startsAt!.isBefore(days[0].broadcasts[1].round.startsAt!),
        isTrue,
      );
    });

    test('calendar provider groups by UTC day', () async {
      final early = DateTime.utc(2026, 9, 30, 0, 30).millisecondsSinceEpoch;
      final late = DateTime.utc(2026, 9, 30, 23, 30).millisecondsSinceEpoch;
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/broadcast/calendar/2026/9') {
          return mockResponse(
            '''
[
  {"tour":{"id":"aaaaaaa1","name":"Tour A","slug":"tour-a"},"round":{"id":"rrrrrrr1","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":$early}},
  {"tour":{"id":"bbbbbbb1","name":"Tour B","slug":"tour-b"},"round":{"id":"rrrrrrr2","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":$late}}
]
''',
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return mockResponse('', 404);
      });

      final container = await calendarContainer(mockClient);
      final days = await container.read(broadcastCalendarProvider((year: 2026, month: 9)).future);

      expect(days.length, 1);
      expect(days.single.date, DateTime.utc(2026, 9, 30));
      expect(days.single.broadcasts.length, 2);
    });

    test('calendar provider puts broadcasts without a start date last', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/broadcast/calendar/2026/10') {
          return mockResponse(
            '''
[
  {"tour":{"id":"aaaaaaa1","name":"Tour A","slug":"tour-a"},"round":{"id":"rrrrrrr1","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790812800000}},
  {"tour":{"id":"ccccccc1","name":"Undated Tour","slug":"undated-tour"},"round":{"id":"rrrrrrr9","name":"Round TBD","slug":"round-tbd","ongoing":false,"finished":false,"startsAfterPrevious":true}}
]
''',
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return mockResponse('', 404);
      });

      final container = await calendarContainer(mockClient);
      final days = await container.read(broadcastCalendarProvider((year: 2026, month: 10)).future);

      expect(days.length, 2);
      expect(days.last.date, isNull);
      expect(days.last.broadcasts.single.title, 'Undated Tour');
    });

    test('calendar provider keeps months with only undated broadcasts', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/broadcast/calendar/2026/10') {
          return mockResponse(
            '''
[
  {"tour":{"id":"ccccccc1","name":"Undated Tour","slug":"undated-tour"},"round":{"id":"rrrrrrr9","name":"Round TBD","slug":"round-tbd","ongoing":false,"finished":false,"startsAfterPrevious":true}}
]
''',
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return mockResponse('', 404);
      });

      final container = await calendarContainer(mockClient);
      final days = await container.read(broadcastCalendarProvider((year: 2026, month: 10)).future);

      expect(days.length, 1);
      expect(days.single.date, isNull);
      expect(days.single.broadcasts.single.title, 'Undated Tour');
    });
  });
}

const calendarResponse = '''
[
  {"tour":{"id":"aaaaaaa1","name":"Tour A","slug":"tour-a"},"round":{"id":"rrrrrrr1","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790812800000}},
  {"tour":{"id":"aaaaaaa2","name":"Tour A Late","slug":"tour-a-late"},"round":{"id":"rrrrrrr2","name":"Round 2","slug":"round-2","ongoing":false,"finished":false,"startsAt":1790816400000}},
  {"tour":{"id":"bbbbbbb1","name":"Tour B","slug":"tour-b"},"round":{"id":"rrrrrrr3","name":"Round 1","slug":"round-1","ongoing":false,"finished":false,"startsAt":1790899200000}}
]
''';
