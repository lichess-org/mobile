import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/ui/account/profile_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import '../../test_utils.dart';
import '../../test_app.dart';
import '../../model/auth/fake_session_storage.dart';

void main() {
  final mockClient = MockClient((request) {
    if (request.url.path == '/api/games/user/$testUserId') {
      return mockResponse(userGameResponse, 200);
    } else if (request.url.path == '/api/account') {
      return mockResponse(testAccountResponse, 200);
    }
    return mockResponse('', 404);
  });

  group('ProfileScreen', () {
    testWidgets(
      'should see recent games',
      (WidgetTester tester) async {
        final app = await buildTestApp(
          tester,
          home: const ProfileScreen(),
          overrides: [
            httpClientProvider.overrideWithValue(mockClient),
          ],
          userSession: fakeSession,
        );

        await tester.pumpWidget(app);

        // wait for account
        await tester.pump(const Duration(milliseconds: 50));

        // profile user name at the top
        expect(
          find.widgetWithText(PlayerTitle, testUserName),
          // on iOS 2 widgets are inserted in the tree: 1 for the large title, 1 for the collapted title
          findsAtLeastNWidgets(1),
        );

        // wait for recent games
        await tester.pump(const Duration(milliseconds: 50));

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
final userGameResponse = '''
{"id":"rfBxF2P5","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1672074461465,"lastMoveAt":1672074683485,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1397}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
{"id":"msAKIkqp","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671791341158,"lastMoveAt":1671791589063,"status":"resign","players":{"white":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1399},"black":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
{"id":"7Jxi9mBF","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671100908073,"lastMoveAt":1671101322211,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1410}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
''';

final testAccountResponse = '''
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
