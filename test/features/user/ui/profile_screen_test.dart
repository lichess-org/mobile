import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';
import 'package:lichess_mobile/src/features/user/ui/profile_screen.dart';
import 'package:lichess_mobile/src/features/auth/data/auth_repository.dart';
import '../../auth/data/fake_auth_repository.dart';
import '../../../utils.dart';

class MockClient extends Mock implements http.Client {}

class MockApiClient extends Mock implements ApiClient {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockClient = MockClient();
  final mockLogger = MockLogger();

  setUpAll(() {
    when(
      () => mockClient.get(
          Uri.parse(
              '$kLichessHost/api/games/user/$testUserId?max=10&moves=false&lastFen=true'),
          headers: any(
              named: 'headers',
              that: sameHeaders({'Accept': 'application/x-ndjson'}))),
    ).thenAnswer((_) => mockResponse(userGameResponse, 200));
  });

  group('ProfileScreen', () {
    testWidgets('meets accessibility guidelines', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      final app = await buildTestApp(
        tester,
        home: Consumer(builder: (context, ref, _) {
          return const ProfileScreen();
        }),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider
                .overrideWithValue(FakeAuthRepository(testUser)),
            apiClientProvider
                .overrideWithValue(ApiClient(mockLogger, mockClient)),
          ],
          child: app,
        ),
      );

      // wait for auth state
      await tester.pump();

      // profile user name at the top
      expect(find.widgetWithText(ListTile, testUserName), findsOneWidget);

      // wait for recent games
      await tester.pump(const Duration(milliseconds: 50));

      await meetsTapTargetGuideline(tester);

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      if (debugDefaultTargetPlatformOverride == TargetPlatform.android) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
    }, variant: kPlatformVariant);

    testWidgets('should see recent games', (WidgetTester tester) async {
      final app = await buildTestApp(
        tester,
        home: Consumer(builder: (context, ref, _) {
          return const ProfileScreen();
        }),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider
                .overrideWithValue(FakeAuthRepository(testUser)),
            apiClientProvider
                .overrideWithValue(ApiClient(mockLogger, mockClient)),
          ],
          child: app,
        ),
      );

      // wait for auth state
      await tester.pump();

      // profile user name at the top
      expect(find.widgetWithText(ListTile, testUserName), findsOneWidget);

      // wait for recent games
      await tester.pump(const Duration(milliseconds: 50));

      // opponent in recent games
      expect(find.widgetWithText(ListTile, 'maia1'), findsNWidgets(3));
    }, variant: kPlatformVariant);
  });
}

const testUserName = 'FakeUserName';
const testUserId = UserId('fakeuserid');
final userGameResponse = '''
{"id":"rfBxF2P5","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1672074461465,"lastMoveAt":1672074683485,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1397}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
{"id":"msAKIkqp","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671791341158,"lastMoveAt":1671791589063,"status":"resign","players":{"white":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1399},"black":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
{"id":"7Jxi9mBF","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671100908073,"lastMoveAt":1671101322211,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1410}},"winner":"white","clock":{"initial":300,"increment":3,"totalTime":420,"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"}}
''';

final testUser = User(
  id: testUserId,
  username: testUserName,
  createdAt: DateTime.now(),
  seenAt: DateTime.now(),
  perfs: {
    Perf.ultraBullet: _fakePerf,
    Perf.bullet: _fakePerf,
    Perf.blitz: _fakePerf,
    Perf.rapid: _fakePerf,
    Perf.classical: _fakePerf,
    Perf.correspondence: _fakePerf,
    Perf.chess960: _fakePerf,
    Perf.antichess: _fakePerf,
    Perf.kingOfTheHill: _fakePerf,
    Perf.threeCheck: _fakePerf,
    Perf.atomic: _fakePerf,
    Perf.horde: _fakePerf,
    Perf.racingKings: _fakePerf,
    Perf.crazyhouse: _fakePerf,
    Perf.puzzle: _fakePerf,
    Perf.storm: _fakePerf,
  },
);

const _fakePerf = UserPerf(
    rating: 1500, ratingDeviation: 0, progression: 0, numberOfGames: 0);
