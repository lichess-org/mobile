import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
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
    reset(mockClient);
    when(
      () => mockClient.get(
          Uri.parse('$kLichessHost/api/games/user/$testUserId?max=10'),
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

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

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
    });
  });
}

const testUserName = 'FakeUserName';
const testUserId = 'fakeuserid';
const userGameResponse = '''
{"id":"rfBxF2P5","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1672074461465,"lastMoveAt":1672074683485,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1397}},"winner":"white","moves":"e4 e5 Nf3 d6 Bc4 Nf6 Nc3 Nc6 O-O Be7 d3 O-O Nh4 Bg4 Qd2 Nd4 Nf5 Bxf5 exf5 Nxf5 Nd5 Nxd5 Bxd5 c6 Be4 Nd4 c3 Ne6 d4 exd4 cxd4 d5 Bc2 Bg5 Qd3 Bxc1 Qxh7#","clock":{"initial":300,"increment":3,"totalTime":420}}
{"id":"msAKIkqp","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671791341158,"lastMoveAt":1671791589063,"status":"resign","players":{"white":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1399},"black":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178}},"winner":"white","moves":"e4 e5 Nf3 Nc6 Bb5 Nf6 Bxc6 dxc6 Nxe5 Qd4 Nf3 Qxe4+ Qe2 Bc5 Qxe4+ Nxe4 O-O O-O d3 Nf6 Bg5 Nh5 Nc3 Bg4 Ne5 f5 Nd7 Rf7 Nxc5 Raf8 Nxb7 f4 f3 Bc8 Nc5 Rf5 N5e4 Nf6 Bxf6 gxf6 Rae1","clock":{"initial":300,"increment":3,"totalTime":420}}
{"id":"7Jxi9mBF","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671100908073,"lastMoveAt":1671101322211,"status":"mate","players":{"white":{"user":{"name":"$testUserName","patron":true,"id":"$testUserId"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1410}},"winner":"white","moves":"e4 e5 Nf3 Nc6 Nc3 Nf6 Bb5 d6 O-O Bd7 Bxc6 Bxc6 d4 exd4 Nxd4 Bxe4 Nxe4 Nxe4 Re1 d5 f3 Bc5 fxe4 dxe4 Rxe4+ Be7 Bg5 f6 Bf4 O-O Ne6 Qxd1+ Rxd1 Rfe8 Bxc7 Rac8 c4 Bc5+ Kh1 b6 Bd6 Bxd6 Rxd6 f5 Rf4 g6 g3 Kf7 Ng5+ Kg7 Rd7+ Kh6 h4 Re1+ Kg2 Re2+ Kf3 Rxb2 Rxh7#","clock":{"initial":300,"increment":3,"totalTime":420}}
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
