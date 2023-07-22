import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import '../../model/user/user_repository_test.dart';
import '../../test_utils.dart';
import '../../test_app.dart';

void main() {
  final mockClient = MockClient((request) {
    if (request.url.path == '/api/games/user/$testUserId') {
      return mockResponse(userGameResponse, 200);
    } else if (request.url.path == '/api/user/$testUserId') {
      return mockResponse(testUserResponse, 200);
    } else if (request.url.path == '/api/user/$testUserId/activity') {
      return mockResponse(userActivityResponse, 200);
    }
    return mockResponse('', 404);
  });

  group('UserScreen', () {
    testWidgets(
      'should see activity and recent games',
      (WidgetTester tester) async {
        final app = await buildTestApp(
          tester,
          home: const UserScreen(user: testUser),
          overrides: [
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

        await tester.pumpWidget(app);

        // wait for user request
        await tester.pump(const Duration(milliseconds: 50));

        // full name at the top
        expect(
          find.widgetWithText(ListTile, 'John Doe'),
          findsOneWidget,
        );

        // wait for recent games and activity
        await tester.pump(const Duration(milliseconds: 50));

        expect(find.text('Activity'), findsOneWidget);

        await tester.scrollUntilVisible(
          find.widgetWithText(PlatformListTile, 'maia1 (1410)'),
          500,
          // need to take first scrollable there is the perf cards ListView inside the main list
          scrollable: find.byType(Scrollable).first,
        );

        expect(find.text('Recent games'), findsOneWidget);

        // opponent in recent games
        expect(
          find.widgetWithText(PlatformListTile, 'maia1 (1397)'),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(PlatformListTile, 'maia1 (1399)'),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(PlatformListTile, 'maia1 (1410)'),
          findsOneWidget,
        );
      },
      variant: kPlatformVariant,
    );
  });
}

const testUserName = 'FakeUserName';
const testUserId = UserId('fakeuserid');
const testUser = LightUser(id: testUserId, name: testUserName);
final userGameResponse = '''
{"id":"rfBxF2P5","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1672074461465,"lastMoveAt":1672074683485,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1397}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
{"id":"msAKIkqp","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671791341158,"lastMoveAt":1671791589063,"status":"resign","players":{"white":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1399},"black":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
{"id":"7Jxi9mBF","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671100908073,"lastMoveAt":1671101322211,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1410}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
''';

final testUserResponse = '''
{
  "id": "$testUserId",
  "username": "$testUserName",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "title": "GM",
  "patron": true,
  "perfs": {
    "blitz": {
      "games": 2340,
      "rating": 1681,
      "rd": 30,
      "prog": 10
    },
    "rapid": {
      "games": 2340,
      "rating": 1677,
      "rd": 30,
      "prog": 10
    },
    "classical": {
      "games": 2340,
      "rating": 1618,
      "rd": 30,
      "prog": 10
    }
  },
  "profile": {
    "country": "France",
    "location": "Lille",
    "bio": "test bio",
    "firstName": "John",
    "lastName": "Doe",
    "fideRating": 1800,
    "links": "http://test.com"
  }
}
''';
