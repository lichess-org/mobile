import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

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

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(broadcastRepositoryProvider);

      final response = await repo.getCalendar(year: 2026, month: 10);

      expect(requestedPath, '/api/broadcast/calendar/2026/10');
      expect(response.length, 3);
      expect(response[0].title, 'Tour A');
    });

    test('groupBroadcastsByDate groups by day and sorts', () async {
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

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(broadcastRepositoryProvider);

      final broadcasts = await repo.getCalendar(year: 2026, month: 10);
      final days = groupBroadcastsByDate(broadcasts);

      expect(days.length, 2);
      expect(days[0].broadcasts.length, 2);
      expect(days[1].broadcasts.length, 1);
      expect(
        days[0].broadcasts[0].round.startsAt!.isBefore(days[0].broadcasts[1].round.startsAt!),
        isTrue,
      );
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
